import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/config/config.dart';
import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/user/analytics/domain/entity/analytics_entity.dart';
import 'package:poweriot/features/user/analytics/domain/entity/analytics_model.dart';
import 'package:poweriot/features/user/analytics/domain/usecase/fetch_analytics_usecase.dart';

abstract class AnalyticsRemoteDatasource {
  Future<Either<Failure, AnalyticsModel>> fetchAnalyticsDatasource({
    required FetchAnalyticsParams params,
  });
}

class AnalyticsRemoteDatasourceImpl implements AnalyticsRemoteDatasource {
  final DioClient dioClient;
  final SecureStorageService secureStorageService;
  final AppLogger appLogger;
  AnalyticsRemoteDatasourceImpl({
    required this.appLogger,
    required this.dioClient,
    required this.secureStorageService,
  });
  @override
  Future<Either<Failure, AnalyticsModel>> fetchAnalyticsDatasource({
    required FetchAnalyticsParams params,
  }) async {
    final now = DateTime.now();
    DateTime fromDateParsed =
        DateTime.tryParse(params.fromDate) ??
        now.subtract(const Duration(days: 5));
    DateTime toDateParsed = DateTime.tryParse(params.toDate) ?? now;

    if (toDateParsed.isBefore(fromDateParsed)) {
      final temp = fromDateParsed;
      fromDateParsed = toDateParsed;
      toDateParsed = temp;
    }

    final int daysCount = toDateParsed.difference(fromDateParsed).inDays + 1;
    final List<EventHistory> events = [];
    int totalGeneratorStartCount = 0;
    double totalGeneratorOnMinutes = 0.0;
    double totalDowntimeMinutes = 0.0;
    int totalOutageCount = 0;

    for (int i = 0; i < daysCount; i++) {
      final day = DateTime(
        fromDateParsed.year,
        fromDateParsed.month,
        fromDateParsed.day,
      ).add(Duration(days: i));

      int msebStart1, msebEnd1;
      int dgStart1H, dgStart1M, dgEnd1H, dgEnd1M;
      int msebStart2, msebEnd2;
      int dgStart2H, dgStart2M, dgEnd2H, dgEnd2M;
      int msebStart3, msebEnd3;

      switch (i % 3) {
        case 0:
          msebStart1 = 1;
          msebEnd1 = 7;
          dgStart1H = 7;
          dgStart1M = 15;
          dgEnd1H = 9;
          dgEnd1M = 15;
          msebStart2 = 10;
          msebEnd2 = 15;
          dgStart2H = 15;
          dgStart2M = 30;
          dgEnd2H = 17;
          dgEnd2M = 30;
          msebStart3 = 18;
          msebEnd3 = 23;

          totalDowntimeMinutes += 8 * 60;
          totalGeneratorOnMinutes += 4 * 60;
          totalGeneratorStartCount += 2;
          totalOutageCount += 3;
          break;
        case 1:
          msebStart1 = 3;
          msebEnd1 = 9;
          dgStart1H = 9;
          dgStart1M = 30;
          dgEnd1H = 10;
          dgEnd1M = 45;
          msebStart2 = 11;
          msebEnd2 = 17;
          dgStart2H = 17;
          dgStart2M = 15;
          dgEnd2H = 18;
          dgEnd2M = 45;
          msebStart3 = 19;
          msebEnd3 = 22;

          totalDowntimeMinutes += 9 * 60;
          totalGeneratorOnMinutes += 165;
          totalGeneratorStartCount += 2;
          totalOutageCount += 3;
          break;
        case 2:
        default:
          msebStart1 = 2;
          msebEnd1 = 6;
          dgStart1H = 6;
          dgStart1M = 0;
          dgEnd1H = 7;
          dgEnd1M = 30;
          msebStart2 = 8;
          msebEnd2 = 14;
          dgStart2H = 14;
          dgStart2M = 15;
          dgEnd2H = 16;
          dgEnd2M = 15;
          msebStart3 = 17;
          msebEnd3 = 21;

          totalDowntimeMinutes += 10 * 60;
          totalGeneratorOnMinutes += 210;
          totalGeneratorStartCount += 2;
          totalOutageCount += 3;
          break;
      }

      // MSEB ON: segment 1
      events.add(
        EventHistory(
          eventType: 'POWER_RESTORE',
          eventMessage: 'Mains power restored',
          eventTime: day.add(Duration(hours: msebStart1)),
        ),
      );
      events.add(
        EventHistory(
          eventType: 'PHASE_FAILURE',
          eventMessage: 'Mains phase failure detected',
          eventTime: day.add(Duration(hours: msebEnd1)),
        ),
      );

      // Generator ON: segment 1
      events.add(
        EventHistory(
          eventType: 'DG_STARTED',
          eventMessage: 'Generator started',
          eventTime: day.add(Duration(hours: dgStart1H, minutes: dgStart1M)),
        ),
      );
      events.add(
        EventHistory(
          eventType: 'DG_STOPPED',
          eventMessage: 'Generator stopped',
          eventTime: day.add(Duration(hours: dgEnd1H, minutes: dgEnd1M)),
        ),
      );

      // MSEB ON: segment 2
      events.add(
        EventHistory(
          eventType: 'POWER_RESTORE',
          eventMessage: 'Mains power restored',
          eventTime: day.add(Duration(hours: msebStart2)),
        ),
      );
      events.add(
        EventHistory(
          eventType: 'PHASE_FAILURE',
          eventMessage: 'Mains phase failure detected',
          eventTime: day.add(Duration(hours: msebEnd2)),
        ),
      );

      // Generator ON: segment 2
      events.add(
        EventHistory(
          eventType: 'DG_STARTED',
          eventMessage: 'Generator started',
          eventTime: day.add(Duration(hours: dgStart2H, minutes: dgStart2M)),
        ),
      );
      events.add(
        EventHistory(
          eventType: 'DG_STOPPED',
          eventMessage: 'Generator stopped',
          eventTime: day.add(Duration(hours: dgEnd2H, minutes: dgEnd2M)),
        ),
      );

      // MSEB ON: segment 3
      events.add(
        EventHistory(
          eventType: 'POWER_RESTORE',
          eventMessage: 'Mains power restored',
          eventTime: day.add(Duration(hours: msebStart3)),
        ),
      );
      events.add(
        EventHistory(
          eventType: 'PHASE_FAILURE',
          eventMessage: 'Mains phase failure detected',
          eventTime: day.add(Duration(hours: msebEnd3)),
        ),
      );
    }

    AnalyticsModel model = AnalyticsModel(
      alarmHistory: [],
      applicationType: "MG",
      eventHistory: events,
      generatorAnalytics: GeneratorAnalytics(
        batteryVoltage: 12,
        dailyFuelConsumption: 21,
        dgFaultStatus: false,
        fuelLevel: 33,
        fuelTheftDetected: 33,
        generatorHealthStatus: "GOOD",
        generatorOnDuration:
            "${(totalGeneratorOnMinutes / 60).toStringAsFixed(1)} Hours",
        generatorStartCount: totalGeneratorStartCount,
        generatorStopCount: totalGeneratorStartCount,
        maintenanceServiceStatus: "",
        monthlyFuelConsumption: 34,
        overloadStatus: false,
      ),
      mainsAnalytics: MainsAnalytics(
        averageFrequency: 34,
        averageVoltage: 312,
        downtimeDurationMinutes:
            "${(totalDowntimeMinutes / 60).toStringAsFixed(1)} Hours",
        lastPowerFailureTime: now,
        lastPowerRestoreTime: now,
        outageCountPerDay: totalOutageCount,
        phaseFailureCount: totalOutageCount,
        powerFailureDurationMinutes: totalDowntimeMinutes,
      ),
    );

    try {
      final String? token = await secureStorageService.read(storedToken);

      final dio = dioClient.dio;
      final response = await dio.get(
        analyticsEndpoint(
          deviceID: params.userDevice.toString(),
          fromDate: params.fromDate,
          toDate: params.toDate,
        ),
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        AnalyticsModel modellist = AnalyticsModel.fromJson(response.data);
        if ("4324abe7-c42d-4570-8754-357c55041ac0" ==
            params.userDevice.toString()) {
          return right(model);
        }
        return right(modellist);
      } else {
        AppLogger().error("else section for the status code ");
        // return right(model);
        return left(DataNotFoundFailure('data not found'));
      }
    } on DioException catch (dioE) {
      // return right(model);
      final statusCode = dioE.response?.statusCode;
      final message =
          dioE.response!.data['message']?.toString() ??
          dioE.message ??
          'Something went wrong ana';

      if (statusCode == 404) {
        return left(DataNotFoundFailure(message));
      } else if (statusCode == 401) {
        return left(DataNotFoundFailure(message));
      } else if (statusCode == 403) {
        return left(DataNotFoundFailure(message));
      } else {
        return left(ServerFailure(message));
      }

      // return right(model);
    } catch (e, trace) {
      appLogger.error("error while fetching analytic api $e \n Trace $trace");

      // return right(model);
      return left(ServerFailure('something went wrong error'));
    }
  }
}

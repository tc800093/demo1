import 'package:poweriot/core/utils/dummy_data_generator.dart';
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
    // ==========================================
    // [DUMMY DATA GENERATOR] - DEMO PURPOSES ONLY
    // This section dynamically generates historical events, outage,
    // and daily/monthly fuel consumption metrics for selected dates.
    // ==========================================
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

      final dayEvents = DummyDataGenerator.generateEventsForDay(day);

      for (var ev in dayEvents) {
        totalDowntimeMinutes += ev.durationMinutes;
        totalGeneratorOnMinutes += ev.durationMinutes;
        totalGeneratorStartCount += 1;
        totalOutageCount += 1;

        events.add(
          EventHistory(
            eventType: 'PHASE_FAILURE',
            eventMessage: 'Mains phase failure detected',
            eventTime: ev.mainsFailureTime,
          ),
        );

        events.add(
          EventHistory(
            eventType: 'DG_STARTED',
            eventMessage: 'Generator started automatically',
            eventTime: ev.dgStartTime,
          ),
        );

        events.add(
          EventHistory(
            eventType: 'POWER_RESTORE',
            eventMessage: 'Mains power restored',
            eventTime: ev.powerRestoreTime,
          ),
        );

        events.add(
          EventHistory(
            eventType: 'DG_STOPPED',
            eventMessage: 'Generator stopped',
            eventTime: ev.dgStopTime,
          ),
        );
      }
    }

    // Sort events chronologically to ensure they are in order
    events.sort((a, b) => a.eventTime!.compareTo(b.eventTime!));

    final double computedDailyFuel = (totalGeneratorOnMinutes * 0.12) / daysCount;
    final double computedMonthlyFuel = computedDailyFuel * 30.0;

    AnalyticsModel model = AnalyticsModel(
      alarmHistory: [],
      applicationType: "MG",
      eventHistory: events,
      generatorAnalytics: GeneratorAnalytics(
        batteryVoltage: 12.8,
        dailyFuelConsumption: computedDailyFuel,
        dgFaultStatus: false,
        fuelLevel: 68.5,
        fuelTheftDetected: 0,
        generatorHealthStatus: "GOOD",
        generatorOnDuration:
            "${(totalGeneratorOnMinutes / 60).toStringAsFixed(1)} Hours",
        generatorStartCount: totalGeneratorStartCount,
        generatorStopCount: totalGeneratorStartCount,
        maintenanceServiceStatus: "",
        monthlyFuelConsumption: computedMonthlyFuel,
        overloadStatus: false,
      ),
      mainsAnalytics: MainsAnalytics(
        averageFrequency: 49.9,
        averageVoltage: 231.5,
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
        AppLogger().error("else section for the status code - falling back to dummy data");
        return right(model);
      }
    } on DioException catch (dioE) {
      AppLogger().error("DioException in fetchAnalytics - falling back to dummy data: $dioE");
      return right(model);
    } catch (e, trace) {
      appLogger.error("error while fetching analytic api $e - falling back to dummy data \n Trace $trace");
      return right(model);
    }
  }
}

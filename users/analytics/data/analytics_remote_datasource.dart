import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/config/config.dart';
import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/users/analytics/domain/entity/analytics_entity.dart';
import 'package:poweriot/features/users/analytics/domain/usecase/fetch_analytics_usecase.dart';

abstract class AnalyticsRemoteDatasource {
  Future<Either<Failure, AnalyticsModel>> fetchAnalyticsDatasource({
    required FetchAnalyticsParams params,
  });
}

List<EventHistory> list = [
  EventHistory(
    eventType: "POWER_FALURE",
    eventMessage: "Power Failure",
    eventTime: DateTime.parse('2026-06-01T02:15:00'),
  ),

  EventHistory(
    eventType: "DG_STARTED",
    eventMessage: "Generator Started",
    eventTime: DateTime.parse('2026-06-01T02:16:30'),
  ),

  EventHistory(
    eventType: "POWER_RESTORE",
    eventMessage: "Power Restored",
    eventTime: DateTime.parse('2026-06-01T03:42:15'),
  ),

  EventHistory(
    eventType: "DG_STOPPED",
    eventMessage: "Generator Stopped",
    eventTime: DateTime.parse('2026-06-01T03:43:20'),
  ),

  EventHistory(
    eventType: "POWER_FALURE",
    eventMessage: "Power Failure",
    eventTime: DateTime.parse('2026-06-02T08:12:00'),
  ),

  EventHistory(
    eventType: "DG_STARTED",
    eventMessage: "Generator Started",
    eventTime: DateTime.parse('2026-06-02T08:13:10'),
  ),

  EventHistory(
    eventType: "POWER_RESTORE",
    eventMessage: "Power Restored",
    eventTime: DateTime.parse('2026-06-02T09:28:45'),
  ),

  EventHistory(
    eventType: "DG_STOPPED",
    eventMessage: "Generator Stopped",
    eventTime: DateTime.parse('2026-06-02T09:29:30'),
  ),

  EventHistory(
    eventType: "POWER_FALURE",
    eventMessage: "Power Failure",
    eventTime: DateTime.parse('2026-06-03T14:25:20'),
  ),

  EventHistory(
    eventType: "DG_STARTED",
    eventMessage: "Generator Started",
    eventTime: DateTime.parse('2026-06-03T14:26:00'),
  ),

  EventHistory(
    eventType: "POWER_RESTORE",
    eventMessage: "Power Restored",
    eventTime: DateTime.parse('2026-06-03T15:47:10'),
  ),

  EventHistory(
    eventType: "DG_STOPPED",
    eventMessage: "Generator Stopped",
    eventTime: DateTime.parse('2026-06-03T15:48:05'),
  ),
];

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
    AnalyticsModel model = AnalyticsModel(
      alarmHistory: [],
      applicationType: "MG",
      eventHistory: list,
      generatorAnalytics: GeneratorAnalytics(
        batteryVoltage: 12,
        dailyFuelConsumption: 21,
        dgFaultStatus: false,
        fuelLevel: 33,
        fuelTheftDetected: 33,
        generatorHealthStatus: "GOOD",
        generatorOnDuration: "MSKMS",
        generatorStartCount: 2,
        generatorStopCount: 2,
        maintenanceServiceStatus: "",
        monthlyFuelConsumption: 34,
        overloadStatus: false,
      ),
      msebAnalytics: MsebAnalytics(
        averageFrequency: 34,
        averageVoltage: 312,
        downtimeDurationMinutes: 30,
        lastPowerFailureTime: DateTime.now(),
        lastPowerRestoreTime: DateTime.now(),
        outageCountPerDay: 2,
        phaseFailureCount: 2,
        powerFailureDurationMinutes: 1,
      ),
    );
    return right(model);
  }
}

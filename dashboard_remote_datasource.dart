import 'dart:developer';
import 'package:poweriot/core/utils/dummy_data_generator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/config/config.dart';
import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/domain/model/my_subscription_model.dart';

/// Remote data source for retrieving dashboard data.
abstract class DashboardRemoteDatasource {
  /// Fetches the latest dashboard data from the API call.
  Future<Either<Failure, List<DashboardModel>>>
  fetchDashboardRemoteDataSource();

  /// Fetches the User subscription plan from the API call.
  Future<Either<Failure, MySubscriptionModel>>
  fetchMySubscriptionRemoteDataSource();
}

/// Implementation of the remote dashboard data source.
/// Communicating with the API.
/// Fetching the latest dashboard data.
/// Mapping the API response to application models.
/// Handling network and server exceptions.
class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final DioClient dioClient;
  final AppLogger appLogger;
  final SecureStorageService secureStorageService;
  DashboardRemoteDatasourceImpl({
    required this.appLogger,
    required this.dioClient,
    required this.secureStorageService,
  });

  /// Sends a request to Fetch the latest dashboard data.
  @override
  Future<Either<Failure, List<DashboardModel>>>
  fetchDashboardRemoteDataSource() async {
    try {
      // ==========================================
      // [DUMMY DATA GENERATOR] - DEMO PURPOSES ONLY
      // This section generates mock real-time telemetry data 
      // for dashboard gauges and statuses.
      // ==========================================
      final now = DateTime.now();
      final dayEvents = DummyDataGenerator.generateEventsForDay(now);
      
      bool isOutage = false;
      for (var ev in dayEvents) {
        if (now.isAfter(ev.mainsFailureTime) && now.isBefore(ev.powerRestoreTime)) {
          isOutage = true;
          break;
        }
      }

      List<DashboardModel> dummyData = [
        DashboardModel(
          deviceId: "4324abe7-c42d-4570-8754-357c55041ac0",
          deviceName: "Demo IoT System",
          currentPowerSource: isOutage ? "Generator" : "Mains",
          applicationType: "MG",
          locationName: "Primary Site",
          isLive: true,
          lastUpdated: now,
          mains: MainsModel(
            status: !isOutage,
            phaseFailure: isOutage,
            voltage: isOutage ? 0.0 : 231.5,
            frequency: isOutage ? 0.0 : 49.9,
            outageCount: 3,
            currnet: isOutage ? "0.0" : "14.2",
            dailyConsumption: 5.5,
            rPhaseStatus: !isOutage,
            yPhaseStatus: !isOutage,
            bPhaseStatus: !isOutage,
            billingCycleStart: "2026-07-01T00:00:00",
            billingCycleEnd: "2026-07-31T23:59:59",
            outageDurationMinutes: 180.0,
            electricityConsumption: 165.8,
            meterReading: "1234.5",
          ),
          generator: Generator(
            status: isOutage,
            fuelLevel: 68.5,
            engineTemperature: isOutage ? 75.0 : 42.0,
            oilPressure: isOutage ? 4.2 : 0.0,
            batteryVoltage: 12.7,
            runtimeHours: 345.5,
            startCount: 12,
            generatorHealth: "GOOD",
            dgStatus: isOutage ? "RUNNING" : "STOPPED",
            outputVoltage: isOutage ? 230.0 : 0.0,
            dailyFuelConsumption: 5.5,
            estimatedRuntime: 12.4,
            fullTankRuntime: 18.0,
          ),
        )
      ];

      return right(dummyData);
      // ------------------------------------

      String? storedUserID = await secureStorageService.read(userID);

      String? token = await secureStorageService.read(storedToken);
      final dio = dioClient.dio;
      final result = await dio.get(
        dashboardEndpoint(userid: storedUserID.toString(), page: 0, size: 10),
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );

      if (result.statusCode == 200) {
        if (result.data['content'] != null &&
            result.data['content'].isNotEmpty) {
          List<DashboardModel> dashboardModel =
              (result.data['content'] as List<dynamic>)
                  .map<DashboardModel>((d) => DashboardModel.fromJson(d))
                  .toList();

          return right(dashboardModel);
        } else {
          return left(DataNotFoundFailure("Reading not found"));
        }
      } else {
        return left(DataNotFoundFailure("Data not found"));
      }
    } catch (e, trace) {
      AppLogger().error(
        "Error while fetcing dashboard api ${e.toString()}\n trace: ${trace.toString()}",
      );
      return left(ServerFailure('something went wrong'));
    }
  }

  /// Sends a request to Fetch the user current active plan.
  @override
  Future<Either<Failure, MySubscriptionModel>>
  fetchMySubscriptionRemoteDataSource() async {
    try {
      String? token = await secureStorageService.read(storedToken);
      final dio = dioClient.dio;
      final response = await dio.get(
        fetchMySubscriptionEndpoint,
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          MySubscriptionModel mySubscriptionModel =
              MySubscriptionModel.fromJson(response.data['data']);

          return right(mySubscriptionModel);
        } else {
          return left(DataNotFoundFailure('No subscription'));
        }
      } else {
        return left(DataNotFoundFailure('No subscription'));
      }
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }
}

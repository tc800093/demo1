import 'package:dartz/dartz.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/user/dashboard/data/datasources/local_datasource/dashboard_local_datasource.dart';
import 'package:poweriot/features/user/dashboard/data/datasources/remote_datasource/dashboard_remote_datasource.dart';
import 'package:poweriot/features/user/dashboard/data/datasources/remote_datasource/dashboard_remote_websocket_datasource.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/domain/model/my_subscription_model.dart';

// Repository Methods
// Defines the Dashboard operations available to the domain layer.

final List<DashboardModel> dummyDashboardData = [
  DashboardModel(
    isLive: true,
    deviceId: "DEV001",
    deviceName: "Generator Panel - A",
    currentPowerSource: "MAINS",
    applicationType: "MG",
    locationName: "Mumbai Plant",
    lastUpdated: DateTime.now(),
    mains: MainsModel(
      status: true,
      phaseFailure: false,
      voltage: 231.5,
      frequency: 49.9,
      outageCount: 2,
      electricityConsumption: 1450.8,
      dailyConsumption: 48.6,
      phaseType: "THREE_PHASE",
      rPhaseStatus: true,
      yPhaseStatus: true,
      bPhaseStatus: true,
      currnet: "15.8",
      outageDuratioHours: 25,
    ),
    generator: Generator(
      status: false,
      autoManualMode: "AUTO",
      fuelLevel: 78.5,
      engineTemperature: 74.3,
      oilPressure: 4.2,
      batteryVoltage: 12.7,
      alternatorVoltage: 415,
      runtimeHours: 152.5,
      startCount: 38,
      overloadStatus: false,
      emergencyStopStatus: false,
      dgFaultStatus: false,
      current: 0.0,
      dgStatus: "STOPPED",
      outputVoltage: 0,
      warningMessage: "",
      generatorHealth: "GOOD",
    ),
  ),

  DashboardModel(
    isLive: true,
    deviceId: "DEV002",
    deviceName: "Generator Panel - B",
    currentPowerSource: "GENERATOR",
    applicationType: "MG",
    locationName: "Pune Warehouse",
    lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
    mains: MainsModel(
      status: false,
      phaseFailure: true,
      voltage: 0,
      frequency: 0,
      outageCount: 5,
      electricityConsumption: 920.3,
      dailyConsumption: 35.4,
      phaseType: "THREE_PHASE",
      rPhaseStatus: false,
      yPhaseStatus: false,
      bPhaseStatus: false,
      currnet: '0',
      outageDuratioHours: 145,
    ),
    generator: Generator(
      status: true,
      autoManualMode: "AUTO",
      fuelLevel: 42.0,
      engineTemperature: 91.8,
      oilPressure: 3.8,
      batteryVoltage: 12.3,
      alternatorVoltage: 415,
      runtimeHours: 438.7,
      startCount: 126,
      overloadStatus: false,
      emergencyStopStatus: false,
      dgFaultStatus: false,
      current: 24.6,
      dgStatus: "RUNNING",
      outputVoltage: 414.2,
      warningMessage: "Low fuel level",
      generatorHealth: "AVERAGE",
    ),
  ),
];

abstract class DashboardRepository {
  ///
  Future<Either<Failure, List<DashboardModel>>> fetchDashboardRepo();
  Future<Either<Failure, MySubscriptionModel>> fetchMySubscriptionRepo();
  Stream<DashboardModel> dashboardStream();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource dashboardRemoteDatasource;
  final DashboardLocalDatasource dashboardLocalDatasource;
  final SecureStorageService secureStorageService;
  final DashboardWebSocketDatasource dashboardWebSocketDatasource;
  DashboardRepositoryImpl({
    required this.dashboardRemoteDatasource,
    required this.dashboardLocalDatasource,
    required this.secureStorageService,
    required this.dashboardWebSocketDatasource,
  });
  @override
  Future<Either<Failure, List<DashboardModel>>> fetchDashboardRepo() async {
    try {
      final String? mobile = await secureStorageService.read(userMobile);

      // if (mobile == "8668376751") {
      // List<PowerTelemetry2> dummyData = DummyLoader().generateDashboard(
      //   telemetry: ,
      //   fromDate: DateTime(2026, 07, 10, 00, 00, 00),
      //   toDate: DateTime.now(),
      // );

      // dummyData.forEach((e) {
      //   e.printStatus();
      // });

      // List<PowerTelemetry2> data = await DummyLoader().fetchData();

      // DashboardModel dsh = DummyLoader().generateDashboard(
      //   telemetry: data,
      //   fromDate: DateTime(2026, 07, 01, 00, 00),
      //   toDate: DateTime.now(),
      // );

      // return right([dsh]);
      // }
      final result = await dashboardRemoteDatasource
          .fetchDashboardRemoteDataSource();
      return await result.fold(
        (failed) async {
          final localResult = await dashboardLocalDatasource
              .fetchDashboardLatestLocalDataSource();

          return localResult.fold(
            (failedLocal) {
              return left(failed);
            },
            (localData) {
              List<DashboardModel> dashboardList = localData
                  .map((e) => e.copyWith(isLive: false))
                  .toList();
              // return right([
              //   dsh.copyWith(
              //     deviceId: "DEV002",
              //     deviceName: "Generator Panel - B",
              //     currentPowerSource: "GENERATOR",
              //     applicationType: "MG",
              //     locationName: "Pune Warehouse",
              //   ),
              // ]);
              return right(dashboardList);
            },
          );
        },

        (success) async {
          List<DashboardModel> dashboardList = success
              .map((e) => e.copyWith(isLive: true))
              .toList();
          await dashboardLocalDatasource.saveOrUpdateDashboardLocalDataSource(
            dashboarAPIList: dashboardList,
          );

          return right(dashboardList);

          // return right([
          //   dsh.copyWith(
          //     deviceId: "DEV002",
          //     deviceName: "Generator Panel - B",
          //     currentPowerSource: "GENERATOR",
          //     applicationType: "MG",
          //     locationName: "Pune Warehouse",
          //   ),
          // ]);
        },
      );
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, MySubscriptionModel>> fetchMySubscriptionRepo() async {
    return await dashboardRemoteDatasource
        .fetchMySubscriptionRemoteDataSource();
  }

  @override
  Stream<DashboardModel> dashboardStream() {
    return dashboardWebSocketDatasource.dashboardStream();
  }
}

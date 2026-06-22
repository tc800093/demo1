import 'package:dartz/dartz.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/users/dashboard/domain/model/dashboard_model.dart';

abstract class DashboardRemoteDatasource {
  Future<Either<Failure, DashboardModel>> fetchDashboardRemoteDataSource();
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final DioClient dioClient;
  final AppLogger appLogger;
  final SecureStorageService secureStorageService;
  DashboardRemoteDatasourceImpl({
    required this.appLogger,
    required this.dioClient,
    required this.secureStorageService,
  });
  @override
  Future<Either<Failure, DashboardModel>>
  fetchDashboardRemoteDataSource() async {
    final String? sourceType = await secureStorageService.read(sourceTypeStored);

    Mseb? msebData;
    Generator? generatorData;
    String powerSource = "mseb";

    if (sourceType == "MG" || sourceType == "1") {
      powerSource = "mseb";
      msebData = Mseb(
        current: 230,
        frequency: 50,
        outageCount: 2,
        outageDuration: 120,
        phaseType: "THREE_PHASE",
        status: true,
        unitConsumption: 122,
        voltage: 230,
      );
      generatorData = Generator(
        engineTemperature: 48,
        fuelLevel: 50,
        generatorLoadKw: 30,
        healthStatus: "GOOD",
        oilPressure: 34,
        outputVoltage: 234,
        runtimeMinutes: 42,
        startCount: 2,
        status: false,
        warningMessage: 'false',
        warningStatus: true,
      );
    } else if (sourceType == "DG" || sourceType == "2") {
      powerSource = "generator";
      generatorData = Generator(
        engineTemperature: 65,
        fuelLevel: 75,
        generatorLoadKw: 45,
        healthStatus: "GOOD",
        oilPressure: 42,
        outputVoltage: 240,
        runtimeMinutes: 120,
        startCount: 5,
        status: true,
        warningMessage: 'none',
        warningStatus: false,
      );
    } else if (sourceType == "MSEB" || sourceType == "mains" || sourceType == "3") {
      powerSource = "mseb";
      msebData = Mseb(
        current: 240,
        frequency: 50,
        outageCount: 0,
        outageDuration: 0,
        phaseType: "THREE_PHASE",
        status: true,
        unitConsumption: 245,
        voltage: 240,
      );
    } else {
      // Default fallback
      powerSource = "mseb";
      msebData = Mseb(
        current: 230,
        frequency: 50,
        outageCount: 2,
        outageDuration: 120,
        phaseType: "THREE_PHASE",
        status: true,
        unitConsumption: 122,
        voltage: 230,
      );
      generatorData = Generator(
        engineTemperature: 48,
        fuelLevel: 50,
        generatorLoadKw: 30,
        healthStatus: "GOOD",
        oilPressure: 34,
        outputVoltage: 234,
        runtimeMinutes: 42,
        startCount: 2,
        status: false,
        warningMessage: 'false',
        warningStatus: true,
      );
    }

    DashboardModel test = DashboardModel(
      currentPowerSource: powerSource,
      lastUpdated: DateTime.now(),
      mseb: msebData,
      generator: generatorData,
    );
    return right(test);
  }
}

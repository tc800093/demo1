import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:poweriot/core/common/domain/model/generator_refuel_history_model.dart';
import 'package:poweriot/core/common/domain/usecase/add_generator_Refuel_record_usecase.dart';
import 'package:poweriot/core/common/domain/usecase/add_generator_service_record_usecase.dart';
import 'package:poweriot/core/config/config.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/core/common/domain/model/generator_service_history_model.dart';

abstract class MaintenanceLogRemoteDataSource {
  Future<Either<Failure, List<GeneratorServiceHistoryModel>>>
  fetchGeneratorServiceHistoryByDeviceID({required String deviceID});

  Future<Either<Failure, GeneratorServiceHistoryModel>>
  addGeneratorServiceServiceRecordByDeviceID({
    required AddGeneratorServiceRecordParams params,
  });

  Future<Either<Failure, List<GeneratorRefuelHistoryModel>>>
  fetchGeneratorRefuelHistoryByDeviceID({required String deviceID});

  Future<Either<Failure, bool>> addGeneratorRefuelRecordByDeviceID({
    required AddGeneratorRefuelRecordParams params,
  });
}

class MaintenanceLogRemoteDataSourceImpl
    implements MaintenanceLogRemoteDataSource {
  final DioClient dioClient;
  final SecureStorageService secureStorageService;
  final AppLogger appLogger;
  MaintenanceLogRemoteDataSourceImpl({
    required this.appLogger,
    required this.dioClient,
    required this.secureStorageService,
  });

  @override
  Future<Either<Failure, List<GeneratorServiceHistoryModel>>>
  fetchGeneratorServiceHistoryByDeviceID({required String deviceID}) async {
    try {
      final dio = dioClient.dio;

      final String? token = await secureStorageService.read(refreshedToken);
      final response = await dio.get(
        generatorServiceHistoryEndpoint(deviceId: deviceID.toString()),
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );
      appLogger.debug("this api response for service history ${response.data}");
      if (response.statusCode == 200) {
        List<GeneratorServiceHistoryModel> history =
            (response.data['data'] as List<dynamic>)
                .map<GeneratorServiceHistoryModel>(
                  (d) => GeneratorServiceHistoryModel.fromJson(d),
                )
                .toList();
        history.sort((a, b) => b.serviceDate!.compareTo(a.serviceDate!));
        return right(history);
      } else {
        return left(DataNotFoundFailure('message'));
      }
    } catch (e, trace) {
      appLogger.error("error $e and $trace");
      // Fallback dummy service history list for testing
      return right([
        GeneratorServiceHistoryModel(
          id: 'svc_001',
          deviceId: deviceID,
          serviceDate: DateTime.now().subtract(const Duration(days: 30)),
          serviceType: 'Routine Oil Change',
          serviceProvider: 'Local Service Tech',
          cost: 1500.0,
          remarks: 'Standard service completed successfully.',
          nextServiceDate: DateTime.now().add(const Duration(days: 60)),
        ),
      ]);
    }
  }

  @override
  Future<Either<Failure, GeneratorServiceHistoryModel>>
  addGeneratorServiceServiceRecordByDeviceID({
    required AddGeneratorServiceRecordParams params,
  }) async {
    try {
      final dio = dioClient.dio;

      final String? token = await secureStorageService.read(refreshedToken);
      final response = await dio.post(
        addGeneratorServiceRecordEndpoint,
        options: Options(headers: {'Authorization': "Bearer $token"}),
        data: {
          "deviceId": params.deviceId,
          "serviceDate": params.serviceDate,
          "serviceType": params.serviceType.toString(),
          "serviceProvider": params.serviceProvider,
          "nextServiceDate": params.nextServiceDate,
          "cost": params.cost,
          "remarks": params.remarks.toString(),
        },
      );
      appLogger.debug(
        "this api response for  add service service  ${response.data}",
      );
      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          GeneratorServiceHistoryModel model =
              GeneratorServiceHistoryModel.fromJson(response.data['data']);
          return right(model);
        } else {
          return left(DataNotFoundFailure("failed to add record"));
        }
      } else {
        return left(DataNotFoundFailure('message'));
      }
    } catch (e, trace) {
      appLogger.error(" add service record error $e and $trace");
      return left(ServerFailure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, bool>> addGeneratorRefuelRecordByDeviceID({
    required AddGeneratorRefuelRecordParams params,
  }) async {
    try {
      final dio = dioClient.dio;

      final String? token = await secureStorageService.read(refreshedToken);
      final response = await dio.post(
        addGeneratorRefuelRecordEndpoint,
        options: Options(headers: {'Authorization': "Bearer $token"}),
        data: {
          "deviceId": params.deviceId,
          "refuelDate": params.refuelDate,
          "fuelQuantity": params.fuelQuantity,
          "fuelRate": params.fuelRate,
          "totalCost": params.totalCost,
          "remarks": params.remarks,
        },
      );
      appLogger.debug("this api response for refuel record ${response.data}");
      if (response.statusCode == 200 && response.data['success'] == true) {
        return right(true);
      } else {
        return left(DataNotFoundFailure('message'));
      }
    } catch (e, trace) {
      appLogger.error("error $e and $trace");
      return left(ServerFailure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<GeneratorRefuelHistoryModel>>>
  fetchGeneratorRefuelHistoryByDeviceID({required String deviceID}) async {
    try {
      final dio = dioClient.dio;
      final String? token = await secureStorageService.read(refreshedToken);
      final response = await dio.get(
        generatorRefuelHistoryEndpoint(deviceId: deviceID.toString()),
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );
      appLogger.debug("this api response for refuel history ${response.data}");
      if (response.statusCode == 200) {
        List<GeneratorRefuelHistoryModel> history =
            (response.data['data'] as List<dynamic>)
                .map<GeneratorRefuelHistoryModel>(
                  (d) => GeneratorRefuelHistoryModel.fromJson(d),
                )
                .toList();
        history.sort((a, b) => b.refuelDate!.compareTo(a.refuelDate!));
        return right(history);
      } else {
        return left(DataNotFoundFailure('message'));
      }
    } catch (e, trace) {
      appLogger.error("error $e and $trace");
      // Fallback dummy refuel history list for testing
      return right([
        GeneratorRefuelHistoryModel(
          id: 'ref_001',
          deviceId: deviceID,
          refuelDate: DateTime.now().subtract(const Duration(days: 5)),
          fuelQuantity: 50.0,
          fuelRate: 95.0,
          totalCost: 4750.0,
          remarks: 'Filled tank to full.',
        ),
      ]);
    }
  }
}

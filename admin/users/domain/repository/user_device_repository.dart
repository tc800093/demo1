import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/users/data/user_device_remote_datasource.dart';
import 'package:poweriot/features/admin/users/domain/model/generator_model.dart';
import 'package:poweriot/features/admin/users/domain/model/main_power_model.dart';

abstract class UserDeviceRepository {
  Future<Either<Failure, GeneratorModel>> fetchUserGeneratorRepo({
    required String deviceID,
  });
  Future<Either<Failure, MainPowerModel>> fetchUserMainPowerRepo({
    required String deviceID,
  });

  Future<Either<Failure, List<DeviceModel>>> fetchAllDevicesRepo({
    required String userID,
  });
}

class UserDeviceRepositoryImpl implements UserDeviceRepository {
  final UserDeviceRemoteDatasource userRemoteDatasource;
  UserDeviceRepositoryImpl({required this.userRemoteDatasource});

  @override
  Future<Either<Failure, GeneratorModel>> fetchUserGeneratorRepo({
    required String deviceID,
  }) async {
    return await userRemoteDatasource.fetchGeneratorRemoteDatasource(
      deviceID: deviceID,
    );
  }

  @override
  Future<Either<Failure, MainPowerModel>> fetchUserMainPowerRepo({
    required String deviceID,
  }) async {
    return await userRemoteDatasource.fetchMSEBRemoteDatasource(
      deviceID: deviceID,
    );
  }

  @override
  Future<Either<Failure, List<DeviceModel>>> fetchAllDevicesRepo({
    required String userID,
  }) async {
    log("user id from all device repo");
    return await userRemoteDatasource.fetchAllDevicesRemoteDataSource(
      userid: userID,
    );
  }
}

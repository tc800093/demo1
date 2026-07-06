import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/users/domain/repository/user_device_repository.dart';

class FetchUserDeviceInfoUsecase implements UseCase<List<DeviceModel>, String> {
  final UserDeviceRepository repository;

  FetchUserDeviceInfoUsecase({required this.repository});

  @override
  Future<Either<Failure, List<DeviceModel>>> call(String userID) async {
    log("usecase user id passed ${userID}");
    return await repository.fetchAllDevicesRepo(userID: userID);
  }
}

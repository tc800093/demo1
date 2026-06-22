import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/devices/domain/respository/device_repository.dart';

class FetchAllDeviceUsecase implements UseCase<List<DeviceModel>, NoParams> {
  final DeviceRepository repository;

  FetchAllDeviceUsecase({required this.repository});

  @override
  Future<Either<Failure, List<DeviceModel>>> call(NoParams param) async {
    return await repository.fetchDevicesRemoteData();
  }
}

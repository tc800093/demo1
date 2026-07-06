import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/users/domain/model/main_power_model.dart';
import 'package:poweriot/features/admin/users/domain/repository/user_device_repository.dart';

class FetchMainPowerInfoUsecase implements UseCase<MainPowerModel, String> {
  final UserDeviceRepository repository;

  FetchMainPowerInfoUsecase({required this.repository});

  @override
  Future<Either<Failure, MainPowerModel>> call(String params) async {
    return await repository.fetchUserMainPowerRepo(deviceID: params);
  }
}

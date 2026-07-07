import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/core/common/domain/model/generator_model.dart';
import 'package:poweriot/features/admin/users/domain/repository/user_device_repository.dart';

class FetchGeneratorInfoUsecase implements UseCase<GeneratorModel, String> {
  final UserDeviceRepository repository;

  FetchGeneratorInfoUsecase({required this.repository});

  @override
  Future<Either<Failure, GeneratorModel>> call(String params) async {
    return await repository.fetchUserGeneratorRepo(deviceID: params);
  }
}

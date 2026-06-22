import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/domain/repository/user_repository.dart';

class UpdateUserDataUsecase implements UseCase<String, UserModel> {
  final UserRepository repository;

  UpdateUserDataUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(UserModel params) async {
    return await repository.updateUserByRepo(userData: params);
  }
}

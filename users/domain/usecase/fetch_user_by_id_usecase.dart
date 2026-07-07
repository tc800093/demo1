import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/domain/repository/user_repository.dart';

class FetchUserByIdUsecase implements UseCase<UserModel, String> {
  final UserRepository repository;

  FetchUserByIdUsecase({required this.repository});

  @override
  Future<Either<Failure, UserModel>> call(String userID) async {
    return await repository.fetchUserByIDRepo(userID: userID);
  }
}

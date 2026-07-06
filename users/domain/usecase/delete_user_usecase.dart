import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/users/domain/repository/user_repository.dart';

class DeleteUserUsecase implements UseCase<String, NoParams> {
  final UserRepository repository;

  DeleteUserUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.deleteUserbyIDRepo();
  }
}

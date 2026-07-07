import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/domain/repository/user_repository.dart';

class FetchUserListUsecase implements UseCase<List<UserModel>, NoParams> {
  final UserRepository repository;

  FetchUserListUsecase({required this.repository});

  @override
  Future<Either<Failure, List<UserModel>>> call(NoParams params) async {
    return await repository.fetchAllUserRepo();
  }
}

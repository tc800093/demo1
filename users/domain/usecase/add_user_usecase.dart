import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/users/domain/repository/user_repository.dart';

class AddUserUsecase implements UseCase<String, AddUserParams> {
  final UserRepository repository;

  AddUserUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(AddUserParams params) async {
    return await repository.addUserRepo(addParams: params);
  }
}

class AddUserParams {
  final String fullName;
  final String email;
  final String mobileNumber;
  final String password;
  final String role;
  AddUserParams({
    required this.email,
    required this.fullName,
    required this.mobileNumber,
    required this.password,
    required this.role,
  });
}

import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/features/admin/users/data/user_remote_datasource.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/domain/usecase/add_user_usecase.dart';

abstract class UserRepository {
  Future<Either<Failure, String>> addUserRepo({
    required AddUserParams addParams,
  });
  Future<Either<Failure, List<UserModel>>> fetchAllUserRepo();
  Future<Either<Failure, UserModel>> fetchUserByIDRepo({
    required String userID,
  });
  Future<Either<Failure, String>> updateUserByRepo({
    required UserModel userData,
  });
  Future<Either<Failure, String>> deleteUserbyIDRepo();
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource userRemmoteDatasource;
  UserRepositoryImpl({required this.userRemmoteDatasource});

  @override
  Future<Either<Failure, String>> deleteUserbyIDRepo() async {
    return await userRemmoteDatasource.deleteUserbyIDDatasource();
  }

  @override
  Future<Either<Failure, List<UserModel>>> fetchAllUserRepo() async {
    return await userRemmoteDatasource.fetchAllUserDatasource();
  }

  @override
  Future<Either<Failure, UserModel>> fetchUserByIDRepo({
    required String userID,
  }) async {
    return await userRemmoteDatasource.fetchUserByIDDataSource(userID: userID);
  }

  @override
  Future<Either<Failure, String>> updateUserByRepo({
    required UserModel userData,
  }) async {
    return await userRemmoteDatasource.updateUserByDataSource(
      userData: userData,
    );
  }

  @override
  Future<Either<Failure, String>> addUserRepo({
    required AddUserParams addParams,
  }) async {
    return await userRemmoteDatasource.addUserDatasource(params: addParams);
  }
}

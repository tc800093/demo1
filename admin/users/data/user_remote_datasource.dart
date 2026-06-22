import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/config/config.dart';

import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/domain/usecase/add_user_usecase.dart';

abstract class UserRemoteDatasource {
  Future<Either<Failure, String>> addUserDatasource({
    required AddUserParams params,
  });
  Future<Either<Failure, List<UserModel>>> fetchAllUserDatasource();
  Future<Either<Failure, UserModel>> fetchUserByIDDataSource({
    required String userID,
  });
  Future<Either<Failure, String>> updateUserByDataSource({
    required UserModel userData,
  });
  Future<Either<Failure, String>> deleteUserbyIDDatasource();
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final DioClient dioClient;
  final SecureStorageService secureStorageService;
  final AppLogger appLogger;
  UserRemoteDatasourceImpl({
    required this.appLogger,
    required this.secureStorageService,
    required this.dioClient,
  });

  static final List<UserModel> _staticUsers = [
    UserModel(
      userId: "user-123",
      fullName: "Tejas Patil",
      email: "tejas@poweriot.com",
      mobileNumber: "9168497373",
      role: "user",
      active: true,
      deviceId: "device-1",
    ),
    UserModel(
      userId: "user-456",
      fullName: "Vasundhara Dev",
      email: "dev@vasundhara.com",
      mobileNumber: "9876543210",
      role: "user",
      active: true,
      deviceId: "device-2",
    ),
    UserModel(
      userId: "user-789",
      fullName: "Rahul Shinde",
      email: "rahul@poweriot.com",
      mobileNumber: "8888888888",
      role: "user",
      active: false,
      deviceId: "device-3",
    ),
  ];

  @override
  Future<Either<Failure, String>> addUserDatasource({
    required AddUserParams params,
  }) async {
    try {
      final newUser = UserModel(
        userId: "user-${DateTime.now().millisecondsSinceEpoch}",
        fullName: params.fullName,
        email: params.email,
        mobileNumber: params.mobileNumber,
        role: params.role,
        active: true,
        deviceId: "",
      );
      _staticUsers.add(newUser);
      return right("User added");
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> fetchAllUserDatasource() async {
    try {
      return right(List<UserModel>.from(_staticUsers));
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> fetchUserByIDDataSource({
    required String userID,
  }) async {
    try {
      final user = _staticUsers.firstWhere(
        (element) => element.userId == userID,
        orElse: () => _staticUsers.first,
      );
      return right(user);
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> updateUserByDataSource({
    required UserModel userData,
  }) async {
    try {
      final idx = _staticUsers.indexWhere((element) => element.userId == userData.userId);
      if (idx != -1) {
        _staticUsers[idx] = userData;
      }
      return right('update data updated');
    } catch (e) {
      return left(ServerFailure("something went wrong"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteUserbyIDDatasource() async {
    try {
      return right('user deleted');
    } catch (e) {
      return left(ServerFailure("something went wrong"));
    }
  }
}

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/config/config.dart';
import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/domain/model/my_subscription_model.dart';

/// Remote data source for retrieving dashboard data.
abstract class DashboardRemoteDatasource {
  /// Fetches the latest dashboard data from the API call.
  Future<Either<Failure, List<DashboardModel>>>
  fetchDashboardRemoteDataSource();

  /// Fetches the User subscription plan from the API call.
  Future<Either<Failure, MySubscriptionModel>>
  fetchMySubscriptionRemoteDataSource();
}

/// Implementation of the remote dashboard data source.
/// Communicating with the API.
/// Fetching the latest dashboard data.
/// Mapping the API response to application models.
/// Handling network and server exceptions.
class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final DioClient dioClient;
  final AppLogger appLogger;
  final SecureStorageService secureStorageService;
  DashboardRemoteDatasourceImpl({
    required this.appLogger,
    required this.dioClient,
    required this.secureStorageService,
  });

  /// Sends a request to Fetch the latest dashboard data.
  @override
  Future<Either<Failure, List<DashboardModel>>>
  fetchDashboardRemoteDataSource() async {
    try {
      String? storedUserID = await secureStorageService.read(userID);

      String? token = await secureStorageService.read(storedToken);
      final dio = dioClient.dio;
      final result = await dio.get(
        dashboardEndpoint(userid: storedUserID.toString(), page: 0, size: 10),
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );

      if (result.statusCode == 200) {
        if (result.data['content'] != null &&
            result.data['content'].isNotEmpty) {
          List<DashboardModel> dashboardModel =
              (result.data['content'] as List<dynamic>)
                  .map<DashboardModel>((d) => DashboardModel.fromJson(d))
                  .toList();

          return right(dashboardModel);
        } else {
          return left(DataNotFoundFailure("Reading not found"));
        }
      } else {
        return left(DataNotFoundFailure("Data not found"));
      }
    } catch (e, trace) {
      AppLogger().error(
        "Error while fetcing dashboard api ${e.toString()}\n trace: ${trace.toString()}",
      );
      return left(ServerFailure('something went wrong'));
    }
  }

  /// Sends a request to Fetch the user current active plan.
  @override
  Future<Either<Failure, MySubscriptionModel>>
  fetchMySubscriptionRemoteDataSource() async {
    try {
      String? token = await secureStorageService.read(storedToken);
      final dio = dioClient.dio;
      final response = await dio.get(
        fetchMySubscriptionEndpoint,
        options: Options(headers: {'Authorization': "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          MySubscriptionModel mySubscriptionModel =
              MySubscriptionModel.fromJson(response.data['data']);

          return right(mySubscriptionModel);
        } else {
          return left(DataNotFoundFailure('No subscription'));
        }
      } else {
        return left(DataNotFoundFailure('No subscription'));
      }
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }
}

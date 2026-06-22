import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/features/admin/subscription/data/datasource/subscription_remote_datasource.dart';
import 'package:poweriot/features/admin/subscription/domain/model/subscription_model.dart';
import 'package:poweriot/features/admin/subscription/domain/model/user_subscription_model.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/add_subscription_plan_usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/assign_subscription_by_admin_usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/update_subscription_plan_usecase.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionModel>>> fetchSubscriptionPlansRepo();
  Future<Either<Failure, String>> addSubscriptionPlanRepo({
    required AddSubscriptionParams params,
  });
  Future<Either<Failure, String>> updateSubscriptionPlanRepo({
    required UpdateSubscriptionParams params,
  });

  Future<Either<Failure, UserSubscriptionModel>> fetchSubscriptionByUserIDRepo({
    required String userId,
  });

  Future<Either<Failure, String>> assingPlanToUserRepo({
    required AssignSubscriptionParams params,
  });
}

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDatasource subscriptionRemoteDatasource;
  SubscriptionRepositoryImpl({required this.subscriptionRemoteDatasource});
  @override
  Future<Either<Failure, List<SubscriptionModel>>>
  fetchSubscriptionPlansRepo() async {
    return await subscriptionRemoteDatasource
        .fetchSubscriptionPlansRemoteData();
  }

  @override
  Future<Either<Failure, String>> addSubscriptionPlanRepo({
    required AddSubscriptionParams params,
  }) async {
    return await subscriptionRemoteDatasource.addSubscriptionPlansRemoteData(
      params: params,
    );
  }

  @override
  Future<Either<Failure, String>> updateSubscriptionPlanRepo({
    required UpdateSubscriptionParams params,
  }) async {
    return await subscriptionRemoteDatasource.updateSubscriptionPlansRemoteData(
      params: params,
    );
  }

  @override
  Future<Either<Failure, UserSubscriptionModel>> fetchSubscriptionByUserIDRepo({
    required String userId,
  }) async {
    return await subscriptionRemoteDatasource
        .fetchSubscriptionPlansByUserIDRemoteData(userId: userId);
  }

  @override
  Future<Either<Failure, String>> assingPlanToUserRepo({
    required AssignSubscriptionParams params,
  }) async {
    return await subscriptionRemoteDatasource.assingPlanToUserRemoteData(
      params: params,
    );
  }
}

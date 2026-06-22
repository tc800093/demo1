import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/config/config.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/admin/subscription/domain/model/subscription_model.dart';
import 'package:poweriot/features/admin/subscription/domain/model/user_subscription_model.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/add_subscription_plan_usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/assign_subscription_by_admin_usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/update_subscription_plan_usecase.dart';

abstract class SubscriptionRemoteDatasource {
  Future<Either<Failure, List<SubscriptionModel>>>
  fetchSubscriptionPlansRemoteData();
  Future<Either<Failure, String>> addSubscriptionPlansRemoteData({
    required AddSubscriptionParams params,
  });
  Future<Either<Failure, String>> updateSubscriptionPlansRemoteData({
    required UpdateSubscriptionParams params,
  });
  Future<Either<Failure, String>> fetchSubscriptionPlansByIDRemoteData();

  Future<Either<Failure, UserSubscriptionModel>>
  fetchSubscriptionPlansByUserIDRemoteData({required String userId});

  Future<Either<Failure, String>> assingPlanToUserRemoteData({
    required AssignSubscriptionParams params,
  });
}

class SubscriptionRemoteDatasourceImpl implements SubscriptionRemoteDatasource {
  final DioClient dioClient;
  final SecureStorageService secureStorageService;
  final AppLogger appLogger;
  SubscriptionRemoteDatasourceImpl({
    required this.dioClient,
    required this.secureStorageService,
    required this.appLogger,
  });

  static final List<SubscriptionModel> _staticPlans = [
    SubscriptionModel(
      planId: "plan-1",
      planName: "Basic Monthly",
      planType: "Monthly",
      durationDays: 30,
      amount: 999.0,
      description: "Basic features with single device monitoring.",
      active: true,
    ),
    SubscriptionModel(
      planId: "plan-2",
      planName: "Enterprise Yearly",
      planType: "Yearly",
      durationDays: 365,
      amount: 9999.0,
      description: "Enterprise grade analytics and priority support.",
      active: true,
    ),
    SubscriptionModel(
      planId: "plan-3",
      planName: "Custom Plan",
      planType: "Monthly",
      durationDays: 30,
      amount: 2500.0,
      description: "Custom threshold alerts and tailored notifications.",
      active: false,
    ),
  ];

  @override
  Future<Either<Failure, String>> addSubscriptionPlansRemoteData({
    required AddSubscriptionParams params,
  }) async {
    try {
      final newPlan = SubscriptionModel(
        planId: "plan-${DateTime.now().millisecondsSinceEpoch}",
        planName: params.planName,
        planType: params.plaType,
        durationDays: params.plaType.toLowerCase() == 'yearly' ? 365 : 30,
        amount: double.tryParse(params.planPrice) ?? 0.0,
        description: params.planDescription,
        active: true,
      );
      _staticPlans.add(newPlan);
      return right("r");
    } catch (e) {
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> fetchSubscriptionPlansByIDRemoteData() async {
    return right("r");
  }

  @override
  Future<Either<Failure, List<SubscriptionModel>>>
  fetchSubscriptionPlansRemoteData() async {
    try {
      return right(List<SubscriptionModel>.from(_staticPlans));
    } catch (e) {
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> updateSubscriptionPlansRemoteData({
    required UpdateSubscriptionParams params,
  }) async {
    try {
      final idx = _staticPlans.indexWhere((element) => element.planId == params.planId);
      if (idx != -1) {
        _staticPlans[idx] = SubscriptionModel(
          planId: params.planId,
          planName: params.planName,
          planType: params.plaType,
          durationDays: params.plaType.toLowerCase() == 'yearly' ? 365 : 30,
          amount: double.tryParse(params.planPrice.toString()) ?? 0.0,
          description: params.planDescription,
          active: params.isActive,
        );
      }
      return right("r");
    } catch (e) {
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, UserSubscriptionModel>>
  fetchSubscriptionPlansByUserIDRemoteData({required String userId}) async {
    try {
      return right(UserSubscriptionModel(
        subscriptionId: "sub-999",
        userId: userId,
        userName: "Tejas Patil",
        planId: "plan-2",
        planName: "Enterprise Yearly",
        amount: 9999.0,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        expiryDate: DateTime.now().add(const Duration(days: 335)),
        status: "active",
        paymentType: "Online",
        paymentMode: "UPI",
        paymentDate: DateTime.now().subtract(const Duration(days: 30)),
        transactionId: "TXN-777888999",
        remarks: "Mocked User Subscription",
      ));
    } catch (e) {
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> assingPlanToUserRemoteData({
    required AssignSubscriptionParams params,
  }) async {
    return right('userSubscriptionModel');
  }
}

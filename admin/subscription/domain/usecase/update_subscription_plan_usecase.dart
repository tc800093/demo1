import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/repository/subscription_repository.dart';

class UpdateSubscriptionPlanUsecase
    implements UseCase<String, UpdateSubscriptionParams> {
  final SubscriptionRepository repository;
  UpdateSubscriptionPlanUsecase({required this.repository});
  @override
  Future<Either<Failure, String>> call(UpdateSubscriptionParams params) async {
    return await repository.updateSubscriptionPlanRepo(params: params);
  }
}

class UpdateSubscriptionParams {
  final String planId;
  final String planName;
  final String planDescription;
  final String planPrice;
  final String plaType;
  final bool isActive;

  UpdateSubscriptionParams({
    required this.planId,
    required this.planName,
    required this.planDescription,
    required this.planPrice,
    required this.plaType,
    required this.isActive,
  });
}

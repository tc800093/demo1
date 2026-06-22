import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/repository/subscription_repository.dart';

class AddSubscriptionPlanUsecase
    implements UseCase<String, AddSubscriptionParams> {
  final SubscriptionRepository repository;
  AddSubscriptionPlanUsecase({required this.repository});
  @override
  Future<Either<Failure, String>> call(AddSubscriptionParams params) async {
    return await repository.addSubscriptionPlanRepo(params: params);
  }
}

class AddSubscriptionParams {
  final String planName;
  final String planDescription;
  final String planPrice;
  final String plaType;

  AddSubscriptionParams({
    required this.planName,
    required this.planDescription,
    required this.planPrice,
    required this.plaType,
  });
}

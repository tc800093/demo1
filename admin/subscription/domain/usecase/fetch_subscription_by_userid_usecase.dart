import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/model/user_subscription_model.dart';
import 'package:poweriot/features/admin/subscription/domain/repository/subscription_repository.dart';

class FetchSubscriptionByUseridUsecase
    implements UseCase<UserSubscriptionModel, String> {
  final SubscriptionRepository repository;
  FetchSubscriptionByUseridUsecase({required this.repository});
  @override
  Future<Either<Failure, UserSubscriptionModel>> call(String userid) async {
    return await repository.fetchSubscriptionByUserIDRepo(userId: userid);
  }
}

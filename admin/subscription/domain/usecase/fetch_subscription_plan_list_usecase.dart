import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/model/subscription_model.dart';
import 'package:poweriot/features/admin/subscription/domain/repository/subscription_repository.dart';

class FetchSubscriptionPlanListUsecase
    implements UseCase<List<SubscriptionModel>, NoParams> {
  final SubscriptionRepository repository;
  FetchSubscriptionPlanListUsecase({required this.repository});
  @override
  Future<Either<Failure, List<SubscriptionModel>>> call(NoParams params) async {
    return await repository.fetchSubscriptionPlansRepo();
  }
}

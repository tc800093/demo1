import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/user/dashboard/domain/model/my_subscription_model.dart';
import 'package:poweriot/features/user/dashboard/domain/repository/dashboard_repository.dart';

class FetchMySubscriptoinUsecase
    implements UseCase<MySubscriptionModel, NoParams> {
  final DashboardRepository repository;

  FetchMySubscriptoinUsecase({required this.repository});

  @override
  Future<Either<Failure, MySubscriptionModel>> call(NoParams params) async {
    return await repository.fetchMySubscriptionRepo();
  }
}

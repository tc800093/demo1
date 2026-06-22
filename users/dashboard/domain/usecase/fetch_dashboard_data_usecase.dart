import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/users/dashboard/domain/model/dashboard_model.dart';
import 'package:poweriot/features/users/dashboard/domain/repository/dashboard_repository.dart';

class FetchDashboardDataUsecase implements UseCase<DashboardModel, NoParams> {
  final DashboardRepository repository;

  FetchDashboardDataUsecase({required this.repository});

  @override
  Future<Either<Failure, DashboardModel>> call(NoParams params) async {
    return await repository.fetchDashboardRepo();
  }
}

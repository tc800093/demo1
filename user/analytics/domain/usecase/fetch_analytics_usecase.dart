import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/user/analytics/domain/entity/analytics_entity.dart';
import 'package:poweriot/features/user/analytics/domain/entity/analytics_model.dart';
import 'package:poweriot/features/user/analytics/domain/repository/analytics_repository.dart';

class FetchAnalyticsUsecase
    implements UseCase<AnalyticsModel, FetchAnalyticsParams> {
  final AnalyticsRepository repository;

  FetchAnalyticsUsecase({required this.repository});

  @override
  Future<Either<Failure, AnalyticsModel>> call(
    FetchAnalyticsParams params,
  ) async {
    return await repository.fetchAnalyticsRepo(params: params);
  }
}

class FetchAnalyticsParams {
  final String userDevice;
  final String fromDate;
  final String toDate;
  FetchAnalyticsParams({
    required this.userDevice,
    required this.fromDate,
    required this.toDate,
  });
}

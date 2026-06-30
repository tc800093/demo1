import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/features/users/analytics/data/analytics_remote_datasource.dart';
import 'package:poweriot/features/users/analytics/domain/entity/analytics_entity.dart';
import 'package:poweriot/features/users/analytics/domain/usecase/fetch_analytics_usecase.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, AnalyticsModel>> fetchAnalyticsRepo({
    required FetchAnalyticsParams params,
  });
}

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDatasource analyticsRemoteDatasource;
  AnalyticsRepositoryImpl({required this.analyticsRemoteDatasource});
  @override
  Future<Either<Failure, AnalyticsModel>> fetchAnalyticsRepo({
    required FetchAnalyticsParams params,
  }) async {
    return await analyticsRemoteDatasource.fetchAnalyticsDatasource(
      params: params,
    );
  }
}

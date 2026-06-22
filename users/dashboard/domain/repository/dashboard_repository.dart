import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/features/users/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:poweriot/features/users/dashboard/domain/model/dashboard_model.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardModel>> fetchDashboardRepo();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource dashboardRemoteDatasource;
  DashboardRepositoryImpl({required this.dashboardRemoteDatasource});
  @override
  Future<Either<Failure, DashboardModel>> fetchDashboardRepo() async {
    return dashboardRemoteDatasource.fetchDashboardRemoteDataSource();
  }
}

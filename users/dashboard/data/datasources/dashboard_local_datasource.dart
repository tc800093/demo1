import 'package:dartz/dartz.dart';
import 'package:poweriot/core/database/app_local_database.dart';

abstract class DashboardLocalDatasource {
  Future<Either<String, String>> loadDummyDataSource();
}

class DashboardLocalDatasourceImpl implements DashboardLocalDatasource {
  final AppLocalDatabase localDatabase;
  DashboardLocalDatasourceImpl({required this.localDatabase});
  @override
  Future<Either<String, String>> loadDummyDataSource() async {
    throw UnimplementedError();
  }
}

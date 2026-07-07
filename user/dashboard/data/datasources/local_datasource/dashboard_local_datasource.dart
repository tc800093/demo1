import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:poweriot/core/constants/db_constant.dart';
import 'package:poweriot/core/database/app_local_database.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';

/// Local data source for managing dashboard data.
///
/// Responsible for caching dashboard information locally,
/// loading sample data when required, and retrieving the
/// latest api response is saved in local db.
abstract class DashboardLocalDatasource {
  /// Loads dummy dashboard data for development, testing,
  Future<Either<Failure, String>> loadDummyDataSource();

  /// Saves new dashboard data or updates the existing
  Future<Either<Failure, bool>> saveOrUpdateDashboardLocalDataSource({
    required List<DashboardModel> dashboarAPIList,
  });

  /// latest api response is saved in local db.
  Future<Either<Failure, List<DashboardModel>>>
  fetchDashboardLatestLocalDataSource();
}

/// Implementation of the local dashboard data source.
///
class DashboardLocalDatasourceImpl implements DashboardLocalDatasource {
  final AppLocalDatabase localDatabase;
  final AppLogger appLogger;
  DashboardLocalDatasourceImpl({
    required this.localDatabase,
    required this.appLogger,
  });

  /// Loads dummy dashboard data into local storage.
  @override
  Future<Either<Failure, String>> loadDummyDataSource() async {
    throw UnimplementedError();
  }

  /// Saves new dashboard data or updates the existing data in local db.
  @override
  Future<Either<Failure, bool>> saveOrUpdateDashboardLocalDataSource({
    required List<DashboardModel> dashboarAPIList,
  }) async {
    try {
      final db = await localDatabase.database;
      await db.insert(dashboarAPIDB, {
        'id': 1, // Always keep only one record
        'data': dashboardListToJson(dashboarAPIList),
        'updatedAt': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: .replace);

      return right(true);
    } catch (e, trace) {
      return left(ServerFailure('failed to store in localdb'));
    }
  }

  // Retrieves the latest dashboard data from local storage.
  @override
  Future<Either<Failure, List<DashboardModel>>>
  fetchDashboardLatestLocalDataSource() async {
    try {
      final db = await localDatabase.database;
      final result = await db.query(
        dashboarAPIDB,
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );
      if (result.isEmpty) {
        return right([]);
      }
      return right(dashboardListFromJson(result.first['data'] as String));
    } catch (e) {
      return left(ServerFailure('failed to get dashboard local data'));
    }
  }
}

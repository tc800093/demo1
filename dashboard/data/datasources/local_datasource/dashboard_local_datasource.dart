import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:poweriot/core/constants/db_constant.dart';
import 'package:poweriot/core/database/app_local_database.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';

final List<String> generatorFuelTips = [
  '⛽ Keep fuel above 20% for reliable operation.',
  '⚠️ Refuel only when the generator is OFF.',
  '💧 Inspect the generator regularly for fuel leaks.',
  '📊 Track refueling to monitor fuel consumption and efficiency.',
];

final List<String> generatorTemperatureTips = [
  '🌡️ Normal engine temperature is typically between 75°C and 95°C.',
  '⚠️ If the temperature exceeds 100°C, stop the generator and inspect the cooling system.',
  '💨 Ensure radiator vents are clean and unobstructed to prevent overheating.',
  '🔧 Regularly check coolant level and radiator condition for efficient cooling.',
];

final List<String> generatorCoolantTips = [
  '💧 Maintain the coolant level between the MIN and MAX marks on the reservoir.',
  '⚠️ Never remove the radiator cap while the engine is hot.',
  '🔍 Check coolant hoses and connections regularly for leaks or damage.',
  '🛠️ Replace coolant at the interval recommended by the generator manufacturer.',
];

final List<String> generatorOilPressureTips = [
  '🛢️ Normal engine oil pressure is typically between 30 and 70 psi during operation.',
  '⚠️ If oil pressure drops below 20 psi, stop the generator immediately.',
  '📈 High oil pressure may indicate a blocked oil filter or cold engine conditions.',
  '🔧 Check engine oil level regularly and replace oil and filters as scheduled.',
];

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
    } catch (e) {
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

      log("fetch local dashboard data  ${result}");
      if (result.isEmpty) {
        return right([]);
      }
      return right(dashboardListFromJson(result.first['data'] as String));
    } catch (e) {
      return left(ServerFailure('failed to get dashboard local data'));
    }
  }
}

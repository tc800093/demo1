import 'package:dartz/dartz.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/data_repository.dart';
import '../datasources/local_database.dart';

class DataRepositoryImpl implements DataRepository {
  final LocalDatabase localDatabase;

  DataRepositoryImpl({required this.localDatabase});

  @override
  Future<Either<String, List<PowerMetric>>> getMetrics() async {
    try {
      final data = await localDatabase.getMetrics();
      final metrics = data
          .map(
            (e) => PowerMetric(
              timestamp: DateTime.parse(e['timestamp']),
              source: e['source'],
              voltageR: e['voltageR'],
              voltageY: e['voltageY'],
              voltageB: e['voltageB'],
              fuelLevel: e['fuelLevel'],
              oilPressure: e['oilPressure'],
              engineTemp: e['engineTemp'],
              batteryStatus: e['batteryStatus'],
              isRunning: e['isRunning'] == 1,
            ),
          )
          .toList();
      return Right(metrics);
    } catch (e) {
      return Left('Failed to fetch metrics: \$e');
    }
  }

  @override
  Future<Either<String, List<OutageLog>>> getOutages() async {
    try {
      final data = await localDatabase.getOutages();
      final outages = data
          .map(
            (e) => OutageLog(
              startTime: DateTime.parse(e['startTime']),
              endTime: DateTime.parse(e['endTime']),
              durationMinutes: e['durationMinutes'],
            ),
          )
          .toList();
      return Right(outages);
    } catch (e) {
      return Left('Failed to fetch outages: \$e');
    }
  }

  @override
  Future<Either<String, List<FuelLog>>> getFuelLogs() async {
    try {
      final data = await localDatabase.getFuelLogs();
      final logs = data
          .map(
            (e) => FuelLog(
              date: DateTime.parse(e['date']),
              quantity: e['quantity'],
              cost: e['cost'],
            ),
          )
          .toList();
      return Right(logs);
    } catch (e) {
      return Left('Failed to fetch fuel logs: \$e');
    }
  }
}

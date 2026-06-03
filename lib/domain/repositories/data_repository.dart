import 'package:dartz/dartz.dart';
import '../entities/entities.dart';

abstract class DataRepository {
  Future<Either<String, List<PowerMetric>>> getMetrics();
  Future<Either<String, List<OutageLog>>> getOutages();
  Future<Either<String, List<FuelLog>>> getFuelLogs();
}

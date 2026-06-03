import 'package:equatable/equatable.dart';

class PowerMetric extends Equatable {
  final DateTime timestamp;
  final String source; // 'MSEB' or 'Generator'
  final double voltageR;
  final double voltageY;
  final double voltageB;
  final double fuelLevel;
  final double oilPressure;
  final double engineTemp;
  final double batteryStatus;
  final bool isRunning;

  const PowerMetric({
    required this.timestamp,
    required this.source,
    required this.voltageR,
    required this.voltageY,
    required this.voltageB,
    required this.fuelLevel,
    required this.oilPressure,
    required this.engineTemp,
    required this.batteryStatus,
    required this.isRunning,
  });

  @override
  List<Object?> get props => [
    timestamp,
    source,
    voltageR,
    voltageY,
    voltageB,
    fuelLevel,
    oilPressure,
    engineTemp,
    batteryStatus,
    isRunning,
  ];
}

class OutageLog extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  const OutageLog({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [startTime, endTime, durationMinutes];
}

class FuelLog extends Equatable {
  final DateTime date;
  final double quantity;
  final double cost;

  const FuelLog({
    required this.date,
    required this.quantity,
    required this.cost,
  });

  @override
  List<Object?> get props => [date, quantity, cost];
}

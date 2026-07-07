class ServiceRecord {
  final String id;
  final String deviceId;
  final String deviceName;
  final DateTime serviceDate;
  final String serviceType;
  final String description;
  final String technician;
  final double cost;

  ServiceRecord({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.serviceDate,
    required this.serviceType,
    required this.description,
    required this.technician,
    required this.cost,
  });
}

class RefuelRecord {
  final String id;
  final String deviceId;
  final String deviceName;
  final DateTime refuelDate;
  final double fuelAmountLiters;
  final double cost;
  final String notes;

  RefuelRecord({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.refuelDate,
    required this.fuelAmountLiters,
    required this.cost,
    required this.notes,
  });
}

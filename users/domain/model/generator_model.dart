// To parse this JSON data, do
//
//     final generatorModel = generatorModelFromJson(jsonString);

import 'dart:convert';

GeneratorModel generatorModelFromJson(String str) =>
    GeneratorModel.fromJson(json.decode(str));

String generatorModelToJson(GeneratorModel data) => json.encode(data.toJson());

class GeneratorModel {
  String? deviceId;
  String? generatorName;
  String? manufacturer;
  String? modelNumber;
  String? serialNumber;
  String? generatorType;
  double? generatorCapacityKva;
  double? generatorCapacityKw;
  double? fuelTankCapacity;
  double? averageFuelConsumptionPerHour;
  DateTime? installationDate;
  DateTime? warrantyExpiryDate;
  DateTime? lastMaintenanceDate;
  DateTime? nextMaintenanceDate;
  int? maintenanceIntervalDays;
  int? runningHoursAtInstallation;
  String? supplierName;
  String? supplierContact;
  String? location;
  dynamic active;
  String? id;

  GeneratorModel({
    this.deviceId,
    this.generatorName,
    this.manufacturer,
    this.modelNumber,
    this.serialNumber,
    this.generatorType,
    this.generatorCapacityKva,
    this.generatorCapacityKw,
    this.fuelTankCapacity,
    this.averageFuelConsumptionPerHour,
    this.installationDate,
    this.warrantyExpiryDate,
    this.lastMaintenanceDate,
    this.nextMaintenanceDate,
    this.maintenanceIntervalDays,
    this.runningHoursAtInstallation,
    this.supplierName,
    this.supplierContact,
    this.location,
    this.active,
    this.id,
  });

  GeneratorModel copyWith({
    String? deviceId,
    String? generatorName,
    String? manufacturer,
    String? modelNumber,
    String? serialNumber,
    String? generatorType,
    double? generatorCapacityKva,
    double? generatorCapacityKw,
    double? fuelTankCapacity,
    double? averageFuelConsumptionPerHour,
    DateTime? installationDate,
    DateTime? warrantyExpiryDate,
    DateTime? lastMaintenanceDate,
    DateTime? nextMaintenanceDate,
    int? maintenanceIntervalDays,
    int? runningHoursAtInstallation,
    String? supplierName,
    String? supplierContact,
    String? location,
    dynamic active,
    String? id,
  }) => GeneratorModel(
    deviceId: deviceId ?? this.deviceId,
    generatorName: generatorName ?? this.generatorName,
    manufacturer: manufacturer ?? this.manufacturer,
    modelNumber: modelNumber ?? this.modelNumber,
    serialNumber: serialNumber ?? this.serialNumber,
    generatorType: generatorType ?? this.generatorType,
    generatorCapacityKva: generatorCapacityKva ?? this.generatorCapacityKva,
    generatorCapacityKw: generatorCapacityKw ?? this.generatorCapacityKw,
    fuelTankCapacity: fuelTankCapacity ?? this.fuelTankCapacity,
    averageFuelConsumptionPerHour:
        averageFuelConsumptionPerHour ?? this.averageFuelConsumptionPerHour,
    installationDate: installationDate ?? this.installationDate,
    warrantyExpiryDate: warrantyExpiryDate ?? this.warrantyExpiryDate,
    lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
    nextMaintenanceDate: nextMaintenanceDate ?? this.nextMaintenanceDate,
    maintenanceIntervalDays:
        maintenanceIntervalDays ?? this.maintenanceIntervalDays,
    runningHoursAtInstallation:
        runningHoursAtInstallation ?? this.runningHoursAtInstallation,
    supplierName: supplierName ?? this.supplierName,
    supplierContact: supplierContact ?? this.supplierContact,
    location: location ?? this.location,
    active: active ?? this.active,
    id: id ?? this.id,
  );

  factory GeneratorModel.fromJson(Map<String, dynamic> json) => GeneratorModel(
    deviceId: json["deviceId"],
    generatorName: json["generatorName"],
    manufacturer: json["manufacturer"],
    modelNumber: json["modelNumber"],
    serialNumber: json["serialNumber"],
    generatorType: json["generatorType"],
    generatorCapacityKva: json["generatorCapacityKva"],
    generatorCapacityKw: json["generatorCapacityKw"],
    fuelTankCapacity: json["fuelTankCapacity"],
    averageFuelConsumptionPerHour: json["averageFuelConsumptionPerHour"]
        ?.toDouble(),
    installationDate: json["installationDate"] == null
        ? null
        : DateTime.parse(json["installationDate"]),
    warrantyExpiryDate: json["warrantyExpiryDate"] == null
        ? null
        : DateTime.parse(json["warrantyExpiryDate"]),
    lastMaintenanceDate: json["lastMaintenanceDate"] == null
        ? null
        : DateTime.parse(json["lastMaintenanceDate"]),
    nextMaintenanceDate: json["nextMaintenanceDate"] == null
        ? null
        : DateTime.parse(json["nextMaintenanceDate"]),
    maintenanceIntervalDays: json["maintenanceIntervalDays"],
    runningHoursAtInstallation: json["runningHoursAtInstallation"],
    supplierName: json["supplierName"],
    supplierContact: json["supplierContact"],
    location: json["location"],
    active: json["active"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "generatorName": generatorName,
    "manufacturer": manufacturer,
    "modelNumber": modelNumber,
    "serialNumber": serialNumber,
    "generatorType": generatorType,
    "generatorCapacityKva": generatorCapacityKva,
    "generatorCapacityKw": generatorCapacityKw,
    "fuelTankCapacity": fuelTankCapacity,
    "averageFuelConsumptionPerHour": averageFuelConsumptionPerHour,
    "installationDate":
        "${installationDate!.year.toString().padLeft(4, '0')}-${installationDate!.month.toString().padLeft(2, '0')}-${installationDate!.day.toString().padLeft(2, '0')}",
    "warrantyExpiryDate":
        "${warrantyExpiryDate!.year.toString().padLeft(4, '0')}-${warrantyExpiryDate!.month.toString().padLeft(2, '0')}-${warrantyExpiryDate!.day.toString().padLeft(2, '0')}",
    "lastMaintenanceDate":
        "${lastMaintenanceDate!.year.toString().padLeft(4, '0')}-${lastMaintenanceDate!.month.toString().padLeft(2, '0')}-${lastMaintenanceDate!.day.toString().padLeft(2, '0')}",
    "nextMaintenanceDate":
        "${nextMaintenanceDate!.year.toString().padLeft(4, '0')}-${nextMaintenanceDate!.month.toString().padLeft(2, '0')}-${nextMaintenanceDate!.day.toString().padLeft(2, '0')}",
    "maintenanceIntervalDays": maintenanceIntervalDays,
    "runningHoursAtInstallation": runningHoursAtInstallation,
    "supplierName": supplierName,
    "supplierContact": supplierContact,
    "location": location,
    "active": active,
    "id": id,
  };
}

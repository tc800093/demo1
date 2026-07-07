// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

import 'package:path/path.dart';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  bool? isLive;
  String? deviceId;
  String? deviceName;
  String? currentPowerSource;
  String? applicationType;
  String? locationName;
  MainsModel? mains;
  Generator? generator;
  DateTime? lastUpdated;

  DashboardModel({
    this.deviceId,
    this.deviceName,
    this.currentPowerSource,
    this.mains,
    this.generator,
    this.locationName,
    this.applicationType,
    this.lastUpdated,
    this.isLive = false,
  });

  DashboardModel copyWith({
    bool? isLive,
    String? deviceId,
    String? deviceName,
    String? currentPowerSource,
    MainsModel? mains,
    String? applicationType,
    Generator? generator,
    DateTime? lastUpdated,
    String? locationName,
  }) => DashboardModel(
    isLive: isLive ?? this.isLive,
    deviceId: deviceId ?? this.deviceId,
    deviceName: deviceName ?? this.deviceName,
    currentPowerSource: currentPowerSource ?? this.currentPowerSource,
    mains: mains ?? this.mains,
    generator: generator ?? this.generator,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    applicationType: applicationType ?? this.applicationType,
    locationName: locationName ?? this.locationName,
  );

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    deviceId: json["deviceId"],
    deviceName: json["deviceName"],
    currentPowerSource: json["currentPowerSource"],
    mains: json["mains"] == null ? null : MainsModel.fromJson(json["mains"]),
    generator: json["generator"] == null
        ? null
        : Generator.fromJson(json["generator"]),
    lastUpdated: json["lastUpdated"] == null
        ? null
        : DateTime.parse(json["lastUpdated"]),
    applicationType: json["applicationType"],
    locationName: json['locationName'],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "deviceName": deviceName,
    "currentPowerSource": currentPowerSource,
    "mains": mains?.toJson(),
    "generator": generator?.toJson(),
    "lastUpdated": lastUpdated?.toIso8601String(),
    "applicationType": applicationType.toString(),
    "locationName": locationName.toString(),
  };
}

class Generator {
  bool? status;
  dynamic autoManualMode;
  double? fuelLevel;
  double? engineTemperature;
  double? oilPressure;
  double? batteryVoltage;
  dynamic alternatorVoltage;
  double? runtimeHours;
  int? startCount;
  bool? overloadStatus;
  String? dgStatus;
  bool? emergencyStopStatus;
  bool? dgFaultStatus;
  dynamic current;
  double? outputVoltage;
  String? warningMessage;
  String? generatorHealth;

  Generator({
    this.status,
    this.autoManualMode,
    this.fuelLevel,
    this.engineTemperature,
    this.oilPressure,
    this.batteryVoltage,
    this.alternatorVoltage,
    this.runtimeHours,
    this.startCount,
    this.overloadStatus,
    this.emergencyStopStatus,
    this.dgFaultStatus,
    this.current,
    this.dgStatus,
    this.outputVoltage,
    this.warningMessage,
    this.generatorHealth,
  });

  Generator copyWith({
    bool? status,
    dynamic autoManualMode,
    double? fuelLevel,
    double? engineTemperature,
    double? oilPressure,
    double? batteryVoltage,
    dynamic alternatorVoltage,
    double? runtimeHours,
    int? startCount,
    bool? overloadStatus,
    bool? emergencyStopStatus,
    bool? dgFaultStatus,
    dynamic current,
    String? dgStatus,
    double? outputVoltage,
    String? warningMessage,
    String? generatorHealth,
  }) => Generator(
    status: status ?? this.status,
    autoManualMode: autoManualMode ?? this.autoManualMode,
    fuelLevel: fuelLevel ?? this.fuelLevel,
    engineTemperature: engineTemperature ?? this.engineTemperature,
    oilPressure: oilPressure ?? this.oilPressure,
    batteryVoltage: batteryVoltage ?? this.batteryVoltage,
    alternatorVoltage: alternatorVoltage ?? this.alternatorVoltage,
    runtimeHours: runtimeHours ?? this.runtimeHours,
    startCount: startCount ?? this.startCount,
    overloadStatus: overloadStatus ?? this.overloadStatus,
    emergencyStopStatus: emergencyStopStatus ?? this.emergencyStopStatus,
    dgFaultStatus: dgFaultStatus ?? this.dgFaultStatus,
    current: current ?? this.current,
    dgStatus: dgStatus ?? this.dgStatus,
    outputVoltage: outputVoltage ?? this.outputVoltage,
    warningMessage: warningMessage ?? this.warningMessage,
    generatorHealth: generatorHealth ?? this.generatorHealth,
  );

  factory Generator.fromJson(Map<String, dynamic> json) => Generator(
    status: json["status"],
    autoManualMode: json["autoManualMode"],
    fuelLevel: json["fuelLevel"],
    engineTemperature: json["engineTemperature"],
    oilPressure: json["oilPressure"]?.toDouble(),
    batteryVoltage: json["batteryVoltage"]?.toDouble(),
    alternatorVoltage: json["alternatorVoltage"],
    runtimeHours: json["runtimeHours"],
    startCount: json["startCount"],
    overloadStatus: json["overloadStatus"],
    emergencyStopStatus: json["emergencyStopStatus"],
    dgFaultStatus: json["dgFaultStatus"],
    current: json["current"],
    dgStatus: json['dgStatus'] != null ? json['dgStatus'].toString() : '',
    outputVoltage: json['outputVoltage'] ?? 0.0,
    warningMessage: json['warningMessage'] ?? '',
    generatorHealth: json['generatorHealth'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "autoManualMode": autoManualMode,
    "fuelLevel": fuelLevel,
    "engineTemperature": engineTemperature,
    "oilPressure": oilPressure,
    "batteryVoltage": batteryVoltage,
    "alternatorVoltage": alternatorVoltage,
    "runtimeHours": runtimeHours,
    "startCount": startCount,
    "overloadStatus": overloadStatus,
    "emergencyStopStatus": emergencyStopStatus,
    "dgFaultStatus": dgFaultStatus,
    "current": current,
    "dgStatus": dgStatus,
    "outputVoltage": outputVoltage,
    "generatorHealth": generatorHealth,
  };
}

class MainsModel {
  bool? status;
  bool? phaseFailure;
  double? voltage;
  double? frequency;
  int? outageCount;
  String? currnet;
  String? meterReading;
  String? billingCycleStart;
  String? billingCycleEnd;
  double? electricityConsumption;
  String? phaseType;
  double? dailyConsumption;
  bool? rPhaseStatus;
  bool? yPhaseStatus;
  bool? bPhaseStatus;
  double? outageDurationMinutes;

  MainsModel({
    this.status,
    this.phaseFailure,
    this.voltage,
    this.frequency,
    this.outageCount,
    this.electricityConsumption,
    this.phaseType,
    this.dailyConsumption,
    this.rPhaseStatus,
    this.yPhaseStatus,
    this.bPhaseStatus,
    this.currnet,
    this.outageDurationMinutes,
    this.billingCycleEnd,
    this.billingCycleStart,
    this.meterReading,
  });

  MainsModel copyWith({
    bool? status,
    bool? phaseFailure,
    double? voltage,
    double? frequency,
    int? outageCount,
    double? electricityConsumption,
    String? phaseType,
    double? dailyConsumption,
    bool? rPhaseStatus,
    bool? yPhaseStatus,
    bool? bPhaseStatus,
    String? currnet,
    String? meterReading,
    String? billingCycleStart,
    String? billingCycleEnd,
    double? outageDurationMinutes,
  }) => MainsModel(
    status: status ?? this.status,
    phaseFailure: phaseFailure ?? this.phaseFailure,
    voltage: voltage ?? this.voltage,
    frequency: frequency ?? this.frequency,
    outageCount: outageCount ?? this.outageCount,
    electricityConsumption:
        electricityConsumption ?? this.electricityConsumption,
    phaseType: phaseType ?? this.phaseType,
    dailyConsumption: dailyConsumption ?? this.dailyConsumption,
    rPhaseStatus: rPhaseStatus ?? this.rPhaseStatus,
    yPhaseStatus: yPhaseStatus ?? this.yPhaseStatus,
    bPhaseStatus: bPhaseStatus ?? this.bPhaseStatus,
    currnet: currnet ?? this.currnet,
    outageDurationMinutes: outageDurationMinutes ?? this.outageDurationMinutes,
    billingCycleEnd: billingCycleEnd ?? this.billingCycleEnd,
    billingCycleStart: billingCycleStart ?? this.billingCycleEnd,
    meterReading: meterReading ?? this.meterReading,
  );

  factory MainsModel.fromJson(Map<String, dynamic> json) => MainsModel(
    status: json["status"],
    phaseFailure: json["phaseFailure"] ?? false,
    voltage: json["voltage"] ?? 0.0,
    frequency: json["frequency"] ?? 0.0,
    outageCount: json["outageCount"] ?? 0,
    electricityConsumption: json["electricityConsumption"] ?? 0.0,
    phaseType: json["phaseType"],
    dailyConsumption: json["dailyConsumption"] ?? 0.0,
    rPhaseStatus: json['rPhaseStatus'] ?? false,
    yPhaseStatus: json['yPhaseStatus'] ?? false,
    bPhaseStatus: json['bPhaseStatus'] ?? false,

    meterReading: json['meterReading'],
    billingCycleEnd: json['billingCycleEnd'],
    billingCycleStart: json['billingCycleStart'],
    currnet: json['current'] != null ? json['current'].toString() : '0.0',
    outageDurationMinutes: json['outageDurationMinutes'],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "phaseFailure": phaseFailure,
    "voltage": voltage,
    "frequency": frequency,
    "outageCount": outageCount,
    "electricityConsumption": electricityConsumption,
    "phaseType": phaseType,
    "dailyConsumption": dailyConsumption,
    "rPhaseStatus": rPhaseStatus,
    "yPhaseStatus": yPhaseStatus,
    "bPhaseStatus": bPhaseStatus,
    "current": current,
    "outageDurationMinutes": outageDurationMinutes,
    "billingCycleEnd": billingCycleEnd,
    "billingCycleStart": billingCycleStart,
    "meterReading": meterReading,
  };
}

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
  double? dailyRuntime;
  double? dailyFuelUseage;
  double? estimatedRuntimeBasedOnCurrentFuelInHours;
  double? averageRuntimeRuntimeBasedIftFuelIsFullInHours;
  double? generatorBillingCycleHours;
  int? startCount;
  bool? overloadStatus;
  String? dgStatus;
  bool? emergencyStopStatus;
  bool? dgFaultStatus;
  dynamic current;
  double? outputVoltage;
  String? warningMessage;
  String? generatorHealth;
  String? nextServiceDate;
  String? lastFuelDate;
  double? waterLevel;
  double? generatorVoltage;
  bool? lowCoolant;

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
    this.dailyRuntime,
    this.generatorBillingCycleHours,
    this.overloadStatus,
    this.emergencyStopStatus,
    this.dgFaultStatus,
    this.current,
    this.dgStatus,
    this.outputVoltage,
    this.warningMessage,
    this.generatorHealth,
    this.averageRuntimeRuntimeBasedIftFuelIsFullInHours,
    this.dailyFuelUseage,
    this.estimatedRuntimeBasedOnCurrentFuelInHours,
    this.lastFuelDate,
    this.nextServiceDate,
    this.waterLevel,
    this.generatorVoltage,
    this.lowCoolant,
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
    double? dailyRuntime,
    double? generatorBillingCycleHours,
    int? startCount,
    bool? overloadStatus,
    bool? emergencyStopStatus,
    bool? dgFaultStatus,
    dynamic current,
    String? dgStatus,
    double? outputVoltage,
    String? warningMessage,
    String? generatorHealth,
    double? dailyFuelUseage,
    double? estimatedRuntimeBasedOnCurrentFuelInHours,
    double? averageRuntimeRuntimeBasedIftFuelIsFullInHours,
    String? nextServiceDate,
    String? lastFuelDate,
    double? waterLevel,
    double? generatorVoltage,
    bool? lowCoolant,
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
    generatorBillingCycleHours:
        generatorBillingCycleHours ?? this.generatorBillingCycleHours,
    averageRuntimeRuntimeBasedIftFuelIsFullInHours:
        averageRuntimeRuntimeBasedIftFuelIsFullInHours ??
        this.averageRuntimeRuntimeBasedIftFuelIsFullInHours,
    dailyFuelUseage: dailyFuelUseage ?? this.dailyFuelUseage,
    dailyRuntime: dailyRuntime ?? this.dailyRuntime,
    estimatedRuntimeBasedOnCurrentFuelInHours:
        estimatedRuntimeBasedOnCurrentFuelInHours ??
        this.estimatedRuntimeBasedOnCurrentFuelInHours,
    lastFuelDate: lastFuelDate ?? this.lastFuelDate,
    nextServiceDate: nextServiceDate ?? this.nextServiceDate,
    waterLevel: waterLevel ?? this.waterLevel,
    generatorVoltage: generatorVoltage ?? this.generatorVoltage,
    lowCoolant: lowCoolant ?? this.lowCoolant,
  );

  factory Generator.fromJson(Map<String, dynamic> json) => Generator(
    status: json["status"],
    autoManualMode: json["autoManualMode"],
    fuelLevel: json["fuelLevel"],
    engineTemperature: json["engineTemperature"],
    oilPressure: json["oilPressure"]?.toDouble(),
    batteryVoltage: json["batteryVoltage"]?.toDouble(),
    alternatorVoltage: json["alternatorVoltage"],
    runtimeHours: json["runtimeMinutes"],
    startCount: json["startCount"],
    overloadStatus: json["overloadStatus"],
    emergencyStopStatus: json["emergencyStopStatus"],
    dgFaultStatus: json["dgFaultStatus"],
    current: json["current"],
    dgStatus: json['dgStatus'] != null ? json['dgStatus'].toString() : '',
    outputVoltage: json['outputVoltage'] ?? 0.0,
    warningMessage: json['warningMessage'] ?? '',
    generatorHealth: json['generatorHealth'] ?? '',
    generatorBillingCycleHours: json['billingCycleRuntimeHours'] ?? 0.0,
    dailyFuelUseage: json['dailyFuelConsumption'] ?? 0.0,
    estimatedRuntimeBasedOnCurrentFuelInHours:
        json['estimatedRuntimeHours'] ?? 0.0,
    averageRuntimeRuntimeBasedIftFuelIsFullInHours:
        json['averageRuntimeFullTankHours'] ?? 0.0,
    nextServiceDate: json['nextServiceDate'] ?? '',
    lastFuelDate: json['latestRefuelDate'] ?? '',
    waterLevel: json['waterLevel'] ?? 0,
    generatorVoltage: json['generatorVoltage'] ?? 0.0,
    lowCoolant: json['lowCoolant'] ?? false,
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
    "billingCycleRuntimeHours": generatorBillingCycleHours,
    "dailyFuelConsumption": dailyFuelUseage,
    "estimatedRuntimeHours": estimatedRuntimeBasedOnCurrentFuelInHours,
    "averageRuntimeFullTankHours":
        averageRuntimeRuntimeBasedIftFuelIsFullInHours,
    "nextServiceDate": nextServiceDate,
    "latestRefuelDate": lastFuelDate,
    "waterLevel": waterLevel,
    "generatorVoltage": generatorVoltage,
    "lowCoolant": lowCoolant,
  };
}

class MainsModel {
  bool? status;
  bool? phaseFailure;
  double? voltage;
  double? frequency;
  int? outageCount;
  String? currnet;
  double? meterReading;
  String? billingCycleStart;
  String? billingCycleEnd;
  double? electricityConsumption;
  double? previousMonthMeterReading;
  int? mainsOnRuntimeInHourUsingBillingCycleInHours;
  String? phaseType;
  double? dailyConsumption;
  bool? rPhaseStatus;
  bool? yPhaseStatus;
  bool? bPhaseStatus;
  double? outageDuratioHours;

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
    this.outageDuratioHours,
    this.billingCycleEnd,
    this.billingCycleStart,
    this.meterReading,
    this.mainsOnRuntimeInHourUsingBillingCycleInHours,
    this.previousMonthMeterReading,
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
    double? meterReading,
    String? billingCycleStart,
    String? billingCycleEnd,
    double? outageDuratioHours,
    double? previousMonthMeterReading,
    int? mainsOnRuntimeInHourUsingBillingCycleInHours,
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
    billingCycleEnd: billingCycleEnd ?? this.billingCycleEnd,
    billingCycleStart: billingCycleStart ?? this.billingCycleEnd,
    meterReading: meterReading ?? this.meterReading,
    mainsOnRuntimeInHourUsingBillingCycleInHours:
        mainsOnRuntimeInHourUsingBillingCycleInHours ??
        this.mainsOnRuntimeInHourUsingBillingCycleInHours,
    outageDuratioHours: outageDuratioHours ?? this.outageDuratioHours,
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
    rPhaseStatus: json['rphaseStatus'],
    yPhaseStatus: json['yphaseStatus'],
    bPhaseStatus: json['bphaseStatus'],
    meterReading: json['meterReading'],
    billingCycleEnd: json['billingCycleEnd'],
    billingCycleStart: json['billingCycleStart'],
    mainsOnRuntimeInHourUsingBillingCycleInHours:
        json['billingCycleOutageDurationMinutes'] ?? 0,
    currnet: json['current'] != null ? json['current'].toString() : '0.0',
    outageDuratioHours: double.parse(
      json['outageDurationMinutes'] != null
          ? json['outageDurationMinutes'].toString()
          : '0',
    ),
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
    "rphaseStatus": rPhaseStatus,
    "yphaseStatus": yPhaseStatus,
    "bphaseStatus": bPhaseStatus,
    "current": current,
    "outageDurationMinutes": outageDuratioHours,
    "billingCycleEnd": billingCycleEnd,
    "billingCycleStart": billingCycleStart,
    "meterReading": meterReading,
    "billingCycleOutageDurationMinutes":
        mainsOnRuntimeInHourUsingBillingCycleInHours,
  };
}

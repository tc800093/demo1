// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  String? currentPowerSource;
  Mseb? mseb;
  Generator? generator;
  DateTime? lastUpdated;

  DashboardModel({
    this.currentPowerSource,
    this.mseb,
    this.generator,
    this.lastUpdated,
  });

  DashboardModel copyWith({
    String? currentPowerSource,
    Mseb? mseb,
    Generator? generator,
    DateTime? lastUpdated,
  }) => DashboardModel(
    currentPowerSource: currentPowerSource ?? this.currentPowerSource,
    mseb: mseb ?? this.mseb,
    generator: generator ?? this.generator,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    currentPowerSource: json["currentPowerSource"],
    mseb: json["mseb"] == null ? null : Mseb.fromJson(json["mseb"]),
    generator: json["generator"] == null
        ? null
        : Generator.fromJson(json["generator"]),
    lastUpdated: json["lastUpdated"] == null
        ? null
        : DateTime.parse(json["lastUpdated"]),
  );

  Map<String, dynamic> toJson() => {
    "currentPowerSource": currentPowerSource,
    "mseb": mseb?.toJson(),
    "generator": generator?.toJson(),
    "lastUpdated": lastUpdated?.toIso8601String(),
  };
}

class Generator {
  bool? status;
  double? outputVoltage;
  int? startCount;
  String? healthStatus;
  double? fuelLevel;
  double? oilPressure;
  double? engineTemperature;
  dynamic generatorLoadKw;
  dynamic runtimeMinutes;
  bool? warningStatus;
  String? warningMessage;

  Generator({
    this.status,
    this.outputVoltage,
    this.startCount,
    this.healthStatus,
    this.fuelLevel,
    this.oilPressure,
    this.engineTemperature,
    this.generatorLoadKw,
    this.runtimeMinutes,
    this.warningMessage,
    this.warningStatus,
  });

  Generator copyWith({
    bool? status,
    double? outputVoltage,
    int? startCount,
    String? healthStatus,
    double? fuelLevel,
    double? oilPressure,
    double? engineTemperature,
    dynamic generatorLoadKw,
    dynamic runtimeMinutes,
    bool? warningStatus,
    String? warningMessage,
  }) => Generator(
    status: status ?? this.status,
    outputVoltage: outputVoltage ?? this.outputVoltage,
    startCount: startCount ?? this.startCount,
    healthStatus: healthStatus ?? this.healthStatus,
    fuelLevel: fuelLevel ?? this.fuelLevel,
    oilPressure: oilPressure ?? this.oilPressure,
    engineTemperature: engineTemperature ?? this.engineTemperature,
    generatorLoadKw: generatorLoadKw ?? this.generatorLoadKw,
    runtimeMinutes: runtimeMinutes ?? this.runtimeMinutes,
    warningMessage: warningMessage ?? this.warningMessage,
    warningStatus: warningStatus ?? this.warningStatus,
  );

  factory Generator.fromJson(Map<String, dynamic> json) => Generator(
    status: json["status"],
    outputVoltage: json["outputVoltage"],
    startCount: json["startCount"],
    healthStatus: json["healthStatus"],
    fuelLevel: json["fuelLevel"],
    oilPressure: json["oilPressure"]?.toDouble(),
    engineTemperature: json["engineTemperature"],
    generatorLoadKw: json["generatorLoadKw"],
    runtimeMinutes: json["runtimeMinutes"],
    warningMessage: json["warningMessage"],
    warningStatus: json["warningStatus"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "outputVoltage": outputVoltage,
    "startCount": startCount,
    "healthStatus": healthStatus,
    "fuelLevel": fuelLevel,
    "oilPressure": oilPressure,
    "engineTemperature": engineTemperature,
    "generatorLoadKw": generatorLoadKw,
    "runtimeMinutes": runtimeMinutes,
    "warningMessage": warningMessage,
    "warningStatus": warningStatus,
  };
}

class Mseb {
  bool? status;
  double? voltage;
  double? frequency;
  double? current;
  String? phaseType;
  double? unitConsumption;
  int? outageCount;
  dynamic outageDuration;

  Mseb({
    this.status,
    this.voltage,
    this.frequency,
    this.outageCount,
    this.outageDuration,
    this.current,
    this.phaseType,
    this.unitConsumption,
  });

  Mseb copyWith({
    bool? status,
    double? voltage,
    double? frequency,
    double? current,
    String? phaseType,
    double? unitConsumption,
    int? outageCount,
    dynamic outageDuration,
  }) => Mseb(
    status: status ?? this.status,
    voltage: voltage ?? this.voltage,
    frequency: frequency ?? this.frequency,
    outageCount: outageCount ?? this.outageCount,
    outageDuration: outageDuration ?? this.outageDuration,
    current: current ?? this.current,
    phaseType: phaseType ?? this.phaseType,
    unitConsumption: unitConsumption ?? this.unitConsumption,
  );

  factory Mseb.fromJson(Map<String, dynamic> json) => Mseb(
    status: json["status"],
    voltage: json["voltage"],
    frequency: json["frequency"],
    outageCount: json["outageCount"],
    outageDuration: json["outageDuration"],
    current: double.parse(json["current"] ?? '0.0'),
    phaseType: json["phaseType"] ?? 'NA',
    unitConsumption: double.parse(json["unitConsumption"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "voltage": voltage,
    "frequency": frequency,
    "outageCount": outageCount,
    "outageDuration": outageDuration,
    "current": current,
    "phaseType": phaseType,
    "unitConsumption": unitConsumption,
  };
}

// To parse this JSON data, do
//
//     final analyticsModel = analyticsModelFromJson(jsonString);

import 'dart:convert';

AnalyticsModel analyticsModelFromJson(String str) =>
    AnalyticsModel.fromJson(json.decode(str));

String analyticsModelToJson(AnalyticsModel data) => json.encode(data.toJson());

class AnalyticsModel {
  String? applicationType;
  MsebAnalytics? msebAnalytics;
  GeneratorAnalytics? generatorAnalytics;
  List<EventHistory>? eventHistory;
  List<AlarmHistory>? alarmHistory;

  AnalyticsModel({
    this.applicationType,
    this.msebAnalytics,
    this.generatorAnalytics,
    this.eventHistory,
    this.alarmHistory,
  });

  AnalyticsModel copyWith({
    String? applicationType,
    MsebAnalytics? msebAnalytics,
    GeneratorAnalytics? generatorAnalytics,
    List<EventHistory>? eventHistory,
    List<AlarmHistory>? alarmHistory,
  }) => AnalyticsModel(
    applicationType: applicationType ?? this.applicationType,
    msebAnalytics: msebAnalytics ?? this.msebAnalytics,
    generatorAnalytics: generatorAnalytics ?? this.generatorAnalytics,
    eventHistory: eventHistory ?? this.eventHistory,
    alarmHistory: alarmHistory ?? this.alarmHistory,
  );

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) => AnalyticsModel(
    applicationType: json["applicationType"],
    msebAnalytics: json["msebAnalytics"] == null
        ? null
        : MsebAnalytics.fromJson(json["msebAnalytics"]),
    generatorAnalytics: json["generatorAnalytics"] == null
        ? null
        : GeneratorAnalytics.fromJson(json["generatorAnalytics"]),
    eventHistory: json["eventHistory"] == null
        ? []
        : List<EventHistory>.from(
            json["eventHistory"]!.map((x) => EventHistory.fromJson(x)),
          ),
    alarmHistory: json["alarmHistory"] == null
        ? []
        : List<AlarmHistory>.from(
            json["alarmHistory"]!.map((x) => AlarmHistory.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "applicationType": applicationType,
    "msebAnalytics": msebAnalytics?.toJson(),
    "generatorAnalytics": generatorAnalytics?.toJson(),
    "eventHistory": eventHistory == null
        ? []
        : List<dynamic>.from(eventHistory!.map((x) => x.toJson())),
    "alarmHistory": alarmHistory == null
        ? []
        : List<dynamic>.from(alarmHistory!.map((x) => x.toJson())),
  };
}

class AlarmHistory {
  AlarmName? alarmName;
  AlarmMessage? alarmMessage;
  Severity? severity;
  DateTime? alarmTime;

  AlarmHistory({
    this.alarmName,
    this.alarmMessage,
    this.severity,
    this.alarmTime,
  });

  AlarmHistory copyWith({
    AlarmName? alarmName,
    AlarmMessage? alarmMessage,
    Severity? severity,
    DateTime? alarmTime,
  }) => AlarmHistory(
    alarmName: alarmName ?? this.alarmName,
    alarmMessage: alarmMessage ?? this.alarmMessage,
    severity: severity ?? this.severity,
    alarmTime: alarmTime ?? this.alarmTime,
  );

  factory AlarmHistory.fromJson(Map<String, dynamic> json) => AlarmHistory(
    alarmName: alarmNameValues.map[json["alarmName"]]!,
    alarmMessage: alarmMessageValues.map[json["alarmMessage"]]!,
    severity: severityValues.map[json["severity"]]!,
    alarmTime: json["alarmTime"] == null
        ? null
        : DateTime.parse(json["alarmTime"]),
  );

  Map<String, dynamic> toJson() => {
    "alarmName": alarmNameValues.reverse[alarmName],
    "alarmMessage": alarmMessageValues.reverse[alarmMessage],
    "severity": severityValues.reverse[severity],
    "alarmTime": alarmTime?.toIso8601String(),
  };
}

enum AlarmMessage {
  FUEL_LEVEL_LOW,
  GENERATOR_FAULT_DETECTED,
  GENERATOR_OVERLOADED,
}

final alarmMessageValues = EnumValues({
  "Fuel Level Low": AlarmMessage.FUEL_LEVEL_LOW,
  "Generator Fault Detected": AlarmMessage.GENERATOR_FAULT_DETECTED,
  "Generator Overloaded": AlarmMessage.GENERATOR_OVERLOADED,
});

enum AlarmName { DG_FAULT, LOW_FUEL, OVERLOAD }

final alarmNameValues = EnumValues({
  "DG_FAULT": AlarmName.DG_FAULT,
  "LOW_FUEL": AlarmName.LOW_FUEL,
  "OVERLOAD": AlarmName.OVERLOAD,
});

enum Severity { CRITICAL, HIGH }

final severityValues = EnumValues({
  "CRITICAL": Severity.CRITICAL,
  "HIGH": Severity.HIGH,
});

class EventHistory {
  String? eventType;
  String? eventMessage;
  DateTime? eventTime;

  EventHistory({this.eventType, this.eventMessage, this.eventTime});

  EventHistory copyWith({
    String? eventType,
    String? eventMessage,
    DateTime? eventTime,
  }) => EventHistory(
    eventType: eventType ?? this.eventType,
    eventMessage: eventMessage ?? this.eventMessage,
    eventTime: eventTime ?? this.eventTime,
  );

  factory EventHistory.fromJson(Map<String, dynamic> json) => EventHistory(
    eventType: json["eventType"],
    eventMessage: json["eventMessage"],
    eventTime: json["eventTime"] == null
        ? null
        : DateTime.parse(json["eventTime"]),
  );

  Map<String, dynamic> toJson() => {
    "eventType": eventType,
    "eventMessage": eventMessage,
    "eventTime": eventTime?.toIso8601String(),
  };
}

class GeneratorAnalytics {
  int? generatorStartCount;
  int? generatorStopCount;
  dynamic generatorOnDuration;
  double? dailyFuelConsumption;
  double? monthlyFuelConsumption;
  dynamic generatorHealthStatus;
  double? batteryVoltage;
  bool? dgFaultStatus;
  bool? overloadStatus;
  dynamic fuelTheftDetected;
  double? fuelLevel;
  dynamic maintenanceServiceStatus;

  GeneratorAnalytics({
    this.generatorStartCount,
    this.generatorStopCount,
    this.generatorOnDuration,
    this.dailyFuelConsumption,
    this.monthlyFuelConsumption,
    this.generatorHealthStatus,
    this.batteryVoltage,
    this.dgFaultStatus,
    this.overloadStatus,
    this.fuelTheftDetected,
    this.fuelLevel,
    this.maintenanceServiceStatus,
  });

  GeneratorAnalytics copyWith({
    int? generatorStartCount,
    int? generatorStopCount,
    dynamic generatorOnDuration,
    double? dailyFuelConsumption,
    double? monthlyFuelConsumption,
    dynamic generatorHealthStatus,
    double? batteryVoltage,
    bool? dgFaultStatus,
    bool? overloadStatus,
    dynamic fuelTheftDetected,
    double? fuelLevel,
    dynamic maintenanceServiceStatus,
  }) => GeneratorAnalytics(
    generatorStartCount: generatorStartCount ?? this.generatorStartCount,
    generatorStopCount: generatorStopCount ?? this.generatorStopCount,
    generatorOnDuration: generatorOnDuration ?? this.generatorOnDuration,
    dailyFuelConsumption: dailyFuelConsumption ?? this.dailyFuelConsumption,
    monthlyFuelConsumption:
        monthlyFuelConsumption ?? this.monthlyFuelConsumption,
    generatorHealthStatus: generatorHealthStatus ?? this.generatorHealthStatus,
    batteryVoltage: batteryVoltage ?? this.batteryVoltage,
    dgFaultStatus: dgFaultStatus ?? this.dgFaultStatus,
    overloadStatus: overloadStatus ?? this.overloadStatus,
    fuelTheftDetected: fuelTheftDetected ?? this.fuelTheftDetected,
    fuelLevel: fuelLevel ?? this.fuelLevel,
    maintenanceServiceStatus:
        maintenanceServiceStatus ?? this.maintenanceServiceStatus,
  );

  factory GeneratorAnalytics.fromJson(Map<String, dynamic> json) =>
      GeneratorAnalytics(
        generatorStartCount: json["generatorStartCount"],
        generatorStopCount: json["generatorStopCount"],
        generatorOnDuration: json["generatorOnDuration"],
        dailyFuelConsumption: json["dailyFuelConsumption"],
        monthlyFuelConsumption: json["monthlyFuelConsumption"],
        generatorHealthStatus: json["generatorHealthStatus"],
        batteryVoltage: json["batteryVoltage"]?.toDouble(),
        dgFaultStatus: json["dgFaultStatus"],
        overloadStatus: json["overloadStatus"],
        fuelTheftDetected: json["fuelTheftDetected"],
        fuelLevel: json["fuelLevel"],
        maintenanceServiceStatus: json["maintenanceServiceStatus"],
      );

  Map<String, dynamic> toJson() => {
    "generatorStartCount": generatorStartCount,
    "generatorStopCount": generatorStopCount,
    "generatorOnDuration": generatorOnDuration,
    "dailyFuelConsumption": dailyFuelConsumption,
    "monthlyFuelConsumption": monthlyFuelConsumption,
    "generatorHealthStatus": generatorHealthStatus,
    "batteryVoltage": batteryVoltage,
    "dgFaultStatus": dgFaultStatus,
    "overloadStatus": overloadStatus,
    "fuelTheftDetected": fuelTheftDetected,
    "fuelLevel": fuelLevel,
    "maintenanceServiceStatus": maintenanceServiceStatus,
  };
}

class MsebAnalytics {
  dynamic powerFailureDurationMinutes;
  dynamic lastPowerFailureTime;
  dynamic lastPowerRestoreTime;
  int? outageCountPerDay;
  int? phaseFailureCount;
  double? downtimeDurationMinutes;
  double? averageVoltage;
  double? averageFrequency;

  MsebAnalytics({
    this.powerFailureDurationMinutes,
    this.lastPowerFailureTime,
    this.lastPowerRestoreTime,
    this.outageCountPerDay,
    this.phaseFailureCount,
    this.downtimeDurationMinutes,
    this.averageVoltage,
    this.averageFrequency,
  });

  MsebAnalytics copyWith({
    dynamic powerFailureDurationMinutes,
    dynamic lastPowerFailureTime,
    dynamic lastPowerRestoreTime,
    int? outageCountPerDay,
    int? phaseFailureCount,
    double? downtimeDurationMinutes,
    double? averageVoltage,
    double? averageFrequency,
  }) => MsebAnalytics(
    powerFailureDurationMinutes:
        powerFailureDurationMinutes ?? this.powerFailureDurationMinutes,
    lastPowerFailureTime: lastPowerFailureTime ?? this.lastPowerFailureTime,
    lastPowerRestoreTime: lastPowerRestoreTime ?? this.lastPowerRestoreTime,
    outageCountPerDay: outageCountPerDay ?? this.outageCountPerDay,
    phaseFailureCount: phaseFailureCount ?? this.phaseFailureCount,
    downtimeDurationMinutes:
        downtimeDurationMinutes ?? this.downtimeDurationMinutes,
    averageVoltage: averageVoltage ?? this.averageVoltage,
    averageFrequency: averageFrequency ?? this.averageFrequency,
  );

  factory MsebAnalytics.fromJson(Map<String, dynamic> json) => MsebAnalytics(
    powerFailureDurationMinutes: json["powerFailureDurationMinutes"],
    lastPowerFailureTime: json["lastPowerFailureTime"],
    lastPowerRestoreTime: json["lastPowerRestoreTime"],
    outageCountPerDay: json["outageCountPerDay"],
    phaseFailureCount: json["phaseFailureCount"],
    downtimeDurationMinutes: json["downtimeDurationMinutes"],
    averageVoltage: json["averageVoltage"]?.toDouble(),
    averageFrequency: json["averageFrequency"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "powerFailureDurationMinutes": powerFailureDurationMinutes,
    "lastPowerFailureTime": lastPowerFailureTime,
    "lastPowerRestoreTime": lastPowerRestoreTime,
    "outageCountPerDay": outageCountPerDay,
    "phaseFailureCount": phaseFailureCount,
    "downtimeDurationMinutes": downtimeDurationMinutes,
    "averageVoltage": averageVoltage,
    "averageFrequency": averageFrequency,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

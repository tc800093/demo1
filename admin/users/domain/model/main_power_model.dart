// To parse this JSON data, do
//
//     final mainPowerModel = mainPowerModelFromJson(jsonString);

import 'dart:convert';

MainPowerModel mainPowerModelFromJson(String str) =>
    MainPowerModel.fromJson(json.decode(str));

String mainPowerModelToJson(MainPowerModel data) => json.encode(data.toJson());

class MainPowerModel {
  String? deviceId;
  dynamic id;
  String? connectionName;
  String? meterNumber;
  dynamic electricityBoard;
  String? phaseType;

  MainPowerModel({
    this.deviceId,
    this.id,
    this.connectionName,
    this.meterNumber,
    this.electricityBoard,
    this.phaseType,
  });

  MainPowerModel copyWith({
    String? deviceId,
    dynamic id,
    String? connectionName,
    String? meterNumber,
    dynamic electricityBoard,
    String? phaseType,
  }) => MainPowerModel(
    deviceId: deviceId ?? this.deviceId,
    id: id ?? this.id,
    connectionName: connectionName ?? this.connectionName,
    meterNumber: meterNumber ?? this.meterNumber,
    electricityBoard: electricityBoard ?? this.electricityBoard,
    phaseType: phaseType ?? this.phaseType,
  );

  factory MainPowerModel.fromJson(Map<String, dynamic> json) => MainPowerModel(
    deviceId: json["deviceId"],
    id: json["id"],
    connectionName: json["connectionName"],
    meterNumber: json["meterNumber"],
    electricityBoard: json["electricityBoard"],
    phaseType: json["phaseType"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "id": id,
    "connectionName": connectionName,
    "meterNumber": meterNumber,
    "electricityBoard": electricityBoard,
    "phaseType": phaseType,
  };
}

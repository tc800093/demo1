// To parse this JSON data, do
//
//     final deviceModel = deviceModelFromJson(jsonString);

import 'dart:convert';

import 'package:poweriot/features/admin/users/domain/model/generator_model.dart';
import 'package:poweriot/features/admin/users/domain/model/main_power_model.dart';

DeviceModel deviceModelFromJson(String str) =>
    DeviceModel.fromJson(json.decode(str));

String deviceModelToJson(DeviceModel data) => json.encode(data.toJson());

class DeviceModel {
  String? deviceId;
  String? userId;
  String? deviceCode;
  String? deviceName;
  String? locationName;
  String? areaName;
  double? latitude;
  double? longitude;
  int? geofenceRadius;
  String? imeiNo;
  String? simNo;
  bool? active;
  String? applicationType;
  GeneratorModel? generatorModel;
  MainPowerModel? mainPowerModel;

  DeviceModel({
    this.deviceId,
    this.userId,
    this.deviceCode,
    this.deviceName,
    this.locationName,
    this.areaName,
    this.latitude,
    this.longitude,
    this.geofenceRadius,
    this.imeiNo,
    this.simNo,
    this.active,
    this.applicationType,
    this.generatorModel,
    this.mainPowerModel,
  });

  DeviceModel copyWith({
    String? deviceId,
    String? userId,
    String? deviceCode,
    String? deviceName,
    String? locationName,
    String? areaName,
    double? latitude,
    double? longitude,
    int? geofenceRadius,
    String? imeiNo,
    String? simNo,
    bool? active,
    String? applicationType,
    GeneratorModel? generatorModel,
    MainPowerModel? mainPowerModel,
  }) => DeviceModel(
    deviceId: deviceId ?? this.deviceId,
    userId: userId ?? this.userId,
    deviceCode: deviceCode ?? this.deviceCode,
    deviceName: deviceName ?? this.deviceName,
    locationName: locationName ?? this.locationName,
    areaName: areaName ?? this.areaName,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    geofenceRadius: geofenceRadius ?? this.geofenceRadius,
    imeiNo: imeiNo ?? this.imeiNo,
    simNo: simNo ?? this.simNo,
    active: active ?? this.active,
    applicationType: applicationType ?? this.applicationType,
    generatorModel: generatorModel ?? this.generatorModel,
    mainPowerModel: mainPowerModel ?? this.mainPowerModel,
  );

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
    deviceId: json["deviceId"],
    userId: json["userId"],
    deviceCode: json["deviceCode"],
    deviceName: json["deviceName"],
    locationName: json["locationName"],
    areaName: json["areaName"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    geofenceRadius: json["geofenceRadius"],
    imeiNo: json["imeiNo"],
    simNo: json["simNo"],
    active: json["active"],
    applicationType: json["applicationType"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "userId": userId,
    "deviceCode": deviceCode,
    "deviceName": deviceName,
    "locationName": locationName,
    "areaName": areaName,
    "latitude": latitude,
    "longitude": longitude,
    "geofenceRadius": geofenceRadius,
    "imeiNo": imeiNo,
    "simNo": simNo,
    "active": active,
    "applicationType": applicationType,
  };
}

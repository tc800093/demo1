// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool? active;
  String? deviceId;
  String? email;
  String? fullName;
  String? mobileNumber;
  String? role;
  String? userId;
  String? organizationName;

  UserModel({
    this.active,
    this.deviceId,
    this.email,
    this.fullName,
    this.mobileNumber,
    this.role,
    this.userId,
    this.organizationName,
  });

  UserModel copyWith({
    bool? active,
    String? deviceId,
    String? email,
    String? fullName,
    String? mobileNumber,
    String? role,
    String? userId,
    String? organizationName,
  }) => UserModel(
    active: active ?? this.active,
    deviceId: deviceId ?? this.deviceId,
    email: email ?? this.email,
    fullName: fullName ?? this.fullName,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    role: role ?? this.role,
    userId: userId ?? this.userId,
    organizationName: organizationName ?? this.organizationName,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    active: json["active"],
    deviceId: json["deviceId"],
    email: json["email"],
    fullName: json["fullName"],
    mobileNumber: json["mobileNumber"],
    role: json["role"],
    userId: json["userId"],
    organizationName: json['organizationName'],
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "deviceId": deviceId,
    "email": email,
    "fullName": fullName,
    "mobileNumber": mobileNumber,
    "role": role,
    "userId": userId,
    "organizationName": organizationName,
  };
}

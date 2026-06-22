// To parse this JSON data, do
//
//     final userSubscriptionModel = userSubscriptionModelFromJson(jsonString);

import 'dart:convert';

UserSubscriptionModel userSubscriptionModelFromJson(String str) =>
    UserSubscriptionModel.fromJson(json.decode(str));

String userSubscriptionModelToJson(UserSubscriptionModel data) =>
    json.encode(data.toJson());

class UserSubscriptionModel {
  String? subscriptionId;
  String? userId;
  String? userName;
  String? planId;
  String? planName;
  double? amount;
  DateTime? startDate;
  DateTime? expiryDate;
  String? status;
  String? paymentType;
  String? paymentMode;
  DateTime? paymentDate;
  String? transactionId;
  String? remarks;

  UserSubscriptionModel({
    this.subscriptionId,
    this.userId,
    this.userName,
    this.planId,
    this.planName,
    this.amount,
    this.startDate,
    this.expiryDate,
    this.status,
    this.paymentType,
    this.paymentMode,
    this.paymentDate,
    this.transactionId,
    this.remarks,
  });

  UserSubscriptionModel copyWith({
    String? subscriptionId,
    String? userId,
    String? userName,
    String? planId,
    String? planName,
    double? amount,
    DateTime? startDate,
    DateTime? expiryDate,
    String? status,
    String? paymentType,
    String? paymentMode,
    DateTime? paymentDate,
    String? transactionId,
    String? remarks,
  }) => UserSubscriptionModel(
    subscriptionId: subscriptionId ?? this.subscriptionId,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    planId: planId ?? this.planId,
    planName: planName ?? this.planName,
    amount: amount ?? this.amount,
    startDate: startDate ?? this.startDate,
    expiryDate: expiryDate ?? this.expiryDate,
    status: status ?? this.status,
    paymentType: paymentType ?? this.paymentType,
    paymentMode: paymentMode ?? this.paymentMode,
    paymentDate: paymentDate ?? this.paymentDate,
    transactionId: transactionId ?? this.transactionId,
    remarks: remarks ?? this.remarks,
  );

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      UserSubscriptionModel(
        subscriptionId: json["subscriptionId"],
        userId: json["userId"],
        userName: json["userName"],
        planId: json["planId"],
        planName: json["planName"],
        amount: json["amount"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        expiryDate: json["expiryDate"] == null
            ? null
            : DateTime.parse(json["expiryDate"]),
        status: json["status"],
        paymentType: json["paymentType"],
        paymentMode: json["paymentMode"],
        paymentDate: json["paymentDate"] == null
            ? null
            : DateTime.parse(json["paymentDate"]),
        transactionId: json["transactionId"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
    "subscriptionId": subscriptionId,
    "userId": userId,
    "userName": userName,
    "planId": planId,
    "planName": planName,
    "amount": amount,
    "startDate":
        "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "expiryDate":
        "${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
    "status": status,
    "paymentType": paymentType,
    "paymentMode": paymentMode,
    "paymentDate":
        "${paymentDate!.year.toString().padLeft(4, '0')}-${paymentDate!.month.toString().padLeft(2, '0')}-${paymentDate!.day.toString().padLeft(2, '0')}",
    "transactionId": transactionId,
    "remarks": remarks,
  };
}

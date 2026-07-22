// To parse this JSON data, do
//
//     final mySubscriptionModel = mySubscriptionModelFromJson(jsonString);

import 'dart:convert';

MySubscriptionModel mySubscriptionModelFromJson(String str) =>
    MySubscriptionModel.fromJson(json.decode(str));

String mySubscriptionModelToJson(MySubscriptionModel data) =>
    json.encode(data.toJson());

class MySubscriptionModel {
  String? subscriptionId;
  String? userId;
  dynamic planAmount;
  dynamic discountAmount;
  dynamic finalAmount;
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

  MySubscriptionModel({
    this.subscriptionId,
    this.userId,
    this.planAmount,
    this.discountAmount,
    this.finalAmount,
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

  MySubscriptionModel copyWith({
    String? subscriptionId,
    String? userId,
    dynamic planAmount,
    dynamic discountAmount,
    dynamic finalAmount,
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
  }) => MySubscriptionModel(
    subscriptionId: subscriptionId ?? this.subscriptionId,
    userId: userId ?? this.userId,
    planAmount: planAmount ?? this.planAmount,
    discountAmount: discountAmount ?? this.discountAmount,
    finalAmount: finalAmount ?? this.finalAmount,
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

  factory MySubscriptionModel.fromJson(Map<String, dynamic> json) =>
      MySubscriptionModel(
        subscriptionId: json["subscriptionId"],
        userId: json["userId"],
        planAmount: json["planAmount"],
        discountAmount: json["discountAmount"],
        finalAmount: json["finalAmount"],
        userName: json["userName"],
        planId: json["planId"],
        planName: json["planName"],
        amount: json["amount"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"].toString().trim()),
        expiryDate: json["expiryDate"] == null
            ? null
            : DateTime.parse(json["expiryDate"].toString().trim()),
        status: json["status"],
        paymentType: json["paymentType"],
        paymentMode: json["paymentMode"],
        paymentDate: json["paymentDate"] == null
            ? null
            : DateTime.parse(json["paymentDate"].toString().trim()),
        transactionId: json["transactionId"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
    "subscriptionId": subscriptionId,
    "userId": userId,
    "planAmount": planAmount,
    "discountAmount": discountAmount,
    "finalAmount": finalAmount,
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

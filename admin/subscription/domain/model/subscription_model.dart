// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromJson(jsonString);

import 'dart:convert';

SubscriptionModel subscriptionModelFromJson(String str) =>
    SubscriptionModel.fromJson(json.decode(str));

String subscriptionModelToJson(SubscriptionModel data) =>
    json.encode(data.toJson());

class SubscriptionModel {
  String? planId;
  String? planName;
  String? planType;
  int? durationDays;
  double? amount;
  String? description;
  bool? active;

  SubscriptionModel({
    this.planId,
    this.planName,
    this.planType,
    this.durationDays,
    this.amount,
    this.description,
    this.active,
  });

  SubscriptionModel copyWith({
    String? planId,
    String? planName,
    String? planType,
    int? durationDays,
    double? amount,
    String? description,
    bool? active,
  }) => SubscriptionModel(
    planId: planId ?? this.planId,
    planName: planName ?? this.planName,
    planType: planType ?? this.planType,
    durationDays: durationDays ?? this.durationDays,
    amount: amount ?? this.amount,
    description: description ?? this.description,
    active: active ?? this.active,
  );

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        planId: json["planId"],
        planName: json["planName"],
        planType: json["planType"],
        durationDays: json["durationDays"],
        amount: json["amount"],
        description: json["description"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
    "planId": planId,
    "planName": planName,
    "planType": planType,
    "durationDays": durationDays,
    "amount": amount,
    "description": description,
    "active": active,
  };
}

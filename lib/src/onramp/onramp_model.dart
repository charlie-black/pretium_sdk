

import 'dart:convert';

OnRampInitiateResponse onRampInitiateResponseFromJson(String str) => OnRampInitiateResponse.fromJson(json.decode(str));

String onRampInitiateResponseToJson(OnRampInitiateResponse data) => json.encode(data.toJson());

class OnRampInitiateResponse {
  int? code;
  String? message;
  Data? data;

  OnRampInitiateResponse({
    this.code,
    this.message,
    this.data,
  });

  factory OnRampInitiateResponse.fromJson(Map<String, dynamic> json) => OnRampInitiateResponse(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? status;
  String? transactionCode;
  String? message;

  Data({
    this.status,
    this.transactionCode,
    this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    transactionCode: json["transaction_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "transaction_code": transactionCode,
    "message": message,
  };
}

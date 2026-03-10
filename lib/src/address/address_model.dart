

import 'dart:convert';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  String? message;
  AddressData? data;

  AddressModel({
    this.message,
    this.data,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    message: json["message"],
    data: json["data"] == null ? null : AddressData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };
}

class AddressData {
  String? address;


  AddressData({
    this.address,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    address: json["address"],

  );

  Map<String, dynamic> toJson() => {
    "address": address,

  };
}

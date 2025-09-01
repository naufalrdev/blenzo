// To parse this JSON data, do
//
//     final getBrandModel = getBrandModelFromJson(jsonString);

import 'dart:convert';

GetBrandModel getBrandModelFromJson(String str) =>
    GetBrandModel.fromJson(json.decode(str));

String getBrandModelToJson(GetBrandModel data) => json.encode(data.toJson());

class GetBrandModel {
  String message;
  List<Brand> data;

  GetBrandModel({required this.message, required this.data});

  factory GetBrandModel.fromJson(Map<String, dynamic> json) => GetBrandModel(
    message: json["message"],
    data: List<Brand>.from(json["data"].map((x) => Brand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Brand {
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  Brand({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final addBrandModel = addBrandModelFromJson(jsonString);

import 'dart:convert';

AddBrandModel addBrandModelFromJson(String str) =>
    AddBrandModel.fromJson(json.decode(str));

String addBrandModelToJson(AddBrandModel data) => json.encode(data.toJson());

class AddBrandModel {
  String message;
  Data data;

  AddBrandModel({required this.message, required this.data});

  factory AddBrandModel.fromJson(Map<String, dynamic> json) => AddBrandModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  String name;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}

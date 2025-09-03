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
  int id;
  String name;
  String imageUrl;
  String imagePath;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": imageUrl,
    "image_path": imagePath,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

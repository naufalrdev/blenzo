// To parse this JSON data, do
//
//     final getBrandModel = getBrandModelFromJson(jsonString);

import 'dart:convert';

GetBrandModel getBrandModelFromJson(String str) =>
    GetBrandModel.fromJson(json.decode(str));

String getBrandModelToJson(GetBrandModel data) => json.encode(data.toJson());

class GetBrandModel {
  String message;
  List<BrandDetail> data;

  GetBrandModel({required this.message, required this.data});

  factory GetBrandModel.fromJson(Map<String, dynamic> json) => GetBrandModel(
    message: json["message"],
    data: List<BrandDetail>.from(
      json["data"].map((x) => BrandDetail.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BrandDetail {
  int id;
  String name;
  String? imageUrl;
  String? imagePath;

  BrandDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.imagePath,
  });

  factory BrandDetail.fromJson(Map<String, dynamic> json) => BrandDetail(
    id: json["id"],
    name: json["name"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": imageUrl,
    "image_path": imagePath,
  };
}

// To parse this JSON data, do
//
//     final getHistoryModel = getHistoryModelFromJson(jsonString);

import 'dart:convert';

GetHistoryModel getHistoryModelFromJson(String str) =>
    GetHistoryModel.fromJson(json.decode(str));

String getHistoryModelToJson(GetHistoryModel data) =>
    json.encode(data.toJson());

class GetHistoryModel {
  String message;
  List<History> data;

  GetHistoryModel({required this.message, required this.data});

  factory GetHistoryModel.fromJson(Map<String, dynamic> json) =>
      GetHistoryModel(
        message: json["message"],
        data: List<History>.from(json["data"].map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class History {
  int id;
  String total;
  DateTime createdAt;
  List<Kultum> items;

  History({
    required this.id,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["id"],
    total: json["total"],
    createdAt: DateTime.parse(json["created_at"]),
    items: List<Kultum>.from(json["items"].map((x) => Kultum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total": total,
    "created_at": createdAt.toIso8601String(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Kultum {
  Goods product;
  String quantity;
  bool hasReviewed;

  Kultum({
    required this.product,
    required this.quantity,
    required this.hasReviewed,
  });

  factory Kultum.fromJson(Map<String, dynamic> json) => Kultum(
    product: Goods.fromJson(json["product"]),
    quantity: json["quantity"],
    hasReviewed: json["has_reviewed"],
  );

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "quantity": quantity,
    "has_reviewed": hasReviewed,
  };
}

class Goods {
  int id;
  String name;
  String price;
  List<String> imageUrls;

  Goods({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrls,
  });

  factory Goods.fromJson(Map<String, dynamic> json) => Goods(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "image_urls": List<dynamic>.from(imageUrls.map((x) => x)),
  };
}

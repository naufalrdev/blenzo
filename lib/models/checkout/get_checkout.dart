// // To parse this JSON data, do
// //
// //     final getCheckoutModel = getCheckoutModelFromJson(jsonString);

// import 'dart:convert';

// GetCheckoutModel getCheckoutModelFromJson(String str) =>
//     GetCheckoutModel.fromJson(json.decode(str));

// String getCheckoutModelToJson(GetCheckoutModel data) =>
//     json.encode(data.toJson());

// class GetCheckoutModel {
//   String message;
//   List<GetCheckout> data;

//   GetCheckoutModel({required this.message, required this.data});

//   factory GetCheckoutModel.fromJson(Map<String, dynamic> json) =>
//       GetCheckoutModel(
//         message: json["message"],
//         data: List<GetCheckout>.from(
//           json["data"].map((x) => GetCheckout.fromJson(x)),
//         ),
//       );

//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }

// class GetCheckout {
//   int id;
//   String total;
//   DateTime createdAt;
//   List<Stuff> items;

//   GetCheckout({
//     required this.id,
//     required this.total,
//     required this.createdAt,
//     required this.items,
//   });

//   factory GetCheckout.fromJson(Map<String, dynamic> json) => GetCheckout(
//     id: json["id"],
//     total: json["total"],
//     createdAt: DateTime.parse(json["created_at"]),
//     items: List<Stuff>.from(json["items"].map((x) => Stuff.fromJson(x))),
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "total": total,
//     "created_at": createdAt.toIso8601String(),
//     "items": List<dynamic>.from(items.map((x) => x.toJson())),
//   };
// }

// class Stuff {
//   Commodity product;
//   String quantity;
//   bool hasReviewed;

//   Stuff({
//     required this.product,
//     required this.quantity,
//     required this.hasReviewed,
//   });

//   factory Stuff.fromJson(Map<String, dynamic> json) => Stuff(
//     product: Commodity.fromJson(json["product"]),
//     quantity: json["quantity"],
//     hasReviewed: json["has_reviewed"],
//   );

//   Map<String, dynamic> toJson() => {
//     "product": product.toJson(),
//     "quantity": quantity,
//     "has_reviewed": hasReviewed,
//   };
// }

// class Commodity {
//   int id;
//   String name;
//   String price;

//   Commodity({required this.id, required this.name, required this.price});

//   factory Commodity.fromJson(Map<String, dynamic> json) =>
//       Commodity(id: json["id"], name: json["name"], price: json["price"]);

//   Map<String, dynamic> toJson() => {"id": id, "name": name, "price": price};
// }

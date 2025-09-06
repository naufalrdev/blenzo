import 'dart:convert';

import 'package:blenzo/models/cart/add_cart.dart';
import 'package:blenzo/models/cart/get_cart.dart';
import 'package:blenzo/services/api/endpoint/api_endpoint.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:http/http.dart' as http;

class AuthenticationApiCart {
  static Future<AddCartModel> addCart({
    required int productId,
    required int quantity,
  }) async {
    final url = Uri.parse(Endpoint.cart);
    final token = await PreferenceHandler.getToken();
    final response = await http.post(
      url,
      body: jsonEncode({"product_id": productId, "quantity": quantity}),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return AddCartModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to add new cart");
    }
  }

  static Future<GetCartModel> getCart() async {
    final url = Uri.parse(Endpoint.cart);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetCartModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Get data is not valid");
    }
  }
}

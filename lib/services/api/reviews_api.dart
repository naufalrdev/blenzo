import 'dart:convert';

import 'package:blenzo/models/review/add_review.dart';
import 'package:blenzo/services/api/endpoint/api_endpoint.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:http/http.dart' as http;

class AuthenticationApiReviews {
  static Future<AddReviewModel> addReviews({
    required int productId,
    required int transactionId,
    required int rating,
    required String review,
  }) async {
    final url = Uri.parse(Endpoint.reviews);
    final token = await PreferenceHandler.getToken();
    final response = await http.post(
      url,
      body: jsonEncode({
        "product_id": productId,
        "transaction_id": transactionId,
        "rating": rating,
        "review": review,
      }),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return AddReviewModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to add new review");
    }
  }
}

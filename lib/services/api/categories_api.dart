import 'dart:convert';

import 'package:blenzo/models/categories/add_categories.dart';
import 'package:blenzo/models/categories/get_categories.dart';
import 'package:blenzo/services/api/endpoint/api_endpoint.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:http/http.dart' as http;

class AuthenticationApiCat {
  static Future<AddCategoriesModel> addCategories({
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.categories);
    final token = await PreferenceHandler.getToken();
    final response = await http.post(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return AddCategoriesModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to add new categories");
    }
  }

  static Future<GetCatModel> updateCategories({required String name}) async {
    final url = Uri.parse(Endpoint.categories);
    final token = await PreferenceHandler.getToken();
    final response = await http.put(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetCatModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Data is not valid");
    }
  }

  static Future<GetCatModel> getCategories() async {
    final url = Uri.parse(Endpoint.categories);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetCatModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Get data is not valid");
    }
  }
}

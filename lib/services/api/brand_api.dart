import 'dart:convert';
import 'dart:io';

import 'package:blenzo/models/brand/add_brand.dart';
import 'package:blenzo/models/brand/get_brand.dart';
import 'package:blenzo/services/api/endpoint/api_endpoint.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:http/http.dart' as http;

class AuthenticationApiBrand {
  static Future<AddBrandModel> addBrand({
    required String name,
    required File image,
  }) async {
    final url = Uri.parse(Endpoint.brands);
    final token = await PreferenceHandler.getToken();
    final readImage = image.readAsBytesSync();
    final b64 = base64Encode(readImage);
    final response = await http.post(
      url,
      body: {"name": name, "image": b64},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(image);
    print(readImage);
    print(b64);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return AddBrandModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to add new brand");
    }
  }

  static Future<GetBrandModel> updateBrand({required String name}) async {
    final url = Uri.parse(Endpoint.brands);
    final token = await PreferenceHandler.getToken();
    final response = await http.put(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetBrandModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Data is not valid");
    }
  }

  static Future<GetBrandModel> getBrand() async {
    final url = Uri.parse(Endpoint.brands);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetBrandModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Get data is not valid");
    }
  }
}

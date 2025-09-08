import 'dart:convert';
import 'dart:io';

import 'package:blenzo/models/brand/add_brand.dart';
import 'package:blenzo/models/brand/get_brand.dart';
import 'package:blenzo/models/delete_model.dart';

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

    //baca file -> bytes -> base64
    final readImage = image.readAsBytesSync();
    final b64 = base64Encode(readImage);

    //tambahkan prefix
    final imageWithPrefix = "data:image/png;base64,$b64";

    final response = await http.post(
      url,
      body: jsonEncode({"name": name, "image_base64": imageWithPrefix}),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      return AddBrandModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to add new brand");
    }
  }

  static Future<AddBrandModel> updateBrand({
    required int id,
    required String name,
    File? image,
  }) async {
    final url = Uri.parse("${Endpoint.brands}/$id");
    final token = await PreferenceHandler.getToken();

    String? imageWithPrefix;
    if (image != null) {
      final readImage = await image.readAsBytes();
      final b64 = base64Encode(readImage);
      imageWithPrefix = "data:image/png;base64,$b64";
    }
    final response = await http.put(
      url,
      body: jsonEncode({
        "name": name,
        if (imageWithPrefix != null) "image_base64": imageWithPrefix,
      }),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return AddBrandModel.fromJson(json.decode(response.body));
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

  static Future<DeleteModel> deleteBrand({required int brandsId}) async {
    final url = Uri.parse("${Endpoint.brands}/$brandsId");
    final token = await PreferenceHandler.getToken();

    final response = await http.delete(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return DeleteModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to delete brands");
    }
  }
}

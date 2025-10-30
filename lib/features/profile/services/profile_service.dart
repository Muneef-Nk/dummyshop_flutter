import 'dart:convert';
import 'package:dummyjson/core/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:dummyjson/core/storage/local_storaged.dart';
import '../models/user_model.dart';

class ProfileService {
  Future<UserModel> fetchUserProfile() async {
    final token = LocalStorage.getToken();

    if (token == null) {
      throw Exception('Access token not found. Please login again.');
    }

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.userDetails}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    }
  }
}

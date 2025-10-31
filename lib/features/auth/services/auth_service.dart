import 'dart:convert';

import 'package:dummyjson/core/storage/local_storaged.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/app_constants.dart';

class AuthService {
  final _api = ApiClient();

  Future<String?> login(String username, String password) async {
    final response = await _api.post(AppConstants.login, {
      'username': username,
      'password': password,
      'expiresInMins': 30,
    }, auth: false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['accessToken'];

      if (accessToken != null) {
        await LocalStorage.saveToken(accessToken);
        return accessToken;
      }
      return null;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }
}

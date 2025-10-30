import 'dart:convert';
import 'package:dummyjson/core/storage/local_storaged.dart';
import 'package:http/http.dart' as http;
import '../utils/app_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final _client = http.Client();

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
    final headers = {'Content-Type': 'application/json'};

    if (auth) {
      final token = LocalStorage.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    return await _client.post(uri, body: jsonEncode(body), headers: headers);
  }

  Future<http.Response> get(String endpoint, {bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};

    if (auth) {
      final token = LocalStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
    return await _client.get(url, headers: headers);
  }
}

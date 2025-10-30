import 'package:dummyjson/core/storage/local_storaged.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _authService.login(username, password);
      if (token != null) {
        await LocalStorage.saveToken(token);
        _user = await _authService.getUserProfile();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    final token = LocalStorage.getToken();
    if (token != null) {
      try {
        _user = await _authService.getUserProfile();
      } catch (_) {
        await LocalStorage.clear();
      }
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await LocalStorage.clear();
    notifyListeners();
  }
}

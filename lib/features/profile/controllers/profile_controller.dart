import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';
import 'package:dummyjson/core/storage/local_storaged.dart';

class ProfileController with ChangeNotifier {
  final _service = ProfileService();

  UserModel? _user;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchProfile() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _service.fetchUserProfile();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await LocalStorage.clear();
    _user = null;
    notifyListeners();
  }
}

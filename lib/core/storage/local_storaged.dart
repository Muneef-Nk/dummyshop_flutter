import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);
  }

  static String? getToken() {
    return _prefs.getString('token');
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  static Future<void> saveList(String key, List<String> values) async {
    await _prefs.setStringList(key, values);
  }

  static List<String> getList(String key) {
    return _prefs.getStringList(key) ?? [];
  }
}

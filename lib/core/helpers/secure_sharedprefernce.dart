import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  late SharedPreferences _prefs;
  static const String _tokenKey = 'token';

  SharedPreferencesHelper({SharedPreferences? sharedPreferences});

  Future<void> init({SharedPreferences? sharedPreferences}) async {
    _prefs = sharedPreferences ?? await SharedPreferences.getInstance();
  }

  Future<bool> setToken(String token) async {
    return await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }
}

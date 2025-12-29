import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPreferences;

  init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) {
    return _sharedPreferences!.setString(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _sharedPreferences!.getString(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) {
    return _sharedPreferences!.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _sharedPreferences!.getInt(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) {
    return _sharedPreferences!.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _sharedPreferences!.getBool(key) ?? defaultValue;
  }

  Future<bool> remove(String key) {
    return _sharedPreferences!.remove(key);
  }
}

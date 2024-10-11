import "package:shared_preferences/shared_preferences.dart";

typedef StringList = List<String>;

class AppPrefs {
  static final AppPrefs _instance = AppPrefs._internal();
  static SharedPreferences? _prefs;

  AppPrefs._internal();

  factory AppPrefs() {
    return _instance;
  }

  // Initialize SharedPreferences
  Future<void> initSharedPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future setValue({required String key, var value}) async {
    _prefs ??= await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case String:
        _prefs?.setString(key, value);
        break;
      case int:
        _prefs?.setInt(key, value);
        break;
      case bool:
        _prefs?.setBool(key, value);
        break;
      case double:
        _prefs?.setDouble(key, value);
        break;
      case StringList:
        _prefs?.setStringList(key, value);
        break;
    }
  }

  static getValue({required String key}) {
    return _prefs?.get(key);
  }

  static getBool({required String key}) {
    return _prefs?.getBool(key);
  }

  static getInt({required String key}) {
    return _prefs?.getInt(key);
  }

  static getDouble({required String key}) {
    return _prefs?.getDouble(key);
  }

  ///Clear the shared preferences
  static clear() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.clear();
  }

  ///Remove the key value pair
  static removeKey({required String key}) async {
    _prefs ??= await SharedPreferences.getInstance();
    if (_prefs?.containsKey(key) == true) {
      _prefs?.remove(key);
    }
  }

  Future<bool> containsKey({required String key}) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.containsKey(key) == true;
  }
}

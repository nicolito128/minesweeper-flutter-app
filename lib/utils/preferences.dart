import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get theme => _prefs.getString('theme') ?? 'classic';
  static set theme(String value) => _prefs.setString('theme', value);

  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}

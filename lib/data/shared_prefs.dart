import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences pref;

  static Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  static bool? getBool({required String key}) {
    return pref.getBool(key);
  }

  static Future<void> setBool({required String key, required bool value}) async {
    await pref.setBool(key, value);
  }
}

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? prefs;

  static ValueNotifier<bool> themeNotifier = ValueNotifier(false);

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    themeNotifier.value = prefs?.getBool('isDarkTheme') ?? false;
  }

  static void toggleTheme() {
    themeNotifier.value = !themeNotifier.value;
    prefs?.setBool('isDarkTheme', themeNotifier.value);
  }

  static bool getFirstTime() {
    return prefs?.getBool('isFirstTime') ?? true;
  }

  static void setFirstTime(bool value) {
    prefs?.setBool('isFirstTime', value);
  }
}

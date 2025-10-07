import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferencesService extends GetxService {
  static const _keyThemeMode = 'theme_mode';

  static ThemePreferencesService get to =>
      Get.find<ThemePreferencesService>();

  late SharedPreferences _prefs;

  Future<ThemePreferencesService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? getThemeMode() {
    return _prefs.getString(_keyThemeMode);
  }

  Future<void> saveThemeMode(String value) async {
    await _prefs.setString(_keyThemeMode, value);
  }
}

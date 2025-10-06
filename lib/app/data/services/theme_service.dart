/*
  هذا الملف يقدّم خدمة تفضيلات الثيم لحفظ وضع الإضاءة في SharedPreferences.
  يمكن توسيعه لتخزين تفضيلات أخرى مثل حجم الخط أو لغة النظام.
*/
import 'package:get/get.dart';

import 'storage_service.dart';

class ThemePreferencesService extends GetxService {
  static ThemePreferencesService get to => Get.find<ThemePreferencesService>();

  Future<void> saveThemeMode(String mode) async {
    final settings = StorageService.to.getSettings();
    settings['theme_mode'] = mode;
    await StorageService.to.saveSettings(settings);
  }

  String? getThemeMode() {
    final settings = StorageService.to.getSettings();
    return settings['theme_mode'] as String?;
  }
}

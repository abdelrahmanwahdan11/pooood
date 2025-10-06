/*
  هذا الملف يربط متحكم الإعدادات لتحميل التفضيلات عند فتح الصفحة.
  يمكن توسعته لإضافة خدمات أمنية أو مراقبة تحليلات.
*/
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}

/*
  هذا الملف يربط متحكم المصادقة ضمن نظام الربط الخاص بـGetX.
  يمكن إضافة خدمات مرتبطة بالمصادقة هنا مثل تتبع الجلسات أو تحليلات الدخول.
*/
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

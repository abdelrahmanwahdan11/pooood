/*
  هذا الملف يربط متحكم شاشة البداية ضمن نظام الربط في GetX.
  يمكن إضافة خدمات أو متحكمات إضافية هنا إذا احتاجت شاشة البداية لذلك.
*/
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

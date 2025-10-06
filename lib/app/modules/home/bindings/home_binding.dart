/*
  هذا الملف يربط متحكم الشاشة الرئيسية والخدمات التابعة ضمن نظام GetX.
  يمكن توسعته لإضافة متحكمات إضافية مثل التصفح أو التحليلات.
*/
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

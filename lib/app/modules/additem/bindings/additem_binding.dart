/*
  هذا الملف يربط متحكم إضافة عنصر لتجهيز النماذج قبل العرض.
  يمكن لاحقاً دمج خدمات الرفع أو معالجة الصور ضمن هذا الربط.
*/
import 'package:get/get.dart';

import '../controllers/additem_controller.dart';

class AdditemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdditemController>(() => AdditemController());
  }
}

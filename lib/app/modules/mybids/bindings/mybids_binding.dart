/*
  هذا الملف يربط متحكم مزايداتي لتجهيز البيانات قبل الدخول إلى الشاشة.
  يمكن تطويره لحقن خدمات التنبيهات أو السجلات المحاسبية.
*/
import 'package:get/get.dart';

import '../controllers/mybids_controller.dart';

class MybidsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MybidsController>(() => MybidsController());
  }
}

/*
  هذا الملف يربط متحكم التفاصيل مع الصفحة لتهيئة البيانات قبل العرض.
  يمكن تعديله لحقن خدمات إضافية مثل إدارة المراجعات أو سجل العطاءات.
*/
import 'package:get/get.dart';

import '../../../data/models/item_model.dart';
import '../controllers/details_controller.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    final item = Get.arguments as ItemModel?;
    if (item != null) {
      Get.lazyPut<DetailsController>(() => DetailsController(item: item), tag: item.id);
    }
  }
}

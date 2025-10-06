/*
  هذا الملف يربط متحكم المفضلة لضمان تهيئة البيانات قبل عرض الصفحة.
  يمكن توسيعه لحقن خدمات تنبيهات أو مزامنة مستقبلية.
*/
import 'package:get/get.dart';

import '../controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}

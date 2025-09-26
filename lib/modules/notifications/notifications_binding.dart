import 'package:get/get.dart';

import '../../data/repositories/notifications_repo.dart';
import 'notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationsController>()) {
      Get.put(NotificationsController(Get.find<NotificationsRepository>()));
    }
  }
}

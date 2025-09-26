import 'package:get/get.dart';

import '../../services/notifications_service.dart';

class NotificationsController extends GetxController {
  NotificationsService get service => Get.find<NotificationsService>();

  void markAsRead(String id) {
    service.markAsRead(id);
  }
}

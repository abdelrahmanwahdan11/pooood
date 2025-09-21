import 'package:get/get.dart';

import '../../data/repositories/product_repo.dart';
import '../../services/notification_service.dart';
import 'alerts_controller.dart';

class AlertsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlertsController>(() => AlertsController(Get.find<NotificationService>(), Get.find<ProductRepository>()));
  }
}

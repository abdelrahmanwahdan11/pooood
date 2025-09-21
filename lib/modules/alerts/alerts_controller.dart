import 'package:get/get.dart';

import '../../data/models/product.dart';
import '../../data/models/user_alert.dart';
import '../../data/repositories/product_repo.dart';
import '../../services/notification_service.dart';

class AlertsController extends GetxController {
  AlertsController(this.notificationService, this.productRepository);

  final NotificationService notificationService;
  final ProductRepository productRepository;

  final alerts = <UserAlert>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    alerts.assignAll(notificationService.getAlerts());
  }

  void toggleAlert(UserAlert alert) {
    final updated = UserAlert(
      id: alert.id,
      productId: alert.productId,
      targetPrice: alert.targetPrice,
      isActive: !alert.isActive,
    );
    notificationService.upsertAlert(updated);
    load();
  }

  void removeAlert(String id) {
    notificationService.removeAlert(id);
    load();
  }

  Future<Product?> productFor(UserAlert alert) => productRepository.getProductById(alert.productId);
}

import 'package:get/get.dart';

import '../../data/datasources/local/get_storage_ds.dart';
import '../../services/notification_service.dart';
import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(Get.find<GetStorageDataSource>(), Get.find<NotificationService>()));
  }
}

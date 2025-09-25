import 'package:get/get.dart';

import '../../data/repositories/app_repository_binding.dart';
import '../../services/location_service.dart';
import '../../services/notifications_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    AppRepositoryBinding().dependencies();
    Get.put<LocationService>(LocationService(), permanent: true);
    Get.put<NotificationsService>(NotificationsService(), permanent: true);
  }
}

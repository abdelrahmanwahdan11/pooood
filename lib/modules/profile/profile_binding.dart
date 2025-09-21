import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(
          storage: Get.find<GetStorage>(),
          locationService: Get.find<LocationService>(),
          notificationService: Get.find<NotificationService>(),
        ));
  }
}

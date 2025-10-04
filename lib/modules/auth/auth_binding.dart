import 'package:get/get.dart';

import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';
import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final settings = Get.find<SettingsRepository>();
    if (!Get.isRegistered<WatchStoreRepository>()) {
      Get.lazyPut(() => WatchStoreRepository(settings));
    }
    Get.put(AuthController(settings, Get.find<WatchStoreRepository>()));
  }
}

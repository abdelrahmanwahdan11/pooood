import 'package:get/get.dart';

import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';
import 'onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    final settings = Get.find<SettingsRepository>();
    if (!Get.isRegistered<WatchStoreRepository>()) {
      Get.lazyPut(() => WatchStoreRepository(settings));
    }
    Get.put(OnboardingController(settings, Get.find<WatchStoreRepository>()));
  }
}

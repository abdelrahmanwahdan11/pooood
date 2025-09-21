import 'package:get/get.dart';

import '../../data/datasources/local/get_storage_ds.dart';
import 'onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController(Get.find<GetStorageDataSource>()));
  }
}

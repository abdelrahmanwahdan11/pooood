import 'package:get/get.dart';

import 'services/locale_service.dart';

/// Global bindings for the application, providing long-lived services.
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LocaleService>()) {
      Get.put<LocaleService>(LocaleService(), permanent: true);
    }
  }
}

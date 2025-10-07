import 'package:get/get.dart';

import '../../../core/services/settings_service.dart';

class ProfileController extends GetxController {
  final SettingsService _settings = Get.find<SettingsService>();

  late final RxString displayName;
  late final RxString email;

  @override
  void onInit() {
    super.onInit();
    displayName = _settings.displayNameRx;
    email = _settings.emailRx;
  }

  Future<void> updateProfile({required String name, required String email}) async {
    await _settings.updateDisplayName(name.trim());
    await _settings.updateEmail(email.trim());
  }
}

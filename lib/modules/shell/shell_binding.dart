import 'package:get/get.dart';

import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';
import '../auth/auth_controller.dart';
import '../favorites/favorites_controller.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';
import 'shell_controller.dart';

class ShellBinding extends Bindings {
  ShellBinding({this.settingsRepository});

  final SettingsRepository? settingsRepository;

  @override
  void dependencies() {
    if (settingsRepository != null && !Get.isRegistered<SettingsRepository>()) {
      Get.put<SettingsRepository>(settingsRepository!, permanent: true);
    }
    final settings = Get.find<SettingsRepository>();
    if (!Get.isRegistered<WatchStoreRepository>()) {
      Get.put(WatchStoreRepository(settings), permanent: true);
    }
    final store = Get.find<WatchStoreRepository>();
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(settings, store), permanent: true);
    }
    Get.put(ShellController(settings), permanent: true);
    Get.put(HomeController(store, settings), permanent: true);
    Get.put(FavoritesController(store, settings), permanent: true);
    Get.put(ProfileController(settings, store), permanent: true);
  }
}

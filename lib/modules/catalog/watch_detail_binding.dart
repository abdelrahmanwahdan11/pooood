import 'package:get/get.dart';

import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';
import 'watch_detail_controller.dart';

class WatchDetailBinding extends Bindings {
  @override
  void dependencies() {
    final settings = Get.find<SettingsRepository>();
    final repo = Get.find<WatchStoreRepository>();
    Get.put(WatchDetailController(repo, settings));
  }
}

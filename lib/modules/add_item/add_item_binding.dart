import 'package:get/get.dart';

import '../../data/db/app_db.dart';
import '../../data/repositories/settings_repo.dart';
import 'add_item_controller.dart';

class AddItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddItemController(Get.find<AppDatabase>(), Get.find<SettingsRepository>()));
  }
}

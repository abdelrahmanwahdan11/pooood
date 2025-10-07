import 'package:get/get.dart';

import '../../data/repositories/insights_repository.dart';
import 'controllers/insights_controller.dart';

class InsightsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsightsController>(() => InsightsController(Get.find<InsightsRepository>()));
  }
}

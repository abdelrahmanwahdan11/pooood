import 'package:get/get.dart';

import '../../core/services/feature_service.dart';
import 'controllers/features_controller.dart';

class FeaturesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeaturesController>(() => FeaturesController(Get.find<FeatureService>()));
  }
}

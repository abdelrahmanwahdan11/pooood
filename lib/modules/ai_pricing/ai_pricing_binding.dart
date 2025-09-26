import 'package:get/get.dart';

import 'ai_pricing_controller.dart';

class AiPricingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiPricingController>(() => AiPricingController());
  }
}

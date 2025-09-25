import 'package:get/get.dart';

import 'discounts_nearby_controller.dart';

class DiscountsNearbyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiscountsNearbyController>(() => DiscountsNearbyController());
  }
}

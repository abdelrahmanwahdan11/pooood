import 'package:get/get.dart';

import 'trust_controller.dart';

class TrustBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(TrustController.new);
  }
}

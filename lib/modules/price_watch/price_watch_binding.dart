import 'package:get/get.dart';

import 'price_watch_controller.dart';

class PriceWatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PriceWatchController>(() => PriceWatchController());
  }
}

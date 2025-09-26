import 'package:get/get.dart';

import '../../data/repositories/auctions_repo.dart';
import '../../data/repositories/discounts_repo.dart';
import 'my_activity_controller.dart';

class MyActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyActivityController(
      Get.find<AuctionsRepository>(),
      Get.find<DiscountsRepository>(),
    ));
  }
}

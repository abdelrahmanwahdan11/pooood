import 'package:get/get.dart';

import 'home_auction_controller.dart';

class HomeAuctionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeAuctionController>(() => HomeAuctionController());
  }
}

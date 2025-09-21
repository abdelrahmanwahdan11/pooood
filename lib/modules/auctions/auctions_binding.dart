import 'package:get/get.dart';

import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/product_repo.dart';
import 'auctions_controller.dart';

class AuctionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuctionsController>(() => AuctionsController(Get.find<AuctionRepository>(), Get.find<ProductRepository>()));
  }
}

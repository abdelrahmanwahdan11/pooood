import 'package:get/get.dart';

import '../../data/repositories/auction_repo.dart';
import '../../services/location_service.dart';
import 'deals_controller.dart';

class DealsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DealsController>(() => DealsController(Get.find<AuctionRepository>(), Get.find<LocationService>()));
  }
}

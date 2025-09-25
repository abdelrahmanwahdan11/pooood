import 'package:get/get.dart';

import '../../data/models/auction.dart';
import '../../data/models/discount_deal.dart';
import '../../data/repositories/auction_repository.dart';
import '../../data/repositories/discount_repository.dart';

class MyActivityController extends GetxController {
  late final List<Auction> bids;
  late final List<DiscountDeal> discounts;

  @override
  void onInit() {
    super.onInit();
    bids = Get.find<AuctionRepository>().getAuctions();
    discounts = Get.find<DiscountRepository>().getDeals();
  }
}

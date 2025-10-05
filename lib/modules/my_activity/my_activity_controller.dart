import 'package:get/get.dart';

import '../../data/models/auction.dart';
import '../../data/models/discount_deal.dart';
import '../../data/models/product.dart';
import '../../data/repositories/auctions_repo.dart';
import '../../data/repositories/discounts_repo.dart';

class MyActivityController extends GetxController {
  MyActivityController(this.auctionsRepository, this.discountsRepository);

  final AuctionsRepository auctionsRepository;
  final DiscountsRepository discountsRepository;

  final RxList<Auction> myAuctions = RxList<Auction>([]);
  final RxMap<int, Product> products = RxMap<int, Product>({});
  final RxList<DiscountDeal> myDiscounts = RxList<DiscountDeal>([]);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final auctions = await auctionsRepository.fetchAuctions();
    myAuctions.assignAll(auctions..sort((a, b) => a.endTime.compareTo(b.endTime)));
    final productMap = await auctionsRepository
        .fetchProductsForAuctions(auctions.map((e) => e.productId));
    products.assignAll(productMap);
    final discounts = await discountsRepository.fetchDiscounts();
    myDiscounts.assignAll(discounts
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm)));
  }
}

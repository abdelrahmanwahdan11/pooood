import 'package:get/get.dart';

import '../../data/models/auction.dart';
import '../../data/models/discount_deal.dart';
import '../../data/models/product.dart';
import '../../data/repositories/auctions_repo.dart';
import '../../data/repositories/discounts_repo.dart';
import '../../data/repositories/settings_repo.dart';

enum ExploreFilter { auctions, discounts, both }

class ExploreController extends GetxController {
  ExploreController(this.auctionsRepository, this.discountsRepository,
      this.settingsRepository);

  final AuctionsRepository auctionsRepository;
  final DiscountsRepository discountsRepository;
  final SettingsRepository settingsRepository;

  final RxList<Auction> auctions = RxList<Auction>([]);
  final RxMap<int, Product> products = RxMap<int, Product>({});
  final RxList<DiscountDeal> discounts = RxList<DiscountDeal>([]);
  final Rx<ExploreFilter> filterType = Rx<ExploreFilter>(ExploreFilter.both);
  final RxDouble distanceLimit = RxDouble(30.0);
  final RxString selectedCategory = RxString('');

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final auctionList = await auctionsRepository.fetchAuctions();
    auctions.assignAll(auctionList);
    final productMap = await auctionsRepository
        .fetchProductsForAuctions(auctionList.map((a) => a.productId));
    products.assignAll(productMap);
    discounts.assignAll(await discountsRepository.fetchDiscounts());
  }

  List<Auction> get nearAuctions => auctions
      .where((a) => a.distanceKm <= distanceLimit.value)
      .toList()
    ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

  List<Auction> get endingSoon => List<Auction>.from(auctions)
    ..sort((a, b) => a.endTime.compareTo(b.endTime));

  List<DiscountDeal> get hotDiscounts => discounts
      .where((d) => d.discountPercent >= 25)
      .toList()
    ..sort((a, b) => b.discountPercent.compareTo(a.discountPercent));

  List<dynamic> filteredItems() {
    final List<dynamic> items = [];
    if (filterType.value == ExploreFilter.auctions ||
        filterType.value == ExploreFilter.both) {
      items.addAll(nearAuctions);
    }
    if (filterType.value == ExploreFilter.discounts ||
        filterType.value == ExploreFilter.both) {
      items.addAll(discounts
          .where((d) => d.distanceKm <= distanceLimit.value)
          .toList());
    }
    if (selectedCategory.value.isNotEmpty) {
      items.retainWhere((item) {
        if (item is Auction) {
          final product = products[item.productId];
          return product?.category == selectedCategory.value;
        }
        if (item is DiscountDeal) {
          return item.category == selectedCategory.value;
        }
        return false;
      });
    }
    return items;
  }
}

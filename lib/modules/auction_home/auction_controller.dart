import 'package:get/get.dart';

import '../../core/utils/time.dart';
import '../../data/models/auction.dart';
import '../../data/models/product.dart';
import '../../data/repositories/auctions_repo.dart';
import '../../data/repositories/settings_repo.dart';

class AuctionController extends GetxController {
  AuctionController(this.auctionsRepository, this.settingsRepository);

  final AuctionsRepository auctionsRepository;
  final SettingsRepository settingsRepository;

  final RxList<Auction> auctions = RxList<Auction>([]);
  final RxMap<int, Product> products = RxMap<int, Product>({});
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadAuctions();
  }

  Future<void> loadAuctions() async {
    isLoading.value = true;
    final data = await auctionsRepository.fetchAuctions();
    auctions.assignAll(data);
    final productMap =
        await auctionsRepository.fetchProductsForAuctions(data.map((a) => a.productId));
    products.assignAll(productMap);
    isLoading.value = false;
  }

  Product? productFor(Auction auction) => products[auction.productId];

  Future<bool> placeBid(Auction auction, double amount) async {
    final minimum = auction.currentPrice + auction.minIncrement;
    if (amount < minimum) {
      return false;
    }
    await auctionsRepository.placeBid(auction.id, amount);
    await loadAuctions();
    return true;
  }

  Duration remainingFor(Auction auction) {
    return auction.endTime.difference(DateTime.now());
  }

  String countdownLabel(Auction auction) {
    final duration = remainingFor(auction);
    return TimeUtils.formatCountdown(duration);
  }

  Future<void> toggleFavorite(Auction auction) async {
    await auctionsRepository.toggleFavorite(auction.id, !auction.isFavorite);
    await loadAuctions();
  }
}

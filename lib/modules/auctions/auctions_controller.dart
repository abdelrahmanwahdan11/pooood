import 'package:get/get.dart';

import '../../data/models/auction.dart';
import '../../data/models/product.dart';
import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/product_repo.dart';

class AuctionsController extends GetxController {
  AuctionsController(this.auctionRepository, this.productRepository);

  final AuctionRepository auctionRepository;
  final ProductRepository productRepository;

  final auctions = <Auction>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final data = await auctionRepository.fetchAuctions();
    auctions.assignAll(data);
    isLoading.value = false;
  }

  Future<Auction?> findAuction(String id) async {
    if (auctions.isEmpty) {
      await load();
    }
    return auctions.firstWhereOrNull((element) => element.id == id);
  }

  Future<Product?> productForAuction(Auction auction) async {
    return productRepository.getProductById(auction.productId);
  }
}

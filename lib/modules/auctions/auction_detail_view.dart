import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/currency.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/gemini_info_button.dart';
import '../../core/widgets/gradient_glass_card.dart';
import '../../data/models/auction.dart';
import '../../data/models/bid.dart';
import '../../data/models/product.dart';
import '../../data/repositories/auction_repo.dart';
import '../../data/repositories/product_repo.dart';
import '../../services/auction_sync_service.dart';
import '../../services/auth_service.dart';

class AuctionDetailController extends GetxController {
  AuctionDetailController(
    this._auctionRepository,
    this._productRepository,
    this._auctionSyncService,
    this._authService,
  );

  final AuctionRepository _auctionRepository;
  final ProductRepository _productRepository;
  final AuctionSyncService _auctionSyncService;
  final AuthService _authService;

  final auction = Rxn<Auction>();
  final product = Rxn<Product>();
  final bids = <Bid>[].obs;
  final bidAmount = 0.0.obs;
  final isPlacingBid = false.obs;

  late final String auctionId;

  @override
  void onInit() {
    super.onInit();
    auctionId = Get.arguments as String? ?? Get.parameters['id'] ?? '';
    _loadAuction();
    _loadBids();
    _auctionSyncService.listenToAuction(auctionId, (updated) {
      if (updated != null) {
        auction.value = updated;
        bidAmount.value = updated.currentBid + updated.minIncrement;
      }
    });
  }

  Future<void> _loadAuction() async {
    final data = await _auctionRepository.fetchAuction(auctionId);
    if (data != null) {
      auction.value = data;
      bidAmount.value = data.currentBid + data.minIncrement;
      final productData =
          await _productRepository.fetchProduct(data.productId);
      if (productData != null) {
        product.value = productData;
      }
    }
  }

  Future<void> _loadBids() async {
    final data = await _auctionRepository.fetchBids(auctionId);
    bids.assignAll(data);
  }

  void adjustBid(bool increase) {
    final current = bidAmount.value;
    final minIncrement = auction.value?.minIncrement ?? 0;
    final base = auction.value?.currentBid ?? 0;
    final newAmount = increase
        ? current + minIncrement
        : (current - minIncrement).clamp(base + minIncrement, double.infinity);
    bidAmount.value = newAmount;
  }

  Future<void> placeBid() async {
    final user = _authService.firebaseUser.value;
    if (user == null) {
      Get.snackbar('login'.tr, 'no_account'.tr);
      return;
    }
    final currentAuction = auction.value;
    if (currentAuction == null) return;
    isPlacingBid.value = true;
    try {
      await _auctionSyncService.placeBid(
        auctionId,
        bidAmount.value,
        user.uid,
      );
      await _loadBids();
      Get.snackbar('place_bid'.tr, 'notify_success'.tr);
    } on Exception catch (e) {
      Get.snackbar('place_bid'.tr, e.toString());
    } finally {
      isPlacingBid.value = false;
    }
  }
}

class AuctionDetailView extends GetView<AuctionDetailController> {
  const AuctionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('auctions'.tr)),
      body: Obx(() {
        final auction = controller.auction.value;
        final product = controller.product.value;
        if (auction == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CachedNetworkImage(
                    imageUrl: product.images.isNotEmpty
                        ? product.images.first
                        : 'https://picsum.photos/500',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product?.title ?? 'loading'.tr,
                    style: Get.textTheme.headlineMedium,
                  ),
                  if (product != null) GeminiInfoButton(product: product),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                CurrencyFormatter.format(auction.currentBid),
                style: Get.textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              CountdownTimer(endTime: auction.endsAt),
              const SizedBox(height: 16),
              if (product != null)
                Text(product.description, style: Get.textTheme.bodyLarge),
              const SizedBox(height: 24),
              GradientGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('bid_amount'.tr, style: Get.textTheme.titleMedium),
                    Obx(
                      () => Text(
                        CurrencyFormatter.format(controller.bidAmount.value),
                        style: Get.textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => controller.adjustBid(false),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        IconButton(
                          onPressed: () => controller.adjustBid(true),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        const Spacer(),
                        Obx(
                          () => AppButton(
                            label: controller.isPlacingBid.value
                                ? 'loading'.tr
                                : 'submit_bid'.tr,
                            onPressed: controller.isPlacingBid.value
                                ? null
                                : controller.placeBid,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('bids'.tr, style: Get.textTheme.titleLarge),
              const SizedBox(height: 12),
              Obx(
                () => Column(
                  children: controller.bids
                      .map(
                        (bid) => ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(CurrencyFormatter.format(bid.amount)),
                          subtitle: Text(bid.placedAt.toLocal().toString()),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

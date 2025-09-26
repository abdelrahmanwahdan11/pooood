import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/utils/distance.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/network_image_safe.dart';
import '../../data/models/auction.dart';
import '../../data/models/product.dart';
import '../../data/repositories/settings_repo.dart';
import 'auction_controller.dart';

class AuctionHomeView extends StatefulWidget {
  const AuctionHomeView({super.key});

  @override
  State<AuctionHomeView> createState() => _AuctionHomeViewState();
}

class _AuctionHomeViewState extends State<AuctionHomeView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<AuctionController>();
  final settings = Get.find<SettingsRepository>();

  final pageController = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final padding = Responsive.adaptivePadding(context);
    return RefreshIndicator(
      onRefresh: controller.loadAuctions,
      child: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: controller.auctions.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final auction = controller.auctions[index];
                        final product = controller.productFor(auction);
                        if (product == null) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: padding / 2, vertical: padding / 3),
                          child: _AuctionCard(
                            auction: auction,
                            product: product,
                            onBid: (amount) async {
                              final success = await controller.placeBid(auction, amount);
                              if (success) {
                                Get.snackbar('app_name'.tr, 'bid_success'.tr);
                              } else {
                                Get.snackbar('app_name'.tr, 'invalid_number'.tr);
                              }
                            },
                            onFavorite: () => controller.toggleFavorite(auction),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  _PageIndicator(
                    controller: pageController,
                    itemCount: controller.auctions.length,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _AuctionCard extends StatelessWidget {
  const _AuctionCard({
    required this.auction,
    required this.product,
    required this.onBid,
    required this.onFavorite,
  });

  final Auction auction;
  final Product product;
  final ValueChanged<double> onBid;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsRepository>();
    final distanceLabel = DistanceUtils.formatDistance(
      auction.distanceKm,
      settings.distanceUnit,
    );
    final countdown = TimeUtils.formatCountdown(
      auction.endTime.difference(DateTime.now()),
    );

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: PageView(
              physics: const BouncingScrollPhysics(),
              children: product.images
                  .map((url) => NetworkImageSafe(
                        url: url,
                        fit: BoxFit.cover,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(product.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('${product.category} • ${product.condition}'),
          Text('${auction.sellerArea} • $distanceLabel'),
          const SizedBox(height: 12),
          Row(
            children: [
              Chip(
                label: Text('${'current_price'.tr}: ${auction.currentPrice.toStringAsFixed(0)}'),
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),
              const SizedBox(width: 8),
              Chip(
                label: Text('${'min_increment'.tr}: ${auction.minIncrement.toStringAsFixed(0)}'),
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),
              const Spacer(),
              Chip(label: Text('${'ending_in'.tr}: $countdown')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              AppBadge(
                count: auction.watchers,
                child: IconButton(
                  onPressed: onFavorite,
                  icon: Icon(
                    auction.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.snackbar('Share', product.title),
                icon: const Icon(Icons.share_outlined),
              ),
              IconButton(
                onPressed: () => Get.snackbar('Report', product.title),
                icon: const Icon(Icons.flag_outlined),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => _showBidDialog(context),
                child: Text('place_bid'.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBidDialog(BuildContext context) {
    final amountController = TextEditingController(
      text: (auction.currentPrice + auction.minIncrement).toStringAsFixed(0),
    );
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: GlassContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('place_bid'.tr,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'bid_amount'.tr),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('cancel'.tr),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        final value = double.tryParse(amountController.text);
                        if (value != null) {
                          Get.back();
                          onBid(value);
                        }
                      },
                      child: Text('confirm'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PageIndicator extends StatefulWidget {
  const _PageIndicator({
    required this.controller,
    required this.itemCount,
  });

  final PageController controller;
  final int itemCount;

  @override
  State<_PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<_PageIndicator> {
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    setState(() {
      currentPage = widget.controller.page ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.itemCount, (index) {
        final selected = (currentPage.round() == index);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: selected ? 32 : 12,
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFBD545)
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

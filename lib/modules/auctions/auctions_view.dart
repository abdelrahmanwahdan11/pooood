import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/gradient_card.dart';
import '../../core/widgets/shimmer_loader.dart';
import '../../data/models/auction.dart';
import 'auctions_controller.dart';

class AuctionsView extends StatefulWidget {
  const AuctionsView({super.key});

  @override
  State<AuctionsView> createState() => _AuctionsViewState();
}

class _AuctionsViewState extends State<AuctionsView>
    with AutomaticKeepAliveClientMixin {
  late final AuctionsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuctionsController>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: controller.refreshAuctions,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 200) {
            controller.loadMore();
          }
          return false;
        },
        child: Obx(() {
          if (controller.isLoading.value && controller.auctions.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: ShimmerLoader(height: 180),
              ),
            );
          }

          final items = controller.visibleAuctions;
          if (items.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Center(
                  child: Text(
                    'empty_state'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'retry'.tr,
                  onPressed: controller.fetchAuctions,
                ),
              ],
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final auction = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _AuctionCard(
                  auction: auction,
                  onTap: () {
                    Get.toNamed('${AppRoutes.auctionDetail}/${auction.id}');
                  },
                  ticker: controller.ticker,
                ),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _AuctionCard extends StatelessWidget {
  const _AuctionCard({
    required this.auction,
    required this.onTap,
    required this.ticker,
  });

  final Auction auction;
  final VoidCallback onTap;
  final Stream<DateTime> ticker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GradientCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 110,
                  width: 110,
                  child: CachedNetworkImage(
                    imageUrl: auction.images.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerLoader(
                      height: 110,
                      width: 110,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'auction_badge'.tr,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (auction.isActive)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      auction.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'current_bid'.tr,
                              style: theme.textTheme.labelLarge,
                            ),
                            Text(
                              CurrencyUtils.format(auction.currentBid),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('ends_in'.tr, style: theme.textTheme.labelLarge),
                            CountdownTimer(
                              endAt: auction.endAt,
                              ticker: ticker,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.black87,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.people_alt_outlined, color: Colors.black.withOpacity(0.6)),
              const SizedBox(width: 6),
              Text('${'bidders'.tr}: ${auction.biddersCount}'),
              const Spacer(),
              AppButton(
                label: 'bid_now'.tr,
                onPressed: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

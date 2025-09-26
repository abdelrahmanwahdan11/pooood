import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/distance.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/network_image_safe.dart';
import '../../data/models/auction.dart';
import '../../data/models/discount_deal.dart';
import '../../data/repositories/settings_repo.dart';
import 'my_activity_controller.dart';

class MyActivityView extends GetView<MyActivityController> {
  const MyActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.adaptivePadding(context);
    final settings = Get.find<SettingsRepository>();
    return Scaffold(
      appBar: AppBar(
        title: Text('my_bids'.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Obx(
          () => ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Text('my_bids'.tr, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...controller.myAuctions.map(
                (auction) => _ActivityAuctionCard(
                  auction: auction,
                  product: controller.products[auction.productId],
                  distanceUnit: settings.distanceUnit,
                ),
              ),
              const SizedBox(height: 24),
              Text('my_discounts'.tr,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...controller.myDiscounts.map(
                (deal) => _ActivityDiscountCard(
                  deal: deal,
                  distanceUnit: settings.distanceUnit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityAuctionCard extends StatelessWidget {
  const _ActivityAuctionCard({
    required this.auction,
    required this.product,
    required this.distanceUnit,
  });

  final Auction auction;
  final dynamic product;
  final DistanceUnit distanceUnit;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product != null)
            NetworkImageSafe(
              url: product.images.first,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 12),
          Text(product?.title ?? '',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('${'current_price'.tr}: ${auction.currentPrice.toStringAsFixed(0)}'),
          Text(
            '${'ending_in'.tr}: ${auction.endTime.difference(DateTime.now()).inHours}h',
          ),
          Text(
            '${'distance'.tr}: ${DistanceUtils.formatDistance(auction.distanceKm, distanceUnit)}',
          ),
        ],
      ),
    );
  }
}

class _ActivityDiscountCard extends StatelessWidget {
  const _ActivityDiscountCard({
    required this.deal,
    required this.distanceUnit,
  });

  final DiscountDeal deal;
  final DistanceUnit distanceUnit;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageSafe(
            url: deal.images.first,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          Text(deal.storeName, style: Theme.of(context).textTheme.titleMedium),
          Text('${deal.product} — ${deal.discountPercent.toStringAsFixed(0)}%'),
          Text(deal.location),
          Text(
            '${'distance'.tr}: ${DistanceUtils.formatDistance(deal.distanceKm, distanceUnit)}',
          ),
          Text('${'valid_until'.tr}: ${TimeUtils.formatDate(deal.validUntil)}'),
        ],
      ),
    );
  }
}

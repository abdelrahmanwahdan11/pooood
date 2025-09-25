import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/auction.dart';
import '../../../data/models/discount_deal.dart';
import 'glass_container.dart';

class MapPinBottomSheet extends StatelessWidget {
  const MapPinBottomSheet.auction({super.key, required Auction auctionItem})
      : auction = auctionItem,
        deal = null;
  const MapPinBottomSheet.deal({super.key, required DiscountDeal dealItem})
      : deal = dealItem,
        auction = null;

  final Auction? auction;
  final DiscountDeal? deal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = auction?.product.title ?? deal?.product.title ?? '';
    final subtitle = auction != null
        ? '${auction!.product.category} · ${auction!.product.condition}'
        : '${deal!.product.category} · ${deal!.storeName}';
    final actionLabel = auction != null ? 'current_bid'.tr : 'distance'.tr;
    final actionValue = auction != null
        ? '﷼${auction!.currentBid.toStringAsFixed(0)}'
        : '${deal!.distanceKm.toStringAsFixed(1)} كم';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(subtitle),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(actionLabel,
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text(actionValue),
              ],
            )
          ],
        ),
      ),
    );
  }
}

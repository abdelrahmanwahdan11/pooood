import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/auction.dart';
import 'countdown_chip.dart';
import 'glass_container.dart';
import 'network_image_safe.dart';
import 'price_tag.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({super.key, required this.auction, this.onTap, this.onViewMap});

  final Auction auction;
  final VoidCallback? onTap;
  final VoidCallback? onViewMap;

  @override
  Widget build(BuildContext context) {
    final product = auction.product;
    return GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: NetworkImageSafe(url: product.imageUrls.first),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              CountdownChip(duration: auction.timeLeft),
            ],
          ),
          const SizedBox(height: 8),
          Text('${product.category} · ${product.condition}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              PriceTag(amount: auction.currentBid, prefix: 'current_bid'.tr),
              const SizedBox(width: 12),
              Text('${'start_price'.tr}: ﷼${auction.startPrice.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.groups_rounded,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 6),
              Text('${auction.participants} ${'participants'.tr}'),
              const Spacer(),
              if (onViewMap != null)
                TextButton.icon(
                  onPressed: onViewMap,
                  icon: const Icon(Icons.map_rounded),
                  label: Text('view_on_map'.tr),
                ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/models/discount_deal.dart';
import 'glass_container.dart';
import 'network_image_safe.dart';

class DealCard extends StatelessWidget {
  const DealCard({super.key, required this.deal, this.onTap, this.onViewMap});

  final DiscountDeal deal;
  final VoidCallback? onTap;
  final VoidCallback? onViewMap;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '﷼');
    return GlassContainer(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 120,
              width: 120,
              child: NetworkImageSafe(url: deal.product.imageUrls.first, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal.product.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('${deal.product.category} · ${deal.storeName}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('-${deal.discountPercent.toStringAsFixed(0)}%'),
                    ),
                    const SizedBox(width: 8),
                    Text(formatter.format(deal.priceAfter)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('${'distance'.tr}: ${deal.distanceKm.toStringAsFixed(1)} كم'),
                const SizedBox(height: 4),
                Text('${'expires_in'.tr}: ${deal.expiresAt.difference(DateTime.now()).inHours}h'),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: onViewMap,
                    icon: const Icon(Icons.place_outlined),
                    label: Text('view_on_map'.tr),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

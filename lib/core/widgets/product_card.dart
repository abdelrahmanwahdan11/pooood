import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/product.dart';
import '../utils/currency_utils.dart';
import '../utils/formatters.dart';
import 'glass_container.dart';
import 'shimmer_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showTrend = false,
    this.showDeal = false,
    this.showAuction = false,
  });

  final Product product;
  final VoidCallback? onTap;
  final bool showTrend;
  final bool showDeal;
  final bool showAuction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badges = <String>[];
    if (showTrend) badges.add('trend_badge'.tr);
    if (showDeal) badges.add('deal_badge'.tr);
    if (showAuction) badges.add('auction_badge'.tr);

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: EdgeInsets.zero,
        style: const GlassContainerStyle(
          blur: 24,
          opacity: 0.15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: product.images.isNotEmpty
                          ? product.images.first
                          : 'https://images.unsplash.com/photo-1510552776732-03e61cf4b144',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerLoader(),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: badges
                          .map(
                            (badge) => Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                badge,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${product.brand} • ${product.rating.toStringAsFixed(1)}★',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    formatCurrency(
                      product.priceApprox,
                      locale: Get.locale?.languageCode ?? 'en',
                      currency: currentCurrency(),
                    ),
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

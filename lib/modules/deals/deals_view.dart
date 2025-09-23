import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/currency.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_glass_card.dart';
import '../../core/widgets/shimmer_loader.dart';
import 'deals_controller.dart';

class DealsView extends GetView<DealsController> {
  const DealsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (_, __) => const ShimmerLoader(height: 160),
          );
        }
        if (controller.deals.isEmpty) {
          return EmptyState(
            icon: Icons.local_offer_outlined,
            title: 'empty_deals'.tr,
            subtitle: 'deal_flash'.tr,
          );
        }
        return ListView.builder(
          itemCount: controller.deals.length,
          itemBuilder: (_, index) {
            final deal = controller.deals[index];
            final product = controller.productFor(deal);
            return GradientGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: product != null
                              ? CachedNetworkImage(
                                  imageUrl: product.images.isNotEmpty
                                      ? product.images.first
                                      : 'https://picsum.photos/400',
                                  fit: BoxFit.cover,
                                )
                              : const ShimmerLoader(height: 100, width: 100),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product?.title ?? 'loading'.tr,
                              style: Get.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${'discount'.tr}: ${deal.discountPct.toStringAsFixed(0)}%',
                              style: Get.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            CountdownTimer(endTime: deal.endsAt),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (product != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        '${CurrencyFormatter.format(product.basePrice)} → '
                        '${CurrencyFormatter.format(product.basePrice * (1 - deal.discountPct / 100))}',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

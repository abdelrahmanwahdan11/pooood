import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/currency.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gemini_info_button.dart';
import '../../core/widgets/gradient_glass_card.dart';
import '../../core/widgets/labeled_icon.dart';
import '../../core/widgets/shimmer_loader.dart';
import '../../core/widgets/story_button.dart';
import 'auctions_controller.dart';

class AuctionsView extends GetView<AuctionsController> {
  const AuctionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'search_placeholder'.tr,
            ),
            onChanged: controller.search,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (_, __) => const ShimmerLoader(height: 180),
                );
              }
              if (controller.filteredAuctions.isEmpty) {
                return EmptyState(
                  icon: Icons.gavel_outlined,
                  title: 'empty_auctions'.tr,
                  subtitle: 'pricing_hint'.tr,
                );
              }
              return ListView.builder(
                itemCount: controller.filteredAuctions.length,
                itemBuilder: (_, index) {
                  final auction = controller.filteredAuctions[index];
                  final product = controller.productFor(auction);
                  return GradientGlassCard(
                    onTap: () => controller.openAuction(auction),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                width: 110,
                                height: 110,
                                child: product != null
                                    ? CachedNetworkImage(
                                        imageUrl: product.images.isNotEmpty
                                            ? product.images.first
                                            : 'https://picsum.photos/300',
                                        fit: BoxFit.cover,
                                      )
                                    : const ShimmerLoader(height: 110, width: 110),
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
                                    CurrencyFormatter.format(auction.currentBid),
                                    style: Get.textTheme.headlineSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      LabeledIcon(
                                        icon: Icons.visibility,
                                        label: 'viewers'.tr,
                                        value: auction.watchersCount.toString(),
                                      ),
                                      CountdownTimer(endTime: auction.endsAt),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                StoryButton(
                                  onPressed: () {
                                    Get.snackbar('story'.tr, 'story_preview'.tr);
                                  },
                                ),
                                if (product != null)
                                  GeminiInfoButton(product: product),
                              ],
                            ),
                          ],
                        ),
                        if (product != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

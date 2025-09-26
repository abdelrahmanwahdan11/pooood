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
import 'explore_controller.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<ExploreController>();
  final settings = Get.find<SettingsRepository>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final padding = Responsive.adaptivePadding(context);
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Obx(
        () {
          final items = controller.filteredItems();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilters(context),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isExpanded(context) ? 3 : 1,
                    childAspectRatio: Responsive.isExpanded(context) ? 1.4 : 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: items.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    if (item is Auction) {
                      final product = controller.products[item.productId];
                      if (product == null) return const SizedBox();
                      return GlassContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NetworkImageSafe(
                              url: product.images.first,
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 12),
                            Text(product.title,
                                style: Theme.of(context).textTheme.titleMedium),
                            Text('${product.category} • ${product.condition}'),
                            Text(
                              '${'ending_in'.tr}: ${TimeUtils.formatCountdown(item.endTime.difference(DateTime.now()))}',
                            ),
                            Text(
                              DistanceUtils.formatDistance(
                                  item.distanceKm, settings.distanceUnit),
                            ),
                          ],
                        ),
                      );
                    } else if (item is DiscountDeal) {
                      return GlassContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NetworkImageSafe(
                              url: item.images.first,
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 12),
                            Text(item.storeName,
                                style: Theme.of(context).textTheme.titleMedium),
                            Text('${item.product} — ${item.discountPercent.toStringAsFixed(0)}%'),
                            Text(item.location),
                            Text(
                              DistanceUtils.formatDistance(
                                  item.distanceKm, settings.distanceUnit),
                            ),
                            Text('${'valid_until'.tr}: ${TimeUtils.formatDate(item.validUntil)}'),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: Text('auctions'.tr),
          selected: controller.filterType.value == ExploreFilter.auctions,
          onSelected: (_) => controller.filterType.value = ExploreFilter.auctions,
        ),
        ChoiceChip(
          label: Text('discounts'.tr),
          selected: controller.filterType.value == ExploreFilter.discounts,
          onSelected: (_) => controller.filterType.value = ExploreFilter.discounts,
        ),
        ChoiceChip(
          label: Text('both'.tr),
          selected: controller.filterType.value == ExploreFilter.both,
          onSelected: (_) => controller.filterType.value = ExploreFilter.both,
        ),
        FilterChip(
          label: Text('${'distance'.tr}: ${controller.distanceLimit.value.toStringAsFixed(0)} km'),
          onSelected: (_) => controller.distanceLimit.value += 5,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

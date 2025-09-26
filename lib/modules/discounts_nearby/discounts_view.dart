import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/distance.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/time.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/network_image_safe.dart';
import '../../data/repositories/settings_repo.dart';
import 'discounts_controller.dart';

class DiscountsNearbyView extends StatefulWidget {
  const DiscountsNearbyView({super.key});

  @override
  State<DiscountsNearbyView> createState() => _DiscountsNearbyViewState();
}

class _DiscountsNearbyViewState extends State<DiscountsNearbyView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<DiscountsController>();
  final settings = Get.find<SettingsRepository>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final padding = Responsive.adaptivePadding(context);
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Obx(
        () {
          final items = controller.filteredDiscounts();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Filters(controller: controller),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final deal = items[index];
                    return GlassContainer(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NetworkImageSafe(
                            url: deal.images.first,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 12),
                          Text(deal.storeName,
                              style: Theme.of(context).textTheme.titleLarge),
                          Text('${deal.product} • ${deal.category}'),
                          Text(deal.location),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Chip(
                                label: Text('${deal.discountPercent.toStringAsFixed(0)}%'),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${'distance'.tr}: ${DistanceUtils.formatDistance(deal.distanceKm, settings.distanceUnit)}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${'valid_from'.tr}: ${TimeUtils.formatDate(deal.validFrom)} - ${'valid_until'.tr}: ${TimeUtils.formatDate(deal.validUntil)}',
                          ),
                          const SizedBox(height: 8),
                          Text(deal.terms),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Filters extends StatelessWidget {
  const _Filters({required this.controller});

  final DiscountsController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilterChip(
          label: Text('${'distance'.tr}: ${controller.filterDistance.value.toStringAsFixed(0)} km'),
          onSelected: (_) async {
            final value = await _showSlider(context, controller.filterDistance.value);
            if (value != null) controller.filterDistance.value = value;
          },
        ),
        FilterChip(
          label: Text('${'min_discount'.tr}: ${controller.minDiscount.value.toStringAsFixed(0)}%'),
          onSelected: (_) async {
            final value = await _showSlider(context, controller.minDiscount.value, max: 90);
            if (value != null) controller.minDiscount.value = value;
          },
        ),
        FilterChip(
          label: Text(controller.onlyOpenNow.value ? 'open_now'.tr : 'open_now'.tr),
          selected: controller.onlyOpenNow.value,
          onSelected: (value) => controller.onlyOpenNow.value = value,
        ),
      ],
    );
  }

  Future<double?> _showSlider(BuildContext context, double initial,
      {double max = 50}) async {
    double tempValue = initial;
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('filters'.tr),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: tempValue,
                min: 1,
                max: max,
                divisions: max.toInt(),
                onChanged: (value) => setState(() => tempValue = value),
              ),
              Text(tempValue.toStringAsFixed(0)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          FilledButton(
            onPressed: () => Get.back(result: tempValue),
            child: Text('apply'.tr),
          )
        ],
      ),
    );
  }
}

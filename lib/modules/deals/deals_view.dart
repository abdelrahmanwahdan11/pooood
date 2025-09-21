import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/glass_container.dart';
import 'deals_controller.dart';

class DealsView extends GetView<DealsController> {
  const DealsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('deals_feed'.tr),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_alt_outlined),
              onSelected: controller.filterByRegion,
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'global', child: Text('Global')),
                const PopupMenuItem(value: 'mena', child: Text('MENA')),
                const PopupMenuItem(value: 'usa', child: Text('USA')),
              ],
            ),
          ],
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: controller.deals.length,
                  itemBuilder: (context, index) {
                    final deal = controller.deals[index];
                    if (controller.region.value != 'global' && deal.region != controller.region.value) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GlassContainer(
                        child: ListTile(
                          title: Text('${deal.discountPct.toStringAsFixed(0)}% ${'deal_badge'.tr}'),
                          subtitle: CountdownTimer(
                            endAt: deal.endAt,
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Text(deal.region.toUpperCase()),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

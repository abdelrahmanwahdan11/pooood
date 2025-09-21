import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/glass_container.dart';
import 'auctions_controller.dart';

class AuctionsView extends GetView<AuctionsController> {
  const AuctionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('auction_feed'.tr),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: controller.auctions.length,
                  itemBuilder: (context, index) {
                    final auction = controller.auctions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GlassContainer(
                        child: ListTile(
                          title: Text('${'current_bid'.tr}: ${formatCurrency(
                                auction.currentBid,
                                locale: Get.locale?.languageCode ?? 'en',
                                currency: currentCurrency(),
                              )}'),
                          subtitle: CountdownTimer(
                            endAt: auction.endAt,
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Text('${auction.biddersCount} ${'bidders_count'.tr}'),
                          onTap: () => Get.toNamed('${AppRoutes.auction}/${auction.id}'),
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

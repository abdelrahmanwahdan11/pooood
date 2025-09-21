import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/currency_utils.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/models/auction.dart';
import '../../data/models/product.dart';
import 'auctions_controller.dart';

class AuctionDetailView extends GetView<AuctionsController> {
  const AuctionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'];
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('auction_badge'.tr),
        ),
        body: FutureBuilder<Auction?>(
          future: controller.findAuction(id ?? ''),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final auction = snapshot.data!;
            return FutureBuilder<Product?>(
              future: controller.productForAuction(auction),
              builder: (context, productSnap) {
                final product = productSnap.data;
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    GlassContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product?.title ?? '...'),
                          const SizedBox(height: 12),
                          Text('${'current_bid'.tr}: ${formatCurrency(
                                auction.currentBid,
                                locale: Get.locale?.languageCode ?? 'en',
                                currency: currentCurrency(),
                              )}'),
                          const SizedBox(height: 8),
                          CountdownTimer(
                            endAt: auction.endAt,
                            textStyle: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          AppButton(label: 'bid_now'.tr, onPressed: () {}),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('auction_history'.tr, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ...auction.history.map(
                      (entry) => GlassContainer(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(formatCurrency(
                            (entry['amount'] as num).toDouble(),
                            locale: Get.locale?.languageCode ?? 'en',
                            currency: currentCurrency(),
                          )),
                          subtitle: Text('User ${entry['user']}'),
                          trailing: Text(entry['time'] as String),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // TODO: Firebase
                    // 1) بث المزايدات الحية عبر Firestore document stream.
                    // 2) استخدام Functions للتحقق من صحة المزايدات وحماية الأسعار.
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

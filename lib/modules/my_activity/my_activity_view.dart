import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/widgets/auction_card.dart';
import '../common/widgets/deal_card.dart';
import 'my_activity_controller.dart';

class MyActivityView extends GetView<MyActivityController> {
  const MyActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final initialTab = Get.arguments == 'discounts' ? 1 : 0;
    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: Scaffold(
        appBar: AppBar(
          title: Text('my_activity'.tr),
          bottom: TabBar(
            tabs: [
              Tab(text: 'my_bids'.tr),
              Tab(text: 'my_discounts'.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              itemCount: controller.bids.length,
              itemBuilder: (context, index) => AuctionCard(auction: controller.bids[index]),
            ),
            ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              itemCount: controller.discounts.length,
              itemBuilder: (context, index) => DealCard(deal: controller.discounts[index]),
            ),
          ],
        ),
      ),
    );
  }
}

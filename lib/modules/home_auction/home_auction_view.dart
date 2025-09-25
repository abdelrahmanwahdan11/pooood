import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../common/widgets/auction_card.dart';
import 'home_auction_controller.dart';

class HomeAuctionView extends GetView<HomeAuctionController> {
  const HomeAuctionView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Responsive.sizeOf(constraints);
        final widthFactor = switch (size) {
          ScreenSize.compact => 0.95,
          ScreenSize.medium => 0.88,
          ScreenSize.expanded => 0.6,
        };
        return Obx(
          () => PageView.builder(
            controller: controller.pageController,
            itemCount: controller.auctions.length,
            onPageChanged: controller.selectAuction,
            itemBuilder: (context, index) {
              final auction = controller.auctions[index];
              return Padding(
                padding: EdgeInsets.only(
                  top: size == ScreenSize.compact ? 8 : 16,
                  bottom: size == ScreenSize.expanded ? 32 : 16,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    widthFactor: widthFactor,
                    child: AuctionCard(auction: auction, onViewMap: () {}),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

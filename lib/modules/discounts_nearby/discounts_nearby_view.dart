import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../common/widgets/deal_card.dart';
import '../common/widgets/empty_state.dart';
import 'discounts_nearby_controller.dart';

class DiscountsNearbyView extends GetView<DiscountsNearbyController> {
  const DiscountsNearbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Responsive.sizeOf(constraints);
        final padding = EdgeInsets.symmetric(
          vertical: 12,
          horizontal: Responsive.horizontalPadding(size),
        );
        return Obx(
          () => controller.deals.isEmpty
              ? const EmptyState()
              : ListView.builder(
                  padding: padding,
                  itemCount: controller.deals.length,
                  itemBuilder: (context, index) {
                    final deal = controller.deals[index];
                    return DealCard(deal: deal, onViewMap: () {});
                  },
                ),
        );
      },
    );
  }
}

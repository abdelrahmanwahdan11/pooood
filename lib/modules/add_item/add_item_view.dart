import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../../core/widgets/glass_container.dart';
import 'add_item_controller.dart';

class AddItemView extends GetView<AddItemController> {
  const AddItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.adaptivePadding(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('add'.tr),
        backgroundColor: Colors.transparent,
      ),
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: GlassContainer(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                TabBar(
                  labelColor: const Color(0xFF222222),
                  tabs: [
                    Tab(text: 'add_auction'.tr),
                    Tab(text: 'add_discount'.tr),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _AuctionForm(controller: controller),
                      _DiscountForm(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuctionForm extends StatelessWidget {
  const _AuctionForm({required this.controller});

  final AddItemController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.auctionFormKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          TextFormField(
            controller: controller.auctionTitle,
            decoration: InputDecoration(labelText: 'title'.tr),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.auctionCategory,
            decoration: InputDecoration(labelText: 'category'.tr),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.auctionCondition,
            decoration: InputDecoration(labelText: 'condition'.tr),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.startPrice,
            decoration: InputDecoration(labelText: 'current_price'.tr),
            keyboardType: TextInputType.number,
            validator: controller.validateNumber,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.minIncrement,
            decoration: InputDecoration(labelText: 'min_increment'.tr),
            keyboardType: TextInputType.number,
            validator: controller.validateNumber,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.reservePrice,
            decoration: InputDecoration(
              labelText: "${'reserve_price'.tr} (${'optional'.tr})",
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.pickupInfo,
            decoration: InputDecoration(labelText: 'pickup_shipping'.tr),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.startTime,
            decoration: InputDecoration(labelText: 'Start (YYYY-MM-DD HH:MM)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.endTime,
            decoration: InputDecoration(labelText: 'End (YYYY-MM-DD HH:MM)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.locationText,
            decoration: InputDecoration(labelText: 'location'.tr),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.auctionImages,
            decoration:
                InputDecoration(labelText: 'photos'.tr, hintText: 'url1,url2'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.terms,
            decoration: InputDecoration(labelText: 'terms'.tr),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: controller.submitAuction,
            child: Text('publish'.tr),
          ),
        ],
      ),
    );
  }
}

class _DiscountForm extends StatelessWidget {
  const _DiscountForm({required this.controller});

  final AddItemController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.discountFormKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          TextFormField(
            controller: controller.discountStore,
            decoration: InputDecoration(labelText: 'store'.tr),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.discountProduct,
            decoration: InputDecoration(labelText: 'product'.tr),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.discountCategory,
            decoration: InputDecoration(labelText: 'category'.tr),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.discountPercent,
            decoration: InputDecoration(labelText: 'discount'.tr),
            keyboardType: TextInputType.number,
            validator: controller.validateNumber,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.discountOriginal,
            decoration: InputDecoration(labelText: 'current_price'.tr),
            keyboardType: TextInputType.number,
            validator: controller.validateNumber,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.discountValidFrom,
            decoration: InputDecoration(labelText: 'valid_from'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.discountValidUntil,
            decoration: InputDecoration(labelText: 'valid_until'.tr),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.discountLocation,
            decoration: InputDecoration(labelText: 'location'.tr),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.discountImages,
            decoration:
                InputDecoration(labelText: 'photos'.tr, hintText: 'url1,url2'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.discountTerms,
            decoration: InputDecoration(labelText: 'terms'.tr),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: controller.submitDiscount,
            child: Text('publish'.tr),
          ),
        ],
      ),
    );
  }
}

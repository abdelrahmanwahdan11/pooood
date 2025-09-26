import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/widgets/glass_container.dart';
import 'add_item_controller.dart';

class AddItemView extends GetView<AddItemController> {
  const AddItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('add'.tr),
          bottom: TabBar(
            tabs: [
              Tab(text: 'add_auction'.tr),
              Tab(text: 'add_discount'.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAuctionForm(context),
            _buildDiscountForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAuctionForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.auctionFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.auctionTitleController,
                decoration: InputDecoration(labelText: 'product_name'.tr),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'start_price'.tr),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    double.tryParse(value ?? '') == null ? 'invalid_number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'description'.tr),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitAuction,
                  child: Text('submit'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.discountFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.discountTitleController,
                decoration: InputDecoration(labelText: 'product_name'.tr),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'store'.tr),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: 'discount_percent'.tr),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    double.tryParse(value ?? '') == null ? 'invalid_number' : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitDiscount,
                  child: Text('submit'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

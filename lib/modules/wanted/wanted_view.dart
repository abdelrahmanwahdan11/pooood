import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_glass_card.dart';
import 'wanted_controller.dart';

class WantedView extends GetView<WantedController> {
  const WantedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('wanted_title'.tr, style: Get.textTheme.headlineSmall),
          const SizedBox(height: 12),
          AppButton(
            label: 'drawer_add_wanted'.tr,
            onPressed: () => _showCreateSheet(context),
            icon: Icons.add,
            expanded: true,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.wanted.isEmpty) {
                return EmptyState(
                  icon: Icons.notifications_active_outlined,
                  title: 'empty_wanted'.tr,
                  subtitle: 'wanted_create_hint'.tr,
                );
              }
              return ListView.builder(
                itemCount: controller.wanted.length,
                itemBuilder: (_, index) {
                  final request = controller.wanted[index];
                  return GradientGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.title, style: Get.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text('${'target_price'.tr}: ${request.targetPrice.toStringAsFixed(0)}'),
                        const SizedBox(height: 8),
                        Text('${'radius_km'.tr}: ${request.radiusKm.toStringAsFixed(0)}'),
                        const SizedBox(height: 4),
                        Text('created_at'.trParams({'value': request.createdAt.toLocal().toString()})),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    Get.bottomSheet(
      GradientGlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('drawer_add_wanted'.tr, style: Get.textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(labelText: 'wanted_title'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.priceController,
              decoration: InputDecoration(labelText: 'target_price'.tr),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.radiusController,
              decoration: InputDecoration(labelText: 'radius_km'.tr),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'create'.tr,
              onPressed: controller.createWanted,
              expanded: true,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}

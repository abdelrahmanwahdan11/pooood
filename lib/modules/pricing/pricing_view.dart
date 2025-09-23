import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_glass_card.dart';
import '../../core/widgets/price_gauge.dart';
import 'pricing_controller.dart';

class PricingView extends GetView<PricingController> {
  const PricingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('price_calc'.tr, style: Get.textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text('pricing_hint'.tr, style: Get.textTheme.bodyMedium),
          const SizedBox(height: 16),
          _buildTextField(controller.categoryController, 'category'),
          _buildTextField(controller.brandController, 'brand'),
          _buildTextField(controller.modelController, 'model'),
          _buildTextField(controller.yearController, 'year', keyboardType: TextInputType.number),
          _buildTextField(controller.conditionController, 'condition'),
          _buildTextField(controller.cityController, 'city'),
          _buildTextField(controller.specsController, 'specs', maxLines: 3),
          const SizedBox(height: 16),
          Obx(
            () => AppButton(
              label: controller.isLoading.value ? 'loading'.tr : 'calculate_price'.tr,
              onPressed: controller.isLoading.value ? null : controller.calculate,
              expanded: true,
              icon: Icons.auto_graph,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final result = controller.priceResult.value;
            if (result == null) {
              return EmptyState(
                icon: Icons.analytics_outlined,
                title: 'empty_pricing'.tr,
                subtitle: 'pricing_ai_todo'.tr,
              );
            }
            return GradientGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('price_result_title'.tr, style: Get.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  PriceGauge(
                    value: result.estimate,
                    min: result.min,
                    max: result.max,
                    confidence: result.confidence,
                  ),
                  const SizedBox(height: 12),
                  Text('price_explanation'.tr, style: Get.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Obx(() => Text(controller.explanation.value, style: Get.textTheme.bodyMedium)),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'gemini_explain'.tr,
                    onPressed: controller.explainWithGemini,
                    isOutlined: true,
                    expanded: true,
                    icon: Icons.auto_awesome,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelKey,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: labelKey.tr),
      ),
    );
  }
}

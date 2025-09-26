import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../common/widgets/glass_container.dart';
import '../common/widgets/section_header.dart';
import 'ai_pricing_controller.dart';

class AiPricingView extends GetView<AiPricingController> {
  const AiPricingView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Responsive.sizeOf(constraints);
        final padding = EdgeInsets.symmetric(
          vertical: 16,
          horizontal: Responsive.horizontalPadding(size),
        );
        return SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'ai_pricing_tab'.tr),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.productController,
                        decoration: InputDecoration(labelText: 'product_name'.tr),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.conditionController,
                        decoration:
                            InputDecoration(labelText: 'condition_label'.tr),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.basePriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'base_price'.tr),
                        validator: (value) =>
                            double.tryParse(value ?? '') == null ? 'invalid_number' : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.submit,
                          child: Text('submit'.tr),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () {
                  final result = controller.result;
                  if (result == null) {
                    return const SizedBox.shrink();
                  }
                  return GlassContainer(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'ai_price_estimate'.tr}: ﷼${result.estimatedPrice.toStringAsFixed(0)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text('${'recommended_time'.tr}: ${result.recommendedTime}'),
                        const SizedBox(height: 6),
                        Text('${'recommended_area'.tr}: ${result.recommendedArea}'),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

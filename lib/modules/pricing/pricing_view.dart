import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/currency_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/gradient_card.dart';
import '../../core/widgets/price_gauge.dart';
import '../../core/widgets/shimmer_loader.dart';
import 'pricing_controller.dart';

class PricingView extends StatefulWidget {
  const PricingView({super.key});

  @override
  State<PricingView> createState() => _PricingViewState();
}

class _PricingViewState extends State<PricingView>
    with AutomaticKeepAliveClientMixin {
  late final PricingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PricingController>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'pricing'.tr,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _TextField(
              controller: controller.categoryController,
              label: 'category'.tr,
              validator: controller.requiredValidator,
            ),
            const SizedBox(height: 12),
            _TextField(
              controller: controller.brandController,
              label: 'brand'.tr,
              validator: controller.requiredValidator,
            ),
            const SizedBox(height: 12),
            _TextField(
              controller: controller.modelController,
              label: 'model'.tr,
              validator: controller.requiredValidator,
            ),
            const SizedBox(height: 12),
            _TextField(
              controller: controller.yearController,
              label: 'year'.tr,
              keyboardType: TextInputType.number,
              validator: controller.yearValidator,
            ),
            const SizedBox(height: 12),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.condition.value,
                decoration: InputDecoration(labelText: 'condition'.tr),
                items: const [
                  DropdownMenuItem(value: 'new', child: Text('New')),
                  DropdownMenuItem(value: 'like_new', child: Text('Like New')),
                  DropdownMenuItem(value: 'excellent', child: Text('Excellent')),
                  DropdownMenuItem(value: 'good', child: Text('Good')),
                  DropdownMenuItem(value: 'fair', child: Text('Fair')),
                ],
                onChanged: (value) {
                  if (value != null) controller.condition.value = value;
                },
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.currency.value,
                decoration: InputDecoration(labelText: 'currency'.tr),
                items: const [
                  DropdownMenuItem(value: 'USD', child: Text('USD')),
                  DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                  DropdownMenuItem(value: 'AED', child: Text('AED')),
                  DropdownMenuItem(value: 'SAR', child: Text('SAR')),
                ],
                onChanged: (value) {
                  if (value != null) controller.currency.value = value;
                },
              ),
            ),
            const SizedBox(height: 12),
            _TextField(
              controller: controller.specsController,
              label: 'specs'.tr,
              maxLines: 3,
              hintText: 'CPU, 256GB, dual SIM',
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'calculate'.tr,
              onPressed: controller.calculate,
              isExpanded: true,
              icon: Icons.analytics_outlined,
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (controller.isLoading.value) {
                return const ShimmerLoader(height: 180);
              }
              final result = controller.result.value;
              if (result == null) {
                return Text('pricing_hint'.tr);
              }
              return GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'pricing_summary'.tr,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyUtils.format(
                        result.estimate,
                        currency: result.currency,
                      ),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${'price_range'.tr}: ${CurrencyUtils.formatRange(result.min, result.max, currency: result.currency)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    PriceGauge(
                      confidence: result.confidence,
                      label: 'confidence'.tr,
                    ),
                    const SizedBox(height: 20),
                    Text('similar_items'.tr, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    ...result.comparableItems.map(
                      (item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item.title),
                        subtitle: Text(item.source ?? ''),
                        trailing: Text(
                          CurrencyUtils.format(
                            item.price,
                            currency: result.currency,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.hintText,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
      ),
    );
  }
}

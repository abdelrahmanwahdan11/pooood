import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/routing/app_routes.dart';
import '../../data/models/pricing_request.dart';
import '../../data/repositories/settings_repo.dart';
import 'pricing_controller.dart';

class AiPricingView extends StatefulWidget {
  const AiPricingView({super.key});

  @override
  State<AiPricingView> createState() => _AiPricingViewState();
}

class _AiPricingViewState extends State<AiPricingView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<PricingController>();
  final categoryController = TextEditingController();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController(text: '2022');
  final conditionController = TextEditingController(text: 'Like New');
  final marketController = TextEditingController(text: 'Electronics');
  final quantityController = TextEditingController(text: '1');
  final locationController = TextEditingController();
  final photosController = TextEditingController();
  final descriptionController = TextEditingController();
  final timeframeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final padding = Responsive.adaptivePadding(context);
    final settings = Get.find<SettingsRepository>();
    return Padding(
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ai_pricing_form_title'.tr,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  _buildField(categoryController, 'category'.tr),
                  _buildField(brandController, 'brand'.tr),
                  _buildField(modelController, 'model'.tr),
                  _buildField(yearController, 'year'.tr,
                      keyboard: TextInputType.number),
                  _buildField(conditionController, 'condition'.tr),
                  _buildField(marketController, 'market'.tr),
                  _buildField(quantityController, 'quantity'.tr,
                      keyboard: TextInputType.number),
                  _buildField(locationController, 'location'.tr),
                  _buildField(photosController, 'photos'.tr,
                      hint: 'url1,url2'),
                  _buildField(descriptionController, 'description'.tr,
                      maxLines: 3),
                  _buildField(timeframeController, 'timeframe'.tr),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => FilledButton(
                        onPressed: controller.isCalculating.value
                            ? null
                            : () => _estimate(settings),
                        child: controller.isCalculating.value
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text('estimate'.tr),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              final result = controller.result.value;
              if (result == null) {
                return const SizedBox.shrink();
              }
              return GlassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('estimated_price_range'.tr,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Text(
                      '${result.estimateLow.toStringAsFixed(0)} - ${result.estimateHigh.toStringAsFixed(0)} ${settings.currency}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('${'confidence'.tr}: ${result.confidence}%'),
                    Text('${'best_time_to_sell'.tr}: ${result.bestTime}'),
                    Text('${'suggested_area'.tr}: ${result.suggestedArea}'),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => Get.toNamed(AppRoutes.addItem),
                      child: Text('create_auction_with_settings'.tr),
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

  void _estimate(SettingsRepository settings) {
    final request = PricingRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      category: categoryController.text,
      brand: brandController.text,
      model: modelController.text,
      year: int.tryParse(yearController.text) ?? DateTime.now().year,
      condition: conditionController.text,
      market: marketController.text,
      quantity: int.tryParse(quantityController.text) ?? 1,
      location: locationController.text,
      photoUrls: photosController.text.split(',').map((e) => e.trim()).toList(),
      description: descriptionController.text,
      timeframe: timeframeController.text,
    );
    controller.estimate(request);
  }

  Widget _buildField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboard = TextInputType.text, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, hintText: hint),
      ),
    );
  }

  @override
  void dispose() {
    categoryController.dispose();
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    conditionController.dispose();
    marketController.dispose();
    quantityController.dispose();
    locationController.dispose();
    photosController.dispose();
    descriptionController.dispose();
    timeframeController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

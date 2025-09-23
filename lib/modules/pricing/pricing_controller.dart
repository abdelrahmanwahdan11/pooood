import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/geo_point.dart';
import '../../data/models/price_request.dart';
import '../../data/models/price_result.dart';
import '../../data/models/product.dart';
import '../../services/gemini_service.dart';
import '../../services/pricing_service.dart';

class PricingController extends GetxController {
  PricingController(this._pricingService, this._geminiService);

  final PricingService _pricingService;
  final GeminiService _geminiService;

  final categoryController = TextEditingController(text: 'Cars');
  final brandController = TextEditingController(text: 'Tesla');
  final modelController = TextEditingController(text: 'Model 3');
  final yearController = TextEditingController(text: '2022');
  final conditionController = TextEditingController(text: 'excellent');
  final cityController = TextEditingController(text: 'Riyadh');
  final specsController = TextEditingController(text: 'Dual motor, autopilot');

  final isLoading = false.obs;
  final priceResult = Rxn<PriceResult>();
  final explanation = RxString('');

  Future<void> calculate() async {
    isLoading.value = true;
    final request = PriceRequest(
      category: categoryController.text.trim(),
      brand: brandController.text.trim(),
      model: modelController.text.trim(),
      year: int.tryParse(yearController.text.trim()) ?? DateTime.now().year,
      condition: conditionController.text.trim(),
      specs: specsController.text.trim(),
      city: cityController.text.trim(),
    );
    final result = await _pricingService.estimatePrice(request);
    priceResult.value = result;
    explanation.value = result.explanation ?? '';
    isLoading.value = false;
  }

  Future<void> explainWithGemini() async {
    final result = priceResult.value;
    if (result == null) return;
    final product = Product(
      id: 'pricing',
      title: '${brandController.text} ${modelController.text}',
      brand: brandController.text,
      category: categoryController.text,
      description:
          'Condition: ${conditionController.text}, Specs: ${specsController.text}',
      images: const [],
      ownerId: 'pricing',
      basePrice: result.estimate,
      location: const GeoPointModel(latitude: 0, longitude: 0),
      createdAt: DateTime.now(),
    );
    final summary = await _geminiService.summaryForProduct(product);
    if (summary != null) {
      explanation.value = summary;
    }
  }

  @override
  void onClose() {
    categoryController.dispose();
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    conditionController.dispose();
    cityController.dispose();
    specsController.dispose();
    super.onClose();
  }
}

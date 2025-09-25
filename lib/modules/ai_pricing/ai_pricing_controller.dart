import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/pricing_request.dart';
import '../../data/repositories/pricing_repository.dart';

class AiPricingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final productController = TextEditingController();
  final conditionController = TextEditingController();
  final basePriceController = TextEditingController();

  final _result = Rxn<PricingRequest>();

  PricingRepository get _repository => Get.find<PricingRepository>();

  PricingRequest? get result => _result.value;

  void submit() {
    if (!formKey.currentState!.validate()) return;
    final base = double.parse(basePriceController.text.trim());
    final pricing = _repository.submitEstimate(
      productName: productController.text.trim(),
      condition: conditionController.text.trim(),
      basePrice: base,
    );
    _result.value = pricing;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/validators.dart';
import '../../data/datasources/local/get_storage_ds.dart';
import '../../data/models/price_request.dart';
import '../../data/models/price_result.dart';
import '../../services/pricing_service.dart';

class PricingController extends GetxController {
  PricingController(this._service, this._storage);

  final PricingService _service;
  final GetStorageDataSource _storage;

  final formKey = GlobalKey<FormState>();
  late final TextEditingController categoryController;
  late final TextEditingController brandController;
  late final TextEditingController modelController;
  late final TextEditingController yearController;
  late final TextEditingController specsController;

  final RxString condition = 'excellent'.obs;
  final RxString currency = 'USD'.obs;
  final RxBool isLoading = false.obs;
  final Rxn<PriceResult> result = Rxn<PriceResult>();

  @override
  void onInit() {
    super.onInit();
    categoryController = TextEditingController();
    brandController = TextEditingController();
    modelController = TextEditingController();
    yearController = TextEditingController(text: DateTime.now().year.toString());
    specsController = TextEditingController();

    final last = _storage.readLastPriceRequest();
    if (last != null) {
      categoryController.text = last.category;
      brandController.text = last.brand;
      modelController.text = last.model;
      yearController.text = last.year.toString();
      condition.value = last.condition;
      specsController.text = last.specs.join(', ');
      currency.value = last.currency;
    }
  }

  @override
  void onClose() {
    categoryController.dispose();
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    specsController.dispose();
    super.onClose();
  }

  Future<void> calculate() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;
    final request = PriceRequest(
      category: categoryController.text.trim(),
      brand: brandController.text.trim(),
      model: modelController.text.trim(),
      year: int.tryParse(yearController.text) ?? DateTime.now().year,
      condition: condition.value,
      specs: specsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      currency: currency.value,
    );
    await _storage.savePriceRequest(request);
    final priceResult = await _service.estimatePrice(request);
    result.value = priceResult;
    isLoading.value = false;
  }

  String? requiredValidator(String? value) =>
      Validators.requiredField(value, message: 'required'.tr);

  String? yearValidator(String? value) => Validators.year(value);
}

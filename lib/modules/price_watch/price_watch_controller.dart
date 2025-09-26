import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/price_watch.dart';
import '../../data/repositories/price_watch_repository.dart';

class PriceWatchController extends GetxController {
  final _items = <PriceWatch>[].obs;

  PriceWatchRepository get _repository => Get.find<PriceWatchRepository>();

  List<PriceWatch> get watches => _items;

  final formKey = GlobalKey<FormState>();
  final productController = TextEditingController();
  final priceController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _items.assignAll(_repository.getWatches());
  }

  void addWatch() {
    if (!formKey.currentState!.validate()) return;
    final watch = PriceWatch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productName: productController.text.trim(),
      targetPrice: double.parse(priceController.text.trim()),
      notes: notesController.text.trim(),
      isActive: true,
    );
    _repository.addWatch(watch);
    _items.assignAll(_repository.getWatches());
    productController.clear();
    priceController.clear();
    notesController.clear();
  }
}

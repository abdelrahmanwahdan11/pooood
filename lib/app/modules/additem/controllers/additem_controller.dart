/*
  هذا الملف يدير منطق إضافة عنصر جديد مع التحقق من المدخلات وتخزين البيانات محلياً.
  يمكن تطويره لاحقاً لرفع الصور إلى خادم أو استخدام ذكاء اصطناعي لتحليل العنصر.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/item_model.dart';
import '../../../data/services/storage_service.dart';

class AdditemController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final isAuction = true.obs;
  final durationMinutes = 30.obs;
  final images = <String>[].obs;
  final isSaving = false.obs;

  final picker = ImagePicker();

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final result = await picker.pickImage(source: ImageSource.gallery);
      if (result != null) {
        images.add(result.path);
      }
    } catch (e) {
      Get.snackbar('snackbar.error'.tr, e.toString());
    }
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isSaving.value = true;
    try {
      final uuid = const Uuid();
      final items = StorageService.to.getItems();
      final newItem = ItemModel(
        id: uuid.v4(),
        titleAr: titleController.text.trim(),
        titleEn: titleController.text.trim(),
        descriptionAr: descriptionController.text.trim(),
        descriptionEn: descriptionController.text.trim(),
        category: AppConstants.categoryIds.first,
        images: images.isEmpty ? [AppConstants.placeholderImages.first] : images.toList(),
        startPrice: double.parse(priceController.text.trim()),
        currentPrice: double.parse(priceController.text.trim()),
        isAuction: isAuction.value,
        endTime: isAuction.value ? DateTime.now().add(Duration(minutes: durationMinutes.value)) : null,
      );
      items.insert(0, newItem);
      await StorageService.to.saveItems(items);
      Get.back(result: newItem);
      Get.snackbar('additem.title'.tr, 'additem.success'.tr);
    } catch (e) {
      Get.snackbar('additem.title'.tr, 'additem.failure'.tr, backgroundColor: Get.theme.colorScheme.errorContainer);
    } finally {
      isSaving.value = false;
    }
  }

  String? validateTitle(String? value) => Validators.validateNonEmpty(value ?? '');

  String? validateDescription(String? value) => Validators.validateNonEmpty(value ?? '');

  String? validatePrice(String? value) => Validators.validatePrice(value ?? '');
}

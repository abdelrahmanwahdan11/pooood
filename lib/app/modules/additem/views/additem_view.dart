/*
  هذا الملف يبني واجهة إضافة العنصر مع نماذج التحقق وخيارات الصور والمحاكاة.
  يمكن تطويره لإضافة رفع متعدد الصور أو دمج ذكاء اصطناعي لتقدير السعر.
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/additem_controller.dart';

class AdditemView extends GetView<AdditemController> {
  const AdditemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('additem.title'.tr)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('additem.name'.tr, style: Get.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.titleController,
                  validator: controller.validateTitle,
                  decoration: InputDecoration(hintText: 'additem.name'.tr),
                ),
                const SizedBox(height: 16),
                Text('additem.description'.tr, style: Get.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  validator: controller.validateDescription,
                  decoration: InputDecoration(hintText: 'additem.description'.tr),
                ),
                const SizedBox(height: 16),
                Text('additem.price'.tr, style: Get.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.priceController,
                  keyboardType: TextInputType.number,
                  validator: controller.validatePrice,
                  decoration: InputDecoration(hintText: 'additem.price'.tr),
                ),
                const SizedBox(height: 16),
                Obx(() => SwitchListTile(
                      value: controller.isAuction.value,
                      onChanged: (value) => controller.isAuction.value = value,
                      title: Text('additem.auction'.tr),
                    )),
                Obx(() => controller.isAuction.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('additem.duration'.tr, style: Get.textTheme.titleMedium),
                          Slider(
                            value: controller.durationMinutes.value.toDouble(),
                            min: 10,
                            max: 240,
                            divisions: 23,
                            label: '${controller.durationMinutes.value} ${'common.minutes'.tr}',
                            onChanged: (value) => controller.durationMinutes.value = value.round(),
                          ),
                        ],
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('additem.addImage'.tr, style: Get.textTheme.titleMedium),
                    IconButton(
                      onPressed: controller.pickImage,
                      icon: const Icon(Icons.add_a_photo_outlined),
                    ),
                  ],
                ),
                Obx(() => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: controller.images
                          .map((path) => ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    )),
                const SizedBox(height: 24),
                Obx(() => ElevatedButton.icon(
                      onPressed: controller.isSaving.value ? null : controller.submit,
                      icon: controller.isSaving.value
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.cloud_upload_outlined),
                      label: Text(controller.isSaving.value ? 'snackbar.success'.tr : 'additem.submit'.tr),
                    )),
                const SizedBox(height: 24),
                Text('tutorial.step1'.tr),
                Text('tutorial.step2'.tr),
                Text('tutorial.step3'.tr),
                const SizedBox(height: 16),
                Text('notifications.placeholder'.tr, style: Get.textTheme.bodySmall),
                Text('offline.placeholder'.tr, style: Get.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/glass_container.dart';
import 'category_controller.dart';

class CategoriesView extends GetView<CategoryController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('categories'.tr),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return GlassContainer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.devices_other, size: 48, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 12),
                          Text(category.name, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('trend_badge'.tr, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

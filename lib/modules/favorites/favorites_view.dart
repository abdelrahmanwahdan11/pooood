import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/widgets/product_card.dart';
import 'favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('favorites'.tr),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.favorites.isEmpty) {
              return Center(child: Text('empty_state'.tr));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: controller.favorites.length,
              itemBuilder: (context, index) {
                final product = controller.favorites[index];
                return ProductCard(
                  product: product,
                  showTrend: true,
                  onTap: () => Get.toNamed('${AppRoutes.product}/${product.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

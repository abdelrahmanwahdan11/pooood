/*
  هذا الملف يبني واجهة تفاصيل العنصر مع عرض الصور والحركات ومربع الذكاء الاصطناعي.
  يمكن تطويره لاحقاً لإضافة عرض عروض مشابهة أو بث مباشر للمزايدة.
*/
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/item_model.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../controllers/details_controller.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final item = Get.arguments as ItemModel;
    final controller = Get.find<DetailsController>(tag: item.id);
    final isFavorite = StorageService.to.getFavorites().contains(item.id).obs;
    return Scaffold(
      appBar: AppBar(
        title: Text('details.title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => Get.offAllNamed(AppRoutes.home),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              Get.toNamed(AppRoutes.wishlist);
              break;
            case 2:
              Get.toNamed(AppRoutes.myBids);
              break;
            case 3:
              Get.toNamed(AppRoutes.settings);
              break;
            default:
              Get.offAllNamed(AppRoutes.home);
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'nav.home'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: 'nav.wishlist'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.local_offer), label: 'nav.mybids'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: 'nav.settings'.tr),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Hero(
              tag: 'item_${item.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  item.images.isNotEmpty ? item.images.first : 'https://picsum.photos/seed/${item.id}/600/400',
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1)),
            const SizedBox(height: 16),
            Text(Get.locale?.languageCode == 'ar' ? item.titleAr : item.titleEn,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(Helpers.formatCurrency(item.currentPrice), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('details.description'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(Get.locale?.languageCode == 'ar' ? item.descriptionAr : item.descriptionEn),
            const SizedBox(height: 24),
            Obx(() => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [Get.theme.colorScheme.primary.withOpacity(0.15), Get.theme.colorScheme.secondary.withOpacity(0.2)]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('details.aiBox'.tr, style: Get.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        ),
                        child: Text(
                          controller.aiInfos.isEmpty
                              ? 'home.empty'.tr
                              : controller.aiInfos[controller.currentIndex.value].tr,
                          key: ValueKey(controller.currentIndex.value),
                          style: Get.textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: controller.togglePause,
                            icon: Icon(controller.isPaused.value ? Icons.play_arrow : Icons.pause),
                            label: Text(controller.isPaused.value ? 'details.resume'.tr : 'details.pause'.tr),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: controller.previousInfo,
                            child: Text('details.previous'.tr),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: controller.nextInfo,
                            child: Text('details.next'.tr),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(controller.aiInfos.length, (index) {
                          final active = controller.currentIndex.value == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: active ? 18 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active ? Get.theme.colorScheme.primary : Get.theme.colorScheme.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Obx(() => ElevatedButton.icon(
                        onPressed: () {
                          final favorites = StorageService.to.getFavorites();
                          if (favorites.contains(item.id)) {
                            favorites.remove(item.id);
                            StorageService.to.saveFavorites(favorites);
                            isFavorite.value = false;
                            Get.snackbar('details.removeFromWishlist'.tr, item.titleAr);
                          } else {
                            favorites.add(item.id);
                            StorageService.to.saveFavorites(favorites);
                            isFavorite.value = true;
                            Get.snackbar('details.addedWishlist'.tr, item.titleAr);
                          }
                        },
                        icon: Icon(isFavorite.value ? Icons.favorite : Icons.favorite_border),
                        label: Text(isFavorite.value ? 'details.removeFromWishlist'.tr : 'details.addToWishlist'.tr),
                      )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar('details.placeBid'.tr, Helpers.formatCurrency(item.currentPrice),
                          snackPosition: SnackPosition.BOTTOM);
                    },
                    child: Text('details.placeBid'.tr),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('details.similar'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(3, (index) {
                return Chip(
                  avatar: const Icon(Icons.lightbulb_outline),
                  label: Text('category.${AppConstants.categoryIds[index % AppConstants.categoryIds.length]}'.tr),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/*
  هذا الملف يبني واجهة المفضلة مع إمكانية السحب للحذف والتحديث بالسحب.
  يمكن توسيعه لإضافة إشعارات توفر أو مشاركة العناصر مع الأصدقاء.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/utils/helpers.dart';
import '../../../data/models/item_model.dart';
import '../../../routes/app_routes.dart';
import '../../home/widgets/tender_card.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('wishlist.title'.tr)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(AppRoutes.home);
              break;
            case 2:
              Get.toNamed(AppRoutes.myBids);
              break;
            case 3:
              Get.toNamed(AppRoutes.settings);
              break;
            default:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'nav.home'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: 'nav.wishlist'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.local_offer), label: 'nav.mybids'.tr),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: 'nav.settings'.tr),
        ],
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.refreshFavorites,
            child: controller.items.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Center(child: Text('wishlist.empty'.tr)),
                    ],
                  )
                : PagedListView<int, ItemModel>(
                    pagingController: controller.pagingController,
                    padding: const EdgeInsets.all(16),
                    builderDelegate: PagedChildBuilderDelegate<ItemModel>(
                      itemBuilder: (context, item, index) {
                        return TenderCard(
                          item: item,
                          isFavorite: true,
                          countdown: item.isAuction && item.endTime != null
                              ? Helpers.formatCountdown(item.endTime!.difference(DateTime.now()))
                              : 'home.noCountdown'.tr,
                          onTap: () => Get.toNamed(AppRoutes.details, arguments: item),
                          onFavorite: () => controller.removeFavorite(item.id),
                          onBid: () {
                            Get.snackbar('details.placeBid'.tr, Helpers.formatCurrency(item.currentPrice));
                          },
                          onRemove: () => controller.removeFavorite(item.id),
                        );
                      },
                      noItemsFoundIndicatorBuilder: (_) => Center(child: Text('wishlist.empty'.tr)),
                    ),
                  ),
          )),
    );
  }
}

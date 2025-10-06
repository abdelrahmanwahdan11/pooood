/*
  هذا الملف يبني واجهة مزايداتي مع عرض قيم المزايدة وتحديث بالسحب.
  يمكن تطويره لإظهار حالة الفوز أو خيارات الدفع لاحقاً.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';
import '../controllers/mybids_controller.dart';

class MybidsView extends GetView<MybidsController> {
  const MybidsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('mybids.title'.tr)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(AppRoutes.home);
              break;
            case 1:
              Get.toNamed(AppRoutes.wishlist);
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
            onRefresh: controller.refreshBids,
            child: controller.bids.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Center(child: Text('mybids.empty'.tr)),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.bids.length,
                    itemBuilder: (context, index) {
                      final bid = controller.bids[index];
                      final item = controller.itemForBid(bid);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.gavel),
                          title: Text(item != null
                              ? (Get.locale?.languageCode == 'ar' ? item.titleAr : item.titleEn)
                              : 'home.title'.tr),
                          subtitle: Text('${'mybids.lastBid'.tr}: ${Helpers.formatCurrency(bid.amount)}'),
                          trailing: Text('${bid.createdAt.hour}:${bid.createdAt.minute.toString().padLeft(2, '0')}'),
                        ),
                      );
                    },
                  ),
          )),
    );
  }
}

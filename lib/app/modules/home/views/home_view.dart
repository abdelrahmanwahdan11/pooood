/*
  هذا الملف يبني واجهة الصفحة الرئيسية مع PageView رأسي وعناصر تفاعلية متعددة.
  يمكن تطويره لاحقاً لإضافة مصادر بيانات حقيقية أو عناصر واجهة أكثر تعقيداً.
*/
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../widgets/carousel_view.dart';
import '../widgets/small_category_title.dart';
import '../widgets/tender_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('home.title'.tr),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => _openFilters(context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.addItem),
            child: const Icon(Icons.add_circle_outline),
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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  ResponsiveBuilder(
                    builder: (context, sizing) {
                      final isTablet = sizing.deviceScreenType != DeviceScreenType.mobile;
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              decoration: InputDecoration(
                                hintText: 'home.search'.tr,
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: controller.searchController.text.isEmpty
                                    ? null
                                    : IconButton(
                                        onPressed: controller.resetFilters,
                                        icon: const Icon(Icons.clear),
                                      ),
                              ),
                            ),
                          ),
                          if (isTablet) const SizedBox(width: 12),
                          if (isTablet)
                            ElevatedButton.icon(
                              onPressed: () => _openFilters(context),
                              icon: const Icon(Icons.filter_alt_outlined),
                              label: Text('home.showFilters'.tr),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Get.theme.colorScheme.primary.withOpacity(0.1), Get.theme.colorScheme.secondary.withOpacity(0.15)],
                      ),
                    ),
                    child: Obx(() {
                          final primaryHex = Get.theme.colorScheme.primary.value
                              .toRadixString(16)
                              .padLeft(8, '0')
                              .substring(2);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.string(
                                '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path fill="#${primaryHex}" d="M12 2a10 10 0 100 20 10 10 0 000-20zm1 5v4.59l3.3 3.3-1.42 1.42L11 12.41V7h2z"/></svg>',
                                height: 32,
                              ),
                              Text('home.aiHighlight'.tr, style: Get.textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(controller.aiHighlight.value, style: Get.textTheme.bodyLarge),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(height: 12),
                  CarouselView(
                    items: controller.itemsForCategoryIndex(controller.currentCategoryIndex.value).take(5).toList(),
                    onTap: controller.openDetails,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.errorContainer.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('weak.connection'.tr, style: Get.textTheme.bodySmall),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.refreshData,
                      child: PageView.builder(
                        controller: controller.pageController,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        onPageChanged: controller.setCategory,
                        itemCount: AppConstants.categoryKeys.length,
                        itemBuilder: (context, index) {
                          final categoryItems = controller.itemsForCategoryIndex(index);
                          return FractionallySizedBox(
                            heightFactor: 0.9,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SmallCategoryTitle(
                                    titleKey: AppConstants.categoryKeys[index],
                                    isActive: controller.currentCategoryIndex.value == index,
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: categoryItems.isEmpty
                                        ? Center(child: Text('home.empty'.tr))
                                        : ListView.builder(
                                            physics: const BouncingScrollPhysics(),
                                            itemCount: categoryItems.length,
                                            itemBuilder: (context, itemIndex) {
                                              final item = categoryItems[itemIndex];
                                              return TenderCard(
                                                item: item,
                                                isFavorite: controller.isFavorite(item.id),
                                                countdown: controller.countdownFor(item),
                                                onTap: () => controller.openDetails(item),
                                                onFavorite: () => controller.toggleFavorite(item),
                                                onBid: () {
                                                  Get.snackbar('home.bidNow'.tr, Helpers.formatCurrency(item.currentPrice),
                                                      snackPosition: SnackPosition.BOTTOM);
                                                },
                                                onRemove: () => controller.removeItem(item),
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openFilters(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('home.priceRange'.tr, style: Get.textTheme.titleMedium),
            const SizedBox(height: 12),
            Obx(() => RangeSlider(
                  values: controller.priceRange.value,
                  min: 0,
                  max: 500000,
                  divisions: 10,
                  labels: RangeLabels(
                    controller.priceRange.value.start.toStringAsFixed(0),
                    controller.priceRange.value.end.toStringAsFixed(0),
                  ),
                  onChanged: controller.setPriceRange,
                )),
            const SizedBox(height: 12),
            Text('home.sortBy'.tr, style: Get.textTheme.titleMedium),
            Obx(() => Column(
                  children: [
                    RadioListTile<String>(
                      value: 'recent',
                      groupValue: controller.sortOption.value,
                      onChanged: (value) {
                        if (value != null) controller.setSortOption(value);
                      },
                      title: Text('home.sortRecent'.tr),
                    ),
                    RadioListTile<String>(
                      value: 'ending',
                      groupValue: controller.sortOption.value,
                      onChanged: (value) {
                        if (value != null) controller.setSortOption(value);
                      },
                      title: Text('home.sortEnding'.tr),
                    ),
                    RadioListTile<String>(
                      value: 'price',
                      groupValue: controller.sortOption.value,
                      onChanged: (value) {
                        if (value != null) controller.setSortOption(value);
                      },
                      title: Text('home.sortPrice'.tr),
                    ),
                  ],
                )),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.resetFilters,
                    child: Text('home.resetFilters'.tr),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text('settings.apply'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

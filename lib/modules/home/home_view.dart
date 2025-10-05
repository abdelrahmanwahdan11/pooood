import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/hard_shadow_box.dart';
import '../../main.dart';
import '../../models/product.dart';
import 'home_controller.dart';
import 'home_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const route = HomeRoutes.route;

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final palette = appController.palette;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('brand_title'.tr, style: theme.textTheme.displayLarge),
                        Text('brand_subtitle'.tr.toUpperCase(), style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      HardShadowBox(
                        backgroundColor: palette.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: controller.toggleLanguage,
                              child: const Icon(Icons.language, color: Colors.black),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: controller.toggleTheme,
                              child: const Icon(Icons.contrast, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      HardShadowBox(
                        backgroundColor: palette.chat,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: GestureDetector(
                          onTap: controller.openChat,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.chat_bubble, color: Colors.black),
                              const SizedBox(width: 8),
                              Text('chat'.tr, style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: Colors.black,
                onRefresh: controller.refresh,
                child: Obx(
                  () => CustomScrollView(
                    controller: controller.scrollController,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        sliver: SliverToBoxAdapter(
                          child: HardShadowBox(
                            backgroundColor: palette.surface,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('hero_new_arrivals'.tr, style: theme.textTheme.headlineMedium),
                                      const SizedBox(height: 4),
                                      Text('items_count'.trParams({'count': controller.products.length.toString()}), style: theme.textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: controller.openFeatureIdeas,
                                  child: HardShadowBox(
                                    backgroundColor: palette.card,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Text('ideas'.tr, style: theme.textTheme.bodySmall),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (controller.products.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text('empty_state'.tr, style: theme.textTheme.bodyMedium),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          sliver: SliverList.builder(
                            itemCount: controller.products.length + 1,
                            itemBuilder: (context, index) {
                              if (index == controller.products.length) {
                                if (!appController.hasMoreProducts.value) {
                                  return const SizedBox(height: 80);
                                }
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: SizedBox(
                                      height: 36,
                                      width: 36,
                                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                                    ),
                                  ),
                                );
                              }
                              final product = controller.products[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: _ProductCard(
                                  product: product,
                                  palette: palette,
                                  onTap: () => controller.openProduct(product),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) controller.openChat();
          if (index == 2) controller.openFeatureIdeas();
        },
        items: [
          BottomNavigationBarItem(icon: _navIcon(Icons.storefront, palette), label: 'market'.tr),
          BottomNavigationBarItem(icon: _navIcon(Icons.chat, palette), label: 'chat'.tr),
          BottomNavigationBarItem(icon: _navIcon(Icons.lightbulb, palette), label: 'ideas'.tr),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, ColorPalette palette) {
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(8),
      child: Icon(icon, color: Colors.black),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.palette, required this.onTap});

  final Product product;
  final ColorPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    return GestureDetector(
      onTap: onTap,
      child: HardShadowBox(
        backgroundColor: palette.card,
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Hero(
              tag: product.heroTag,
              child: HardShadowBox(
                backgroundColor: palette.surface,
                borderRadius: 24,
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    product.imageUrls.first,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name(locale).toUpperCase(), style: theme.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    product.description(locale),
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  HardShadowBox(
                    backgroundColor: palette.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text('\$${product.price.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_ios, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/hard_shadow_box.dart';
import '../../main.dart';
import '../../models/marketplace_meta.dart';
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
                        child: GestureDetector(
                          onTap: controller.toggleLanguage,
                          child: Icon(Icons.language, color: palette.highlight),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => MarketplaceThemeToggleButton(
                          isDark: appController.isMonochrome.value,
                          onToggle: controller.toggleTheme,
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
                  () {
                    appController.compareIds.length;
                    return CustomScrollView(
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
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              _buildFiltersSection(context, palette),
                              const SizedBox(height: 16),
                              _buildQuickActionsSection(context, palette),
                              const SizedBox(height: 16),
                              _buildTrustPreviewSection(context, palette),
                              const SizedBox(height: 16),
                              _buildHighlightsSection(context, palette),
                              const SizedBox(height: 16),
                              _buildLiveMomentsSection(context, palette),
                              const SizedBox(height: 16),
                              _buildCollectionsSection(context, palette),
                              const SizedBox(height: 16),
                              _buildCompareDrawer(context, palette),
                              const SizedBox(height: 8),
                            ],
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
                              final meta = controller.metaFor(product);
                              final isCompared = controller.isCompared(product);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: _ProductCard(
                                  product: product,
                                  palette: palette,
                                  meta: meta,
                                  isCompared: isCompared,
                                  onTap: () => controller.openProduct(product),
                                  onToggleCompare: () => controller.toggleCompare(product),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  },
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
          if (index == 3) controller.openTrustCenter();
        },
        items: [
          BottomNavigationBarItem(icon: _navIcon(Icons.storefront, palette), label: 'market'.tr),
          BottomNavigationBarItem(icon: _navIcon(Icons.chat, palette), label: 'chat'.tr),
          BottomNavigationBarItem(icon: _navIcon(Icons.lightbulb, palette), label: 'ideas'.tr),
          BottomNavigationBarItem(icon: _navIcon(Icons.verified, palette), label: 'trust_nav'.tr),
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

  Widget _buildFiltersSection(BuildContext context, ColorPalette palette) {
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    return Obx(
      () => HardShadowBox(
        backgroundColor: palette.surface,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('filters_title'.tr, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: controller.categories
                  .map(
                    (category) => GestureDetector(
                      onTap: () => controller.toggleCategory(category.id),
                      child: HardShadowBox(
                        backgroundColor: controller.selectedCategories.contains(category.id) ? palette.card : palette.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(category.label.resolve(locale), style: theme.textTheme.bodySmall),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: controller.cycleSort,
              child: HardShadowBox(
                backgroundColor: palette.card,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('sort_label'.trParams({'mode': controller.sortLabel}), style: theme.textTheme.bodySmall)),
                    const Icon(Icons.autorenew, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, ColorPalette palette) {
    final theme = Theme.of(context);
    return Obx(() {
      final saved = controller.hasSavedSearch;
      final actions = [
        {'id': 'trust', 'icon': Icons.verified, 'label': 'quick_action_trust'.tr, 'active': false},
        {'id': 'share', 'icon': Icons.ios_share, 'label': 'quick_action_share'.tr, 'active': false},
        {
          'id': 'save',
          'icon': saved ? Icons.bookmark_added : Icons.bookmark_border,
          'label': saved ? 'quick_action_saved'.tr : 'quick_action_save'.tr,
          'active': saved,
        },
      ];
      return HardShadowBox(
        backgroundColor: palette.surface,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('quick_actions_title'.tr, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            Row(
              children: List.generate(actions.length, (index) {
                final action = actions[index];
                final bool active = action['active'] as bool;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < actions.length - 1 ? 12 : 0),
                    child: GestureDetector(
                      onTap: () => controller.runQuickAction(action['id'] as String),
                      child: HardShadowBox(
                        backgroundColor: active ? palette.card : palette.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(action['icon'] as IconData, color: Colors.black),
                            const SizedBox(width: 8),
                            Flexible(child: Text(action['label'] as String, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTrustPreviewSection(BuildContext context, ColorPalette palette) {
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    final vendor = controller.vendors.first;
    final story = controller.trustStories.first;
    return GestureDetector(
      onTap: controller.openTrustCenter,
      child: HardShadowBox(
        backgroundColor: palette.card,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('trust_preview_title'.tr, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('trust_preview_subtitle'.tr, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Text(vendor.name.resolve(locale).toUpperCase(), style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(story.quote.resolve(locale), style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            HardShadowBox(
              backgroundColor: palette.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('trust_preview_cta'.tr, style: theme.textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightsSection(BuildContext context, ColorPalette palette) {
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('market_metrics_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          Row(
            children: controller.highlights
                .map(
                  (metric) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: HardShadowBox(
                        backgroundColor: palette.card,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(metric.value, style: theme.textTheme.titleLarge),
                            Text(metric.label.resolve(locale), style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMomentsSection(BuildContext context, ColorPalette palette) {
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('live_moments_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          ...controller.liveMoments.map(
            (moment) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(moment.resolve(locale), style: theme.textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsSection(BuildContext context, ColorPalette palette) {
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('collections_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('collections_subtitle'.tr, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.collections.map((collection) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => controller.openCollection(collection),
                    child: HardShadowBox(
                      backgroundColor: palette.card,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(collection.title.resolve(locale), style: theme.textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text(collection.description.resolve(locale), style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareDrawer(BuildContext context, ColorPalette palette) {
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    return Obx(() {
      controller.appController.compareIds.toList();
      final compare = controller.compareList;
      if (compare.isEmpty) return const SizedBox.shrink();
      final total = compare.fold<double>(0, (value, product) => value + product.price);
      final average = total / compare.length;
      return HardShadowBox(
        backgroundColor: palette.surface,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('compare_drawer_title'.tr, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: compare
                  .map(
                    (product) => HardShadowBox(
                      backgroundColor: palette.card,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(product.name(locale).toUpperCase(), style: theme.textTheme.bodySmall),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Text('compare_drawer_summary'.trParams({'count': compare.length.toString(), 'average': average.toStringAsFixed(1)}), style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: controller.openComparison,
              child: HardShadowBox(
                backgroundColor: palette.card,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.table_rows, color: Colors.black),
                    const SizedBox(width: 8),
                    Text('compare_drawer_cta'.tr, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.palette,
    required this.meta,
    required this.isCompared,
    required this.onTap,
    required this.onToggleCompare,
  });

  final Product product;
  final ColorPalette palette;
  final ProductMeta meta;
  final bool isCompared;
  final VoidCallback onTap;
  final VoidCallback onToggleCompare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    return GestureDetector(
      onTap: onTap,
      child: HardShadowBox(
        backgroundColor: palette.card,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                GestureDetector(
                  onTap: onToggleCompare,
                  child: HardShadowBox(
                    backgroundColor: isCompared ? palette.chat : palette.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      children: [
                        Icon(isCompared ? Icons.task_alt : Icons.balance, color: Colors.black),
                        const SizedBox(height: 4),
                        Text(isCompared ? 'compare_selected'.tr : 'compare_add'.tr, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: meta.tags
                  .map(
                    (tag) => HardShadowBox(
                      backgroundColor: palette.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text(tag.resolve(locale), style: theme.textTheme.bodySmall),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: meta.highlightMetrics
                  .map(
                    (metric) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: HardShadowBox(
                          backgroundColor: palette.surface,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(metric.value, style: theme.textTheme.titleMedium),
                              Text(metric.label.resolve(locale), style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

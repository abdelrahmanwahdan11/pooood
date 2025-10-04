import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/models/watch_item.dart';
import '../../data/repositories/watch_store_repo.dart';
import '../../core/routing/app_routes.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = Get.find<WatchStoreRepository>();
    final collections = repo.collections();
    final filters = repo.smartFilters();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppTheme.accentPrimary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBanner(controller: controller),
                  const SizedBox(height: 24),
                  TextField(
                    controller: controller.searchFieldController,
                    decoration: InputDecoration(
                      hintText: 'search_watches'.tr,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: Obx(
                        () => controller.searchQuery.value.isEmpty
                            ? const SizedBox.shrink()
                            : IconButton(
                                onPressed: () {
                                  controller.searchFieldController.clear();
                                  controller.onSearchChanged('');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    onChanged: controller.onSearchChanged,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final collection = collections[index];
                        return Obx(
                          () => ChoiceChip(
                            label: Text('collection_$collection'.tr),
                            selected: controller.activeCollection.value == collection,
                            onSelected: (_) => controller.onCollectionSelected(collection),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemCount: collections.length,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final filter in filters)
                        Obx(
                          () => FilterChip(
                            label: Text(filter.tr),
                            selected: controller.appliedFilters.contains(filter),
                            onSelected: (_) => controller.toggleFilter(filter),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => SizedBox(
                      height: 220,
                      child: controller.featuredItems.isEmpty
                          ? const SizedBox()
                          : PageView.builder(
                              controller: PageController(viewportFraction: 0.82),
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller.featuredItems.length,
                              itemBuilder: (context, index) {
                                final item = controller.featuredItems[index];
                                return _FeaturedCard(item: item, controller: controller)
                                    .animate()
                                    .fadeIn(delay: Duration(milliseconds: index * 60))
                                    .scale(begin: const Offset(0.95, 0.95));
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('recommendations'.tr, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            PagedSliverList<int, WatchItem>(
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<WatchItem>(
                animateTransitions: true,
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _WatchTile(item: item, controller: controller),
                  );
                },
                noItemsFoundIndicatorBuilder: (_) => _EmptyState(message: 'empty_catalog'.tr),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: 32,
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        colors: [
          const Color(0xFF63F5C6),
          const Color(0xFF5AE0FF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text('hero_badge'.tr, style: theme.textTheme.labelLarge),
              ),
              const Spacer(),
              IconButton(
                onPressed: controller.refresh,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('hero_title'.tr, style: theme.textTheme.headlineSmall?.copyWith(color: AppTheme.accentPrimary)),
          const SizedBox(height: 8),
          Text('hero_subtitle'.tr, style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.onSurface.withOpacity(0.7))),
          const SizedBox(height: 16),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.32),
              borderRadius: BorderRadius.circular(28),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.watch_rounded, size: 120, color: AppTheme.accentPrimary.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item, required this.controller});

  final WatchItem item;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        controller.recordView(item);
        Get.toNamed(AppRoutes.watchDetails, arguments: item.id);
      },
      child: GlassContainer(
        borderRadius: 28,
        padding: const EdgeInsets.all(20),
        gradient: LinearGradient(
          colors: [
            item.imagePlaceholder.withOpacity(0.9),
            item.imagePlaceholder.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (item.badge != null)
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(item.badge!.tr, style: theme.textTheme.labelMedium?.copyWith(color: AppTheme.onSurface)),
                  ),
                const Spacer(),
                Obx(
                  () => IconButton(
                    onPressed: () => controller.toggleFavorite(item),
                    icon: Icon(
                      controller.isFavorite(item)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(item.name, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
            Text(item.brand, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _WatchTile extends StatelessWidget {
  const _WatchTile({required this.item, required this.controller});

  final WatchItem item;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        controller.recordView(item);
        Get.toNamed(AppRoutes.watchDetails, arguments: item.id);
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 26,
        child: Row(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: item.imagePlaceholder,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.watch_rounded, size: 72, color: Colors.white.withOpacity(0.9)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.name, style: theme.textTheme.titleMedium),
                      ),
                      Icon(Icons.star_rate_rounded, color: Colors.amber.shade400, size: 18),
                      const SizedBox(width: 4),
                      Text(item.rating.toStringAsFixed(1), style: theme.textTheme.bodyMedium),
                    ],
                  ),
                  Text('${item.brand} • ${item.collection.tr}', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: item.highlights.take(2)
                        .map((highlight) => _Tag(label: highlight))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('${item.price.toStringAsFixed(0)} ${'currency_label'.tr}',
                          style: theme.textTheme.titleMedium?.copyWith(color: AppTheme.accentPrimary)),
                      if (item.oldPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          item.oldPrice!.toStringAsFixed(0),
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.watchDetails, arguments: item.id);
                        },
                        child: Text('view_details'.tr),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty_rounded, size: 64, color: AppTheme.accentPrimary.withOpacity(0.8)),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

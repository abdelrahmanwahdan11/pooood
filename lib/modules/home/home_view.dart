import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/countdown_timer.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/shimmer_loader.dart';
import '../../data/models/auction.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          child: Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : IndexedStack(
                    index: controller.currentIndex.value,
                    children: [
                      _TrendTab(controller: controller),
                      _AuctionsTab(controller: controller),
                      _DealsTab(controller: controller),
                      _CategoriesTab(controller: controller),
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.trending_up), label: 'trending'.tr),
              BottomNavigationBarItem(icon: const Icon(Icons.gavel_outlined), label: 'auctions'.tr),
              BottomNavigationBarItem(icon: const Icon(Icons.flash_on), label: 'deals'.tr),
              BottomNavigationBarItem(icon: const Icon(Icons.category_outlined), label: 'categories'.tr),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.search),
          label: Text('search'.tr),
          icon: const Icon(Icons.search),
        ),
      ),
    );
  }
}

class _TrendTab extends StatelessWidget {
  const _TrendTab({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: controller.loadHome,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('trend_feed'.tr, style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: Obx(
                      () => ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text('see_all'.tr),
                              selected: controller.selectedCategoryId.value == null,
                              onSelected: (_) => controller.filterByCategory(null),
                            ),
                          ),
                          ...controller.categories.map(
                            (category) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(category.name),
                                selected: controller.selectedCategoryId.value == category.id,
                                onSelected: (_) => controller.filterByCategory(category.id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= controller.trendingProducts.length) {
                      return const ShimmerLoader();
                    }
                    final product = controller.trendingProducts[index];
                    return ProductCard(
                      product: product,
                      showTrend: true,
                      showDeal: controller.deals.any((d) => d.productId == product.id),
                      showAuction: controller.auctionItems.any((a) => a.productId == product.id),
                      onTap: () => Get.toNamed('${AppRoutes.product}/${product.id}'),
                    );
                  },
                  childCount: controller.trendingProducts.isEmpty ? 4 : controller.trendingProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('best_sellers'.tr, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemCount: controller.trendingProducts.take(5).length,
                      itemBuilder: (context, index) {
                        final product = controller.trendingProducts[index];
                        return SizedBox(
                          width: 180,
                          child: ProductCard(
                            product: product,
                            showTrend: true,
                            onTap: () => Get.toNamed('${AppRoutes.product}/${product.id}'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuctionsTab extends StatelessWidget {
  const _AuctionsTab({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.loadHome,
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: controller.auctionItems.length,
        itemBuilder: (context, index) {
          final auction = controller.auctionItems[index];
          return _AuctionCard(auction: auction);
        },
      ),
    );
  }
}

class _DealsTab extends StatelessWidget {
  const _DealsTab({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: controller.loadHome,
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: controller.deals.length,
        itemBuilder: (context, index) {
          final deal = controller.deals[index];
          final product = controller.trendingProducts.firstWhereOrNull((p) => p.id == deal.productId);
          if (product == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassContainer(
              child: ListTile(
                title: Text(product.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('deals_feed'.tr, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    CountdownTimer(
                      endAt: deal.endAt,
                      textStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary),
                    ),
                  ],
                ),
                trailing: Text('-${deal.discountPct.toStringAsFixed(0)}%'),
                onTap: () => Get.toNamed('${AppRoutes.product}/${product.id}'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
              Icon(Icons.category_outlined, size: 42, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(category.name, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        );
      },
    );
  }
}

class _AuctionCard extends StatelessWidget {
  const _AuctionCard({required this.auction});

  final Auction auction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${'current_bid'.tr}: ${formatCurrency(
                      auction.currentBid,
                      locale: Get.locale?.languageCode ?? 'en',
                      currency: currentCurrency(),
                    )}'),
                Text('${'bidders_count'.tr}: ${auction.biddersCount}', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Text('auction_join_hint'.tr, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            CountdownTimer(
              endAt: auction.endAt,
              textStyle: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.secondary),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.toNamed('${AppRoutes.auction}/${auction.id}'),
                child: Text('bid_now'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

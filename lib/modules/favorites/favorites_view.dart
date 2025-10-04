import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/routing/app_routes.dart';
import 'favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: controller.loadFavorites,
        child: Obx(
          () => controller.items.isEmpty
              ? ListView(
                  children: [
                    const SizedBox(height: 120),
                    Icon(Icons.favorite_border_rounded,
                        size: 64, color: AppTheme.accentPrimary.withOpacity(0.7)),
                    const SizedBox(height: 12),
                    Text(
                      'favorites_empty'.tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return GlassContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: 26,
                      child: Row(
                        children: [
                          Container(
                            height: 92,
                            width: 92,
                            decoration: BoxDecoration(
                              color: item.imagePlaceholder,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.watch_rounded,
                                size: 56, color: Colors.white.withOpacity(0.9)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                                Text(item.brand, style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 8),
                                Text('${item.price.toStringAsFixed(0)} ${'currency_label'.tr}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: AppTheme.accentPrimary)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () => controller.toggleFavorite(item),
                                icon: const Icon(Icons.delete_outline_rounded),
                              ),
                              const SizedBox(height: 8),
                              FilledButton.tonal(
                                onPressed: () => Get.toNamed(AppRoutes.watchDetails, arguments: item.id),
                                child: Text('view_details'.tr),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
                  },
                ),
        ),
      ),
    );
  }
}

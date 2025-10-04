import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/models/watch_item.dart';
import 'watch_detail_controller.dart';

class WatchDetailView extends GetView<WatchDetailController> {
  const WatchDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('watch_details'.tr),
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.toggleFavorite,
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          final item = controller.watch.value;
          if (item == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroPreview(item: item, controller: controller),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(item.brand, style: theme.textTheme.labelLarge),
                    const SizedBox(width: 12),
                    Icon(Icons.star_rounded, color: Colors.amber.shade400),
                    const SizedBox(width: 4),
                    Text(item.rating.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item.name, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(item.description, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 16),
                Text('available_colors'.tr, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Obx(
                  () => Row(
                    children: [
                      for (int index = 0; index < item.colors.length; index++)
                        GestureDetector(
                          onTap: () => controller.selectColor(index),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: item.colors[index],
                              borderRadius: BorderRadius.circular(18),
                              border: controller.colorIndex.value == index
                                  ? Border.all(color: AppTheme.accentPrimary, width: 3)
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('wrist_sizes'.tr, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    children: item.wristSizes
                        .map(
                          (size) => ChoiceChip(
                            label: Text(size),
                            selected: controller.selectedSize.value == size,
                            onSelected: (_) => controller.selectSize(size),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Text('key_highlights'.tr, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                ...item.highlights
                    .map(
                      (highlight) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppTheme.accentPrimary, size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(highlight)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: 16),
                Text('specifications'.tr, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: item.specs.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text('spec_${entry.key}'.tr, style: theme.textTheme.bodyMedium),
                                const Spacer(),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    entry.value,
                                    textAlign: TextAlign.end,
                                    style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.onSurface.withOpacity(0.7)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),
                _ExperienceSection(item: item, controller: controller),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Obx(
        () {
          final item = controller.watch.value;
          if (item == null) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('total'.tr, style: Theme.of(context).textTheme.labelMedium),
                      Text('${item.price.toStringAsFixed(0)} ${'currency_label'.tr}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.accentPrimary)),
                    ],
                  ),
                  const Spacer(),
                  Obx(
                    () => FilledButton(
                      onPressed: controller.isProcessing.value ? null : controller.addToCart,
                      child: controller.isProcessing.value
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('add_to_cart'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: controller.startAppointment,
                    child: Text('book_appointment'.tr),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroPreview extends StatelessWidget {
  const _HeroPreview({required this.item, required this.controller});

  final WatchItem item;
  final WatchDetailController controller;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 36,
      padding: const EdgeInsets.all(32),
      gradient: LinearGradient(
        colors: [
          item.imagePlaceholder.withOpacity(0.92),
          item.imagePlaceholder.withOpacity(0.68),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(item.collection.tr),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(32),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.watch_rounded, size: 160, color: Colors.white.withOpacity(0.95)),
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
        ],
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({required this.item, required this.controller});

  final WatchItem item;
  final WatchDetailController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final experiences = [
      'experience_tryon'.tr,
      'experience_tradein'.tr,
      'experience_plan'.tr,
      'experience_warranty'.tr,
      'experience_pickup'.tr,
      'experience_companion'.tr,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('experience_title'.tr, style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: experiences
              .map(
                (exp) => GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: AppTheme.accentPrimary),
                      const SizedBox(width: 8),
                      Text(exp, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

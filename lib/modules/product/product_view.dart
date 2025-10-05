import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/widgets/hard_shadow_box.dart';
import '../../main.dart';
import '../../models/product.dart';
import 'product_routes.dart';
import 'product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  static const route = ProductRoutes.route;

  @override
  Widget build(BuildContext context) {
    final palette = Get.find<AppController>().palette;
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        title: Text(controller.product.name(locale).toUpperCase()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HardShadowBox(
              backgroundColor: palette.card,
              padding: const EdgeInsets.all(18),
              child: Hero(
                tag: controller.product.heroTag,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 280,
                    viewportFraction: 1,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    onPageChanged: controller.updateCarousel,
                  ),
                  items: controller.product.imageUrls
                      .map(
                        (url) => HardShadowBox(
                          backgroundColor: palette.surface,
                          borderRadius: 32,
                          padding: const EdgeInsets.all(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.product.imageUrls.length,
                  (index) => Container(
                    height: 12,
                    width: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == controller.carouselIndex.value ? Colors.black : Colors.black.withOpacity(0.2),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FlipCard(
              front: HardShadowBox(
                backgroundColor: palette.card,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('details'.tr, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    Text(controller.product.description(locale), style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              back: HardShadowBox(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('features'.tr, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    ...controller.product
                        .features(locale)
                        .map((feature) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text('- $feature', style: theme.textTheme.bodyMedium),
                            )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTagWrap(theme, palette, locale),
            const SizedBox(height: 24),
            HardShadowBox(
              backgroundColor: palette.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('rating'.tr, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Obx(
                    () => Slider(
                      min: 0,
                      max: 5,
                      divisions: 20,
                      value: controller.rating.value,
                      onChanged: controller.updateRating,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildActionRow(theme, palette),
            const SizedBox(height: 24),
            _buildCartRow(theme, palette),
            const SizedBox(height: 24),
            _buildSpecSheet(theme, palette, locale),
            const SizedBox(height: 24),
            _buildMetricsSection(theme, palette, locale),
            const SizedBox(height: 24),
            _buildBreakdownSection(theme, palette, locale),
            const SizedBox(height: 24),
            _buildShippingSection(theme, palette, locale),
            const SizedBox(height: 24),
            _buildVendorSection(theme, palette, locale),
            const SizedBox(height: 24),
            _buildSustainabilitySection(theme, palette, locale),
            const SizedBox(height: 24),
            _buildAccessoriesSection(theme, palette, locale),
            const SizedBox(height: 24),
            _buildTestimonialsSection(theme, palette, locale),
            const SizedBox(height: 24),
            _buildQaSection(theme, palette, locale),
            const SizedBox(height: 24),
            _buildCelebrationSection(palette),
          ],
        ),
      ),
    );
  }

  Widget _buildTagWrap(ThemeData theme, ColorPalette palette, Locale locale) {
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: controller.meta.tags
            .map(
              (tag) => HardShadowBox(
                backgroundColor: palette.card,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(tag.resolve(locale), style: theme.textTheme.bodySmall),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildActionRow(ThemeData theme, ColorPalette palette) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: controller.shareProduct,
            child: HardShadowBox(
              backgroundColor: palette.surface,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const Icon(Icons.ios_share, color: Colors.black),
                  const SizedBox(height: 6),
                  Text('share_product_button'.tr, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(
            () {
              final compared = controller.isCompared();
              return GestureDetector(
                onTap: controller.toggleCompare,
                child: HardShadowBox(
                  backgroundColor: compared ? palette.chat : palette.surface,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Icon(compared ? Icons.task_alt : Icons.balance, color: Colors.black),
                      const SizedBox(height: 6),
                      Text(compared ? 'compare_selected'.tr : 'compare_add'.tr, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: controller.requestRestock,
            child: HardShadowBox(
              backgroundColor: palette.surface,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const Icon(Icons.notifications_active, color: Colors.black),
                  const SizedBox(height: 6),
                  Text('restock_alert_button'.tr, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartRow(ThemeData theme, ColorPalette palette) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: controller.toggleCart,
            child: HardShadowBox(
              backgroundColor: palette.card,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text('add_to_cart'.tr, style: theme.textTheme.bodyMedium),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: controller.toggleFavorite,
            child: HardShadowBox(
              backgroundColor: palette.chat,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text('add_to_favorites'.tr, style: theme.textTheme.bodyMedium),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecSheet(ThemeData theme, ColorPalette palette, Locale locale) {
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('spec_sheet_title'.tr, style: theme.textTheme.headlineMedium),
              GestureDetector(
                onTap: controller.downloadSpecs,
                child: HardShadowBox(
                  backgroundColor: palette.card,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.download, color: Colors.black),
                      const SizedBox(width: 6),
                      Text('spec_download_cta'.tr, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...controller.meta.specLines.map(
            (line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(line.resolve(locale), style: theme.textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(ThemeData theme, ColorPalette palette, Locale locale) {
    return HardShadowBox(
      backgroundColor: palette.card,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('product_metrics_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          Row(
            children: controller.meta.highlightMetrics
                .map(
                  (metric) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: HardShadowBox(
                        backgroundColor: palette.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  Widget _buildBreakdownSection(ThemeData theme, ColorPalette palette, Locale locale) {
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('price_breakdown_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          ...controller.meta.breakdown.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(item.label.resolve(locale), style: theme.textTheme.bodySmall)),
                  HardShadowBox(
                    backgroundColor: palette.card,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(item.value, style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingSection(ThemeData theme, ColorPalette palette, Locale locale) {
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('delivery_timeline_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          ...controller.meta.shippingSteps.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  HardShadowBox(
                    backgroundColor: palette.card,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text('${entry.key + 1}', style: theme.textTheme.bodySmall),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.value.label.resolve(locale), style: theme.textTheme.bodySmall),
                        Text(entry.value.detail.resolve(locale), style: theme.textTheme.bodySmall),
                      ],
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

  Widget _buildVendorSection(ThemeData theme, ColorPalette palette, Locale locale) {
    return HardShadowBox(
      backgroundColor: palette.card,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('vendor_profile_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(controller.vendor.name.resolve(locale), style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(controller.vendor.location.resolve(locale), style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Text(controller.vendor.story.resolve(locale), style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: controller.vendor.focusAreas
                .map((focus) => HardShadowBox(
                      backgroundColor: palette.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text(focus.resolve(locale), style: theme.textTheme.bodySmall),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Text('${'vendor_rating_label'.tr}: ${controller.vendor.rating.toStringAsFixed(1)}', style: theme.textTheme.bodySmall),
          Text('${'vendor_since_label'.tr}: ${controller.vendor.since}', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildSustainabilitySection(ThemeData theme, ColorPalette palette, Locale locale) {
    final sustainabilityPercent = (controller.meta.sustainabilityScore * 100).toStringAsFixed(0);
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('sustainability_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('sustainability_score_label'.trParams({'value': sustainabilityPercent}), style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(controller.meta.sustainabilityNote.resolve(locale), style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Text('materials_title'.tr, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...controller.meta.materials.map(
            (material) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(material.resolve(locale), style: theme.textTheme.bodySmall),
            ),
          ),
          const SizedBox(height: 12),
          Text(controller.meta.guarantee.resolve(locale), style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildAccessoriesSection(ThemeData theme, ColorPalette palette, Locale locale) {
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('accessories_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          ...controller.meta.accessories.map(
            (accessory) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('• ${accessory.resolve(locale)}', style: theme.textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(ThemeData theme, ColorPalette palette, Locale locale) {
    return HardShadowBox(
      backgroundColor: palette.card,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('testimonials_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          ...controller.stories.map(
            (story) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.quote.resolve(locale), style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text('${story.author.resolve(locale)} · ${story.role.resolve(locale)}', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQaSection(ThemeData theme, ColorPalette palette, Locale locale) {
    return HardShadowBox(
      backgroundColor: palette.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('questions_title'.tr, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          ...controller.qa.asMap().entries.map(
            (entry) => Obx(
              () {
                final expanded = controller.expandedQa.contains(entry.key);
                return GestureDetector(
                  onTap: () => controller.toggleQuestion(entry.key),
                  child: HardShadowBox(
                    backgroundColor: expanded ? palette.card : palette.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(entry.value.question.resolve(locale), style: theme.textTheme.bodySmall)),
                            Icon(expanded ? Icons.remove : Icons.add, color: Colors.black),
                          ],
                        ),
                        if (expanded) ...[
                          const SizedBox(height: 8),
                          Text(entry.value.answer.resolve(locale), style: theme.textTheme.bodySmall),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text('questions_hint'.tr, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildCelebrationSection(ColorPalette palette) {
    return HardShadowBox(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 180,
        child: Lottie.asset('assets/celebration.json'),
      ),
    );
  }
}

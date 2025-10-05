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
            Row(
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
            ),
            const SizedBox(height: 24),
            HardShadowBox(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 180,
                child: Lottie.asset('assets/celebration.json'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

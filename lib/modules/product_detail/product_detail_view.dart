import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routing/app_routes.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/shimmer_loader.dart';
import '../../data/models/product.dart';
import '../../data/models/store_location.dart';
import 'product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(controller.product.value?.title ?? '...')),
          actions: [
            Obx(
              () => IconButton(
                onPressed: controller.toggleFavorite,
                icon: Icon(controller.isFavorite.value ? Icons.favorite : Icons.favorite_border),
              ),
            ),
          ],
        ),
        body: Obx(
          () {
            final product = controller.product.value;
            if (product == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProductGallery(product: product),
                  const SizedBox(height: 24),
                  Text(product.title, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Text('${product.brand} • ${product.rating.toStringAsFixed(1)}★'),
                  const SizedBox(height: 12),
                  Obx(
                    () => Text(
                      '${'estimated_price'.tr}: ${formatCurrency(
                        controller.estimatedPrice.value,
                        locale: Get.locale?.languageCode ?? 'en',
                        currency: currentCurrency(),
                      )}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'price_alerts'.tr,
                    icon: Icons.notifications_active_outlined,
                    onPressed: () => Get.bottomSheet(
                      PriceAlertSheet(
                        onSave: controller.createPriceAlert,
                        currentPrice: controller.estimatedPrice.value,
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('nearby_stores'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Obx(
                    () => Column(
                      children: controller.nearbyStores
                          .map((store) => _StoreTile(store: store))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('similar_items'.tr, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Obx(
                    () => SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemCount: controller.similarProducts.length,
                        itemBuilder: (context, index) {
                          final similar = controller.similarProducts[index];
                          return SizedBox(
                            width: 200,
                            child: ProductCard(
                              product: similar,
                              showTrend: true,
                              onTap: () => Get.toNamed('${AppRoutes.product}/${similar.id}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProductGallery extends StatelessWidget {
  const _ProductGallery({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: PageView.builder(
        itemCount: product.images.length,
        itemBuilder: (context, index) {
          final image = product.images[index];
          return Hero(
            tag: '${product.id}_$index',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerLoader(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StoreTile extends StatelessWidget {
  const _StoreTile({required this.store});

  final StoreLocation store;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        child: ListTile(
          title: Text(store.name),
          subtitle: Text(store.availability ? 'status_online'.tr : 'status_offline'.tr),
          trailing: Text(formatCurrency(
            store.price,
            locale: Get.locale?.languageCode ?? 'en',
            currency: currentCurrency(),
          )),
        ),
      ),
    );
  }
}

class PriceAlertSheet extends StatefulWidget {
  const PriceAlertSheet({super.key, required this.onSave, required this.currentPrice});

  final void Function(double price) onSave;
  final double currentPrice;

  @override
  State<PriceAlertSheet> createState() => _PriceAlertSheetState();
}

class _PriceAlertSheetState extends State<PriceAlertSheet> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.currentPrice.toStringAsFixed(0));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.7,
        builder: (context, scrollController) {
          return GlassContainer(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            child: ListView(
              controller: scrollController,
              children: [
                Text('price_alert_title'.tr, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('price_alert_description'.tr, style: theme.textTheme.bodySmall),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'target_price'.tr,
                    prefixIcon: const Icon(Icons.price_change_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'save'.tr,
                  onPressed: () {
                    final value = double.tryParse(controller.text);
                    if (value != null) {
                      widget.onSave(value);
                      Get.back();
                    }
                  },
                ),
                const SizedBox(height: 12),
                // TODO: Firebase
                // 1) بعد الحفظ المحلي، حفظ التنبيه في Firestore مع uid.
                // 2) تفعيل Cloud Function لفحص الأسعار وإرسال إشعار عبر FCM.
              ],
            ),
          );
        },
      ),
    );
  }
}

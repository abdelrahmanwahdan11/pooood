import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/hard_shadow_box.dart';
import '../../main.dart';
import '../../models/locale_text.dart';
import '../../models/marketplace_meta.dart';
import '../../models/product.dart';
import '../chat/chat_routes.dart';
import '../product/product_routes.dart';
import '../trust/trust_routes.dart';
import 'home_routes.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  AppController get appController => Get.find<AppController>();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_handleScroll);
  }

  List<Product> get products => appController.visibleProducts;
  List<CategoryTag> get categories => appController.categoryTags;
  Set<String> get selectedCategories => appController.selectedCategories;
  String get sortLabel => appController.sortLabel;
  List<HighlightMetric> get highlights => appController.marketHighlights;
  List<LocaleText> get liveMoments => appController.liveMoments;
  List<MarketplaceCollection> get collections => appController.collections;
  List<Product> get compareList => appController.compareProducts();
  bool get hasSavedSearch => appController.hasSavedSearch.value;
  List<MarketplaceStory> get trustStories => appController.trustStories;
  List<Vendor> get vendors => appController.vendors;

  Future<void> refresh() async {
    await appController.refreshProducts();
  }

  void _handleScroll() {
    if (scrollController.position.extentAfter < 300 && appController.hasMoreProducts.value) {
      appController.loadMore();
    }
  }

  void toggleTheme() => appController.toggleTheme();

  void toggleLanguage() => appController.toggleLanguage();

  void openProduct(Product product) {
    Get.toNamed(ProductRoutes.route, arguments: product);
  }

  void openChat() => Get.toNamed(ChatRoutes.route);

  void openFeatureIdeas() => Get.toNamed(HomeRoutes.ideasRoute);

  void openTrustCenter() => Get.toNamed(TrustRoutes.route);

  void toggleCategory(String id) => appController.toggleCategory(id);

  void cycleSort() => appController.cycleSortMode();

  ProductMeta metaFor(Product product) => appController.metaFor(product.id);

  bool isCompared(Product product) => appController.isCompared(product);

  Future<void> toggleCompare(Product product) => appController.toggleCompare(product);

  List<Product> collectionPreview(MarketplaceCollection collection) => appController.collectionProducts(collection);

  Future<void> runQuickAction(String id) async {
    if (id == 'trust') {
      openTrustCenter();
      return;
    }
    if (id == 'share') {
      appController.shareMarketplace();
      return;
    }
    if (id == 'save') {
      await appController.toggleSavedSearch();
      return;
    }
  }

  void openComparison() {
    final items = compareList;
    if (items.isEmpty) return;
    final palette = appController.palette;
    Get.dialog(
      Center(
        child: HardShadowBox(
          backgroundColor: palette.surface,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('compare_drawer_title'.tr, style: Get.textTheme.headlineMedium),
              const SizedBox(height: 12),
              ...items.map(
                (product) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(product.name(Get.locale ?? const Locale('en')).toUpperCase(), style: Get.textTheme.bodyMedium),
                ),
              ),
              const SizedBox(height: 12),
              Text('compare_dialog_hint'.tr, style: Get.textTheme.bodySmall),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.55),
    );
  }

  void openCollection(MarketplaceCollection collection) {
    final items = collectionPreview(collection);
    final palette = appController.palette;
    final locale = Get.locale ?? const Locale('en');
    Get.dialog(
      Center(
        child: HardShadowBox(
          backgroundColor: palette.surface,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(collection.title.resolve(locale), style: Get.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(collection.description.resolve(locale), style: Get.textTheme.bodySmall),
              const SizedBox(height: 12),
              ...items.map(
                (product) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(product.name(locale), style: Get.textTheme.bodyMedium),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.55),
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

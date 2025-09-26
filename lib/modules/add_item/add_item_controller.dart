import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/validators.dart';
import '../../data/db/app_db.dart';
import '../../data/models/auction.dart';
import '../../data/models/discount_deal.dart';
import '../../data/models/product.dart';
import '../../data/repositories/settings_repo.dart';
import '../auction_home/auction_controller.dart';
import '../discounts_nearby/discounts_controller.dart';
import '../explore/explore_controller.dart';

class AddItemController extends GetxController {
  AddItemController(this.database, this.settingsRepository);

  final AppDatabase database;
  final SettingsRepository settingsRepository;

  final auctionFormKey = GlobalKey<FormState>();
  final discountFormKey = GlobalKey<FormState>();

  final auctionTitle = TextEditingController();
  final auctionCategory = TextEditingController();
  final auctionCondition = TextEditingController();
  final startPrice = TextEditingController();
  final minIncrement = TextEditingController(text: '100');
  final reservePrice = TextEditingController();
  final startTime = TextEditingController();
  final endTime = TextEditingController();
  final pickupInfo = TextEditingController();
  final auctionImages = TextEditingController();
  final locationText = TextEditingController();
  final terms = TextEditingController();

  final discountStore = TextEditingController();
  final discountProduct = TextEditingController();
  final discountCategory = TextEditingController();
  final discountPercent = TextEditingController();
  final discountOriginal = TextEditingController();
  final discountValidFrom = TextEditingController();
  final discountValidUntil = TextEditingController();
  final discountImages = TextEditingController();
  final discountLocation = TextEditingController();
  final discountTerms = TextEditingController();

  @override
  void onClose() {
    auctionTitle.dispose();
    auctionCategory.dispose();
    auctionCondition.dispose();
    startPrice.dispose();
    minIncrement.dispose();
    reservePrice.dispose();
    startTime.dispose();
    endTime.dispose();
    pickupInfo.dispose();
    auctionImages.dispose();
    locationText.dispose();
    terms.dispose();
    discountStore.dispose();
    discountProduct.dispose();
    discountCategory.dispose();
    discountPercent.dispose();
    discountOriginal.dispose();
    discountValidFrom.dispose();
    discountValidUntil.dispose();
    discountImages.dispose();
    discountLocation.dispose();
    discountTerms.dispose();
    super.onClose();
  }

  Future<void> submitAuction() async {
    if (!(auctionFormKey.currentState?.validate() ?? false)) {
      return;
    }
    final productId = DateTime.now().millisecondsSinceEpoch;
    final combinedTerms = [
      terms.text,
      if (reservePrice.text.isNotEmpty)
        '${'reserve_price'.tr}: ${reservePrice.text}',
      if (pickupInfo.text.isNotEmpty)
        '${'pickup_shipping'.tr}: ${pickupInfo.text}',
    ].where((element) => element.trim().isNotEmpty).join('\n');

    final product = Product(
      id: productId,
      title: auctionTitle.text,
      category: auctionCategory.text,
      condition: auctionCondition.text,
      images: _parseImages(auctionImages.text),
      location: locationText.text,
      description: combinedTerms,
    );
    await database.db.insert('products', product.toMap());

    final start = DateTime.tryParse(startTime.text) ?? DateTime.now();
    final end = DateTime.tryParse(endTime.text) ?? start.add(const Duration(days: 3));
    final auction = Auction(
      id: productId,
      productId: productId,
      sellerName: settingsRepository.currentLocale.languageCode == 'ar'
          ? 'أنا'
          : 'Me',
      sellerArea: locationText.text.isEmpty ? 'City Center' : locationText.text,
      distanceKm: 2.4,
      currentPrice: double.tryParse(startPrice.text) ?? 0,
      minIncrement: double.tryParse(minIncrement.text) ?? 0,
      watchers: 0,
      views: 0,
      startTime: start,
      endTime: end,
      ownerId: 1,
      isFavorite: false,
    );
    await database.db.insert('auctions', auction.toMap());
    Get.find<AuctionController>().loadAuctions();
    Get.find<ExploreController>().load();
    Get.back();
    Get.snackbar('app_name'.tr, 'auction_published'.tr,
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> submitDiscount() async {
    if (!(discountFormKey.currentState?.validate() ?? false)) {
      return;
    }
    final discountId = DateTime.now().millisecondsSinceEpoch;
    final validFrom = DateTime.tryParse(discountValidFrom.text) ??
        DateTime.now();
    final validUntil = DateTime.tryParse(discountValidUntil.text) ??
        validFrom.add(const Duration(days: 7));
    final discount = DiscountDeal(
      id: discountId,
      storeName: discountStore.text,
      product: discountProduct.text,
      category: discountCategory.text,
      discountPercent: double.tryParse(discountPercent.text) ?? 0,
      originalPrice: double.tryParse(discountOriginal.text) ?? 0,
      distanceKm: 1.8,
      location: discountLocation.text,
      validFrom: validFrom,
      validUntil: validUntil,
      terms: discountTerms.text,
      images: _parseImages(discountImages.text),
      ownerId: 1,
    );
    await database.db.insert('discounts', discount.toMap());
    Get.find<DiscountsController>().loadDiscounts();
    Get.find<ExploreController>().load();
    Get.back();
    Get.snackbar('app_name'.tr, 'discount_published'.tr,
        snackPosition: SnackPosition.BOTTOM);
  }

  List<String> _parseImages(String raw) {
    return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  String? validateRequired(String? value) => Validators.requiredField(value);
  String? validateNumber(String? value) => Validators.positiveNumber(value);
}

/*
  هذا الملف يدير بيانات واجهة الرئيسية بما في ذلك العناصر والفلاتر والمفضلة والتفاعل.
  يمكن تطويره لإضافة تكاملات حية أو مزامنة مع خوادم حقيقية بسهولة.
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/item_model.dart';
import '../../../data/services/ai_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final pageController = PageController(viewportFraction: 0.9);
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  final priceRange = const RangeValues(0, 500000).obs;
  final sortOption = 'recent'.obs;
  final isRefreshing = false.obs;
  final favorites = <String>[].obs;
  final items = <ItemModel>[].obs;
  final currentCategoryIndex = 0.obs;
  final aiHighlight = ''.obs;
  final tutorialShown = false.obs;

  Timer? _aiTimer;

  List<ItemModel> get filteredItems {
    final category = AppConstants.categoryIds[currentCategoryIndex.value];
    return items.where((item) {
      final matchesCategory = item.category == category;
      final query = searchController.text.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          item.titleAr.toLowerCase().contains(query) ||
          item.titleEn.toLowerCase().contains(query);
      final matchesPrice = item.currentPrice >= priceRange.value.start && item.currentPrice <= priceRange.value.end;
      return matchesCategory && matchesQuery && matchesPrice;
    }).toList()
      ..sort((a, b) {
        switch (sortOption.value) {
          case 'price':
            return a.currentPrice.compareTo(b.currentPrice);
          case 'ending':
            final aTime = a.endTime ?? DateTime.now().add(const Duration(days: 30));
            final bTime = b.endTime ?? DateTime.now().add(const Duration(days: 30));
            return aTime.compareTo(bTime);
          default:
            return b.id.compareTo(a.id);
        }
      });
  }

  List<ItemModel> itemsForCategoryIndex(int index) {
    final category = AppConstants.categoryIds[index];
    final query = searchController.text.trim().toLowerCase();
    return items.where((item) {
      final matchesCategory = item.category == category;
      final matchesQuery = query.isEmpty ||
          item.titleAr.toLowerCase().contains(query) ||
          item.titleEn.toLowerCase().contains(query);
      final matchesPrice = item.currentPrice >= priceRange.value.start && item.currentPrice <= priceRange.value.end;
      return matchesCategory && matchesQuery && matchesPrice;
    }).toList()
      ..sort((a, b) {
        switch (sortOption.value) {
          case 'price':
            return a.currentPrice.compareTo(b.currentPrice);
          case 'ending':
            final aTime = a.endTime ?? DateTime.now().add(const Duration(days: 30));
            final bTime = b.endTime ?? DateTime.now().add(const Duration(days: 30));
            return aTime.compareTo(bTime);
          default:
            return b.id.compareTo(a.id);
        }
      });
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();
    searchController.addListener(() {
      updateHighlight();
      update();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    pageController.dispose();
    _aiTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadData() async {
    favorites.assignAll(StorageService.to.getFavorites());
    var storedItems = StorageService.to.getItems();
    if (storedItems.isEmpty) {
      storedItems = _generateDummyItems();
      await StorageService.to.saveItems(storedItems);
    }
    items.assignAll(storedItems);
    updateHighlight();
    _startAiHighlightTimer();
  }

  List<ItemModel> _generateDummyItems() {
    final uuid = const Uuid();
    final now = DateTime.now();
    final categories = AppConstants.categoryIds;
    final data = <ItemModel>[];
    for (var i = 0; i < 12; i++) {
      final category = categories[i % categories.length];
      final end = i.isEven ? now.add(Duration(minutes: 8 + i)) : null;
      data.add(ItemModel(
        id: uuid.v4(),
        titleAr: 'عنصر ${i + 1}',
        titleEn: 'Item ${i + 1}',
        descriptionAr: 'وصف تفصيلي للعنصر رقم ${i + 1}',
        descriptionEn: 'Detailed description for item ${i + 1}',
        category: category,
        images: [AppConstants.placeholderImages[i % AppConstants.placeholderImages.length]],
        startPrice: 1000 + (i * 250),
        currentPrice: 1000 + (i * 375),
        isAuction: i.isEven,
        endTime: end,
      ));
    }
    return data;
  }

  Future<void> refreshData() async {
    isRefreshing.value = true;
    await Future.delayed(const Duration(seconds: 1));
    await _loadData();
    isRefreshing.value = false;
  }

  void setCategory(int index) {
    currentCategoryIndex.value = index;
    updateHighlight();
    update();
  }

  void setSortOption(String option) {
    sortOption.value = option;
    update();
  }

  void setPriceRange(RangeValues values) {
    priceRange.value = values;
    update();
  }

  bool isFavorite(String itemId) => favorites.contains(itemId);

  void toggleFavorite(ItemModel item) {
    if (isFavorite(item.id)) {
      favorites.remove(item.id);
      StorageService.to.saveFavorites(favorites);
      Get.snackbar('home.favoriteRemoved'.tr, item.titleAr, snackPosition: SnackPosition.BOTTOM, mainButton: TextButton(
        onPressed: () {
          favorites.add(item.id);
          StorageService.to.saveFavorites(favorites);
          update();
        },
        child: Text('home.undo'.tr),
      ));
    } else {
      favorites.add(item.id);
      StorageService.to.saveFavorites(favorites);
      Get.snackbar('home.favoriteAdded'.tr, item.titleAr, snackPosition: SnackPosition.BOTTOM);
    }
    update();
  }

  void removeItem(ItemModel item) {
    items.removeWhere((element) => element.id == item.id);
    StorageService.to.saveItems(items);
    updateHighlight();
  }

  void updateHighlight() {
    final data = filteredItems;
    if (data.isEmpty) {
      aiHighlight.value = 'home.empty'.tr;
      return;
    }
    final highlightItem = data.first;
    final aiKeys = AiService.to.getAiInfoForItem(highlightItem.id);
    if (aiKeys.isNotEmpty) {
      aiHighlight.value = aiKeys.first.tr;
    }
  }

  void _startAiHighlightTimer() {
    _aiTimer?.cancel();
    _aiTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      final data = filteredItems;
      if (data.isEmpty) return;
      final highlightItem = data.first;
      final aiKeys = AiService.to.getAiInfoForItem(highlightItem.id);
      if (aiKeys.isEmpty) return;
      final currentIndex = aiKeys.indexWhere((key) => key.tr == aiHighlight.value);
      final nextKey = aiKeys[(currentIndex + 1) % aiKeys.length];
      aiHighlight.value = nextKey.tr;
    });
  }

  String countdownFor(ItemModel item) {
    if (!item.isAuction || item.endTime == null) return 'home.noCountdown'.tr;
    final remaining = item.endTime!.difference(DateTime.now());
    if (remaining.isNegative) return '00:00:00';
    return Helpers.formatCountdown(remaining);
  }

  void openDetails(ItemModel item) {
    Get.toNamed(AppRoutes.details, arguments: item);
  }

  void resetFilters() {
    searchController.clear();
    priceRange.value = const RangeValues(0, 500000);
    sortOption.value = 'recent';
    update();
  }
}

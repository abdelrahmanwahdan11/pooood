/*
  هذا الملف يدير بيانات المفضلة مع التحديث من التخزين المحلي وإتاحة الحذف والتراجع.
  يمكن تطويره لإضافة تزامن سحابي أو تنبيهات عند توفر العناصر.
*/
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/models/item_model.dart';
import '../../../data/services/storage_service.dart';

class WishlistController extends GetxController {
  final items = <ItemModel>[].obs;
  final pagingController = PagingController<int, ItemModel>(firstPageKey: 0);
  static const int pageSize = 4;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener(_fetchPage);
    loadFavorites();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  Future<void> loadFavorites() async {
    final favoritesIds = StorageService.to.getFavorites();
    final storedItems = StorageService.to.getItems();
    items.assignAll(storedItems.where((element) => favoritesIds.contains(element.id)).toList());
    pagingController.refresh();
  }

  Future<void> refreshFavorites() async {
    await loadFavorites();
  }

  Future<void> removeFavorite(String id) async {
    final favorites = StorageService.to.getFavorites();
    if (favorites.remove(id)) {
      await StorageService.to.saveFavorites(favorites);
      await loadFavorites();
    }
  }

  void _fetchPage(int pageKey) {
    final newItems = items.skip(pageKey).take(pageSize).toList();
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      final nextKey = pageKey + newItems.length;
      pagingController.appendPage(newItems, nextKey);
    }
  }
}

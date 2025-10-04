import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/models/watch_item.dart';
import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';
import '../profile/profile_controller.dart';

class HomeController extends GetxController {
  HomeController(this.repository, this.settingsRepository);

  final WatchStoreRepository repository;
  final SettingsRepository settingsRepository;

  static const int _pageSize = 6;

  final pagingController = PagingController<int, WatchItem>(firstPageKey: 0);
  final activeCollection = 'all'.obs;
  final searchQuery = ''.obs;
  final appliedFilters = <String>[].obs;
  final isRefreshing = false.obs;
  final featuredItems = <WatchItem>[].obs;
  late final RxSet<int> favoriteIds;
  final TextEditingController searchFieldController = TextEditingController();

  @override
  void onInit() {
    favoriteIds = settingsRepository.favoriteWatchIds.toSet().obs;
    pagingController.addPageRequestListener(_fetchPage);
    _loadFeatured();
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    searchFieldController.dispose();
    super.onClose();
  }

  Future<void> _loadFeatured() async {
    final list = await repository.fetchWatches(page: 0, limit: 3);
    featuredItems.assignAll(list);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final items = await repository.fetchWatches(
        page: pageKey,
        limit: _pageSize,
        query: searchQuery.value,
        collection: activeCollection.value,
      );
      final isLastPage = items.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(items);
      } else {
        final nextKey = pageKey + 1;
        pagingController.appendPage(items, nextKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> refresh() async {
    isRefreshing.value = true;
    pagingController.refresh();
    await _loadFeatured();
    isRefreshing.value = false;
  }

  void onCollectionSelected(String collection) {
    activeCollection.value = collection;
    refresh();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    settingsRepository.addRecentSearch(query);
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().refreshHistory();
    }
    refresh();
  }

  void toggleFilter(String filter) {
    if (appliedFilters.contains(filter)) {
      appliedFilters.remove(filter);
    } else {
      appliedFilters.add(filter);
    }
  }

  void toggleFavorite(WatchItem item) {
    if (favoriteIds.contains(item.id)) {
      favoriteIds.remove(item.id);
    } else {
      favoriteIds.add(item.id);
    }
    favoriteIds.refresh();
    settingsRepository.toggleFavoriteWatch(item.id);
  }

  bool isFavorite(WatchItem item) => favoriteIds.contains(item.id);

  Future<void> recordView(WatchItem item) async {
    await settingsRepository.updateRecentlyViewed(item.id);
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().refreshHistory();
    }
  }
}

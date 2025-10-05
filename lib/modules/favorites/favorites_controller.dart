import 'package:get/get.dart';

import '../../data/models/watch_item.dart';
import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';
import '../home/home_controller.dart';

class FavoritesController extends GetxController {
  FavoritesController(this.repository, this.settingsRepository);

  final WatchStoreRepository repository;
  final SettingsRepository settingsRepository;

  final RxList<WatchItem> items = RxList<WatchItem>([]);

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favorites = <WatchItem>[];
    for (final id in settingsRepository.favoriteWatchIds) {
      final watch = repository.findById(id);
      if (watch != null) {
        favorites.add(watch);
      }
    }
    items.assignAll(favorites);
  }

  Future<void> toggleFavorite(WatchItem item) async {
    await settingsRepository.toggleFavoriteWatch(item.id);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().toggleFavorite(item);
    }
    await loadFavorites();
  }
}

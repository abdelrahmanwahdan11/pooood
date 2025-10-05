import 'package:get/get.dart';

import '../../data/models/app_feature.dart';
import '../../data/models/watch_item.dart';
import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';
import '../auth/auth_controller.dart';

class ProfileController extends GetxController {
  ProfileController(this.settingsRepository, this.repository);

  final SettingsRepository settingsRepository;
  final WatchStoreRepository repository;

  late final List<AppFeature> features;
  final RxSet<String> enabledFeatures = RxSet<String>({});
  final RxList<WatchItem> recentlyViewed = RxList<WatchItem>([]);
  final RxList<String> recentSearches = RxList<String>([]);

  @override
  void onInit() {
    features = repository.featuresCatalog();
    enabledFeatures.addAll(settingsRepository.enabledFeatures);
    _loadRecentlyViewed();
    recentSearches.assignAll(settingsRepository.recentSearches);
    super.onInit();
  }

  Future<void> _loadRecentlyViewed() async {
    final watches = <WatchItem>[];
    for (final id in settingsRepository.recentlyViewedIds) {
      final item = repository.findById(id);
      if (item != null) {
        watches.add(item);
      }
    }
    recentlyViewed.assignAll(watches);
  }

  Future<void> refreshHistory() async {
    await _loadRecentlyViewed();
    recentSearches.assignAll(settingsRepository.recentSearches);
  }

  Future<void> toggleFeature(AppFeature feature, bool enabled) async {
    if (enabled) {
      enabledFeatures.add(feature.id);
    } else {
      enabledFeatures.remove(feature.id);
    }
    await settingsRepository.persistFeatureFlag(feature.id, enabled);
  }

  Future<void> clearHistory() async {
    await settingsRepository.clearRecentSearches();
    recentSearches.clear();
  }

  void signOut() {
    if (Get.isRegistered<AuthController>()) {
      Get.find<AuthController>().signOut();
    }
  }
}

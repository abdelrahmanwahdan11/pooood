import 'package:get/get.dart';

import '../../data/models/watch_item.dart';
import '../../data/repositories/settings_repo.dart';
import '../../data/repositories/watch_store_repo.dart';
import '../favorites/favorites_controller.dart';
import '../home/home_controller.dart';

class WatchDetailController extends GetxController {
  WatchDetailController(this.repository, this.settingsRepository);

  final WatchStoreRepository repository;
  final SettingsRepository settingsRepository;

  final watch = Rxn<WatchItem>();
  final colorIndex = 0.obs;
  final selectedSize = ''.obs;
  final isProcessing = false.obs;
  final isFavorite = false.obs;

  @override
  void onInit() {
    final id = Get.arguments as int?;
    if (id != null) {
      watch.value = repository.findById(id);
      if (watch.value == null) {
        Get.back();
      } else {
        selectedSize.value = watch.value!.wristSizes.first;
        final favorites = settingsRepository.favoriteWatchIds.toSet();
        isFavorite.value = favorites.contains(watch.value!.id);
        settingsRepository.updateRecentlyViewed(watch.value!.id);
      }
    } else {
      Get.back();
    }
    super.onInit();
  }

  void selectColor(int index) {
    colorIndex.value = index;
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  Future<void> toggleFavorite() async {
    if (watch.value == null) return;
    isFavorite.toggle();
    await settingsRepository.toggleFavoriteWatch(watch.value!.id);
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      if (isFavorite.value) {
        home.favoriteIds.add(watch.value!.id);
      } else {
        home.favoriteIds.remove(watch.value!.id);
      }
      home.favoriteIds.refresh();
    }
    if (Get.isRegistered<FavoritesController>()) {
      await Get.find<FavoritesController>().loadFavorites();
    }
  }

  Future<void> addToCart() async {
    if (watch.value == null) return;
    isProcessing.value = true;
    await Future.delayed(const Duration(milliseconds: 420));
    isProcessing.value = false;
    Get.snackbar('app_name'.tr, 'added_to_cart'.trParams({'name': watch.value!.name}));
  }

  Future<void> startAppointment() async {
    if (watch.value == null) return;
    isProcessing.value = true;
    await Future.delayed(const Duration(milliseconds: 420));
    isProcessing.value = false;
    Get.snackbar('app_name'.tr, 'appointment_booked'.tr);
  }
}

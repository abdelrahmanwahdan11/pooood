import 'package:get/get.dart';

import '../../data/models/price_watch.dart';
import '../../data/repositories/watches_repo.dart';

class PriceWatchController extends GetxController {
  PriceWatchController(this.repository);

  final WatchesRepository repository;

  final RxList<PriceWatch> watches = RxList<PriceWatch>([]);
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadWatches();
  }

  Future<void> loadWatches() async {
    isLoading.value = true;
    final list = await repository.fetchWatches();
    watches.assignAll(list);
    isLoading.value = false;
  }

  Future<void> addWatch(PriceWatch watch) async {
    await repository.addWatch(watch);
    await loadWatches();
  }

  Future<void> updateWatch(PriceWatch watch) async {
    await repository.updateWatch(watch);
    await loadWatches();
  }

  Future<void> deleteWatch(int id) async {
    await repository.deleteWatch(id);
    await loadWatches();
  }
}

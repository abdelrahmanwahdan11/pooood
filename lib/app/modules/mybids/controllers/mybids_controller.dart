/*
  هذا الملف يدير شاشة مزايداتي مع بيانات محاكية وتحديث من التخزين المحلي.
  يمكن تطويره لعرض حالة الفوز أو الفواتير التفصيلية لاحقاً.
*/
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/bid_model.dart';
import '../../../data/models/item_model.dart';
import '../../../data/services/storage_service.dart';

class MybidsController extends GetxController {
  final bids = <BidModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBids();
  }

  Future<void> loadBids() async {
    var storedBids = StorageService.to.getBids();
    if (storedBids.isEmpty) {
      storedBids = _generateDummyBids();
      await StorageService.to.saveBids(storedBids);
    }
    bids.assignAll(storedBids);
  }

  Future<void> refreshBids() async {
    await loadBids();
  }

  List<BidModel> _generateDummyBids() {
    final uuid = const Uuid();
    final items = StorageService.to.getItems();
    if (items.isEmpty) return [];
    final sampleItem = items.first;
    return [
      BidModel(
        id: uuid.v4(),
        itemId: sampleItem.id,
        userId: 'guest',
        amount: sampleItem.currentPrice + 100,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  ItemModel? itemForBid(BidModel bid) {
    final items = StorageService.to.getItems();
    for (final item in items) {
      if (item.id == bid.itemId) {
        return item;
      }
    }
    return null;
  }
}

import 'package:get/get.dart';

import '../data/models/notification_item.dart';
import '../data/repositories/notifications_repository.dart';

class NotificationsService extends GetxService {
  NotificationsService();

  final _items = <NotificationItem>[].obs;

  NotificationsRepository get _repository => Get.find<NotificationsRepository>();

  List<NotificationItem> get items => _items;

  int get unreadCount => _items.where((element) => !element.isRead).length;

  @override
  void onInit() {
    super.onInit();
    refresh();
  }

  void refresh() {
    _items.assignAll(_repository.fetch());
  }

  void markAsRead(String id) {
    _repository.markAsRead(id);
    refresh();
  }
}

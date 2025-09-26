import 'package:get/get.dart';

import '../../data/models/notification_item.dart';
import '../../data/repositories/notifications_repo.dart';

class NotificationsController extends GetxController {
  NotificationsController(this.repository);

  final NotificationsRepository repository;

  final notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final data = await repository.fetchNotifications();
    notifications.assignAll(data);
  }

  int get unreadCount => notifications.where((n) => !n.read).length;

  Future<void> markRead(NotificationItem item, bool read) async {
    await repository.markRead(item.id, read);
    await load();
  }
}

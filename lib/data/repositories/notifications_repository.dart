import '../models/notification_item.dart';

abstract class NotificationsRepository {
  List<NotificationItem> fetch();
  void markAsRead(String id);
}

class InMemoryNotificationsRepository implements NotificationsRepository {
  InMemoryNotificationsRepository();

  // Firebase integration placeholder:
  // Swap to Firestore collection `notifications` and update markAsRead to
  // call doc.update({'isRead': true}) when backend is available.

  final _items = <NotificationItem>[
    NotificationItem(
      id: 'n1',
      title: 'عرض جديد',
      body: 'تم إضافة خصم جديد على سماعات سوني WH-1000XM5 بالقرب منك.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    NotificationItem(
      id: 'n2',
      title: 'المزاد يقترب من الإغلاق',
      body: 'تبقى 30 دقيقة على كاميرا سوني A7 IV، زد عرضك الآن!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  @override
  List<NotificationItem> fetch() => List.unmodifiable(_items);

  @override
  void markAsRead(String id) {
    final index = _items.indexWhere((element) => element.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(isRead: true);
    }
  }
}

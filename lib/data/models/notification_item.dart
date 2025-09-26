class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
    this.type,
  });

  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final String? type;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'read': read ? 1 : 0,
        'type': type,
      };

  static NotificationItem fromMap(Map<String, dynamic> map) => NotificationItem(
        id: map['id'] as int,
        title: map['title'] as String,
        body: map['body'] as String,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        read: (map['read'] as int) == 1,
        type: map['type'] as String?,
      );
}

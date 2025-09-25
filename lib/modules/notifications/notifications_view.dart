import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/widgets/glass_container.dart';
import 'notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('notifications'.tr)),
      body: Obx(
        () {
          final items = controller.service.items;
          if (items.isEmpty) {
            return Center(child: Text('empty_state_title'.tr));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GlassContainer(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.body),
                      const SizedBox(height: 4),
                      Text(DateFormat.Hm().format(item.timestamp)),
                    ],
                  ),
                  trailing: item.isRead
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : IconButton(
                          onPressed: () => controller.markAsRead(item.id),
                          icon: const Icon(Icons.mark_email_read_outlined),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

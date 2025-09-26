import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/responsive.dart';
import '../../core/widgets/glass_container.dart';
import 'notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.adaptivePadding(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications'.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Obx(
          () => ListView.builder(
            itemCount: controller.notifications.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return GlassContainer(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Switch(
                          value: notification.read,
                          onChanged: (value) =>
                              controller.markRead(notification, value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(notification.body),
                    const SizedBox(height: 4),
                    Text(
                      notification.createdAt.toLocal().toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

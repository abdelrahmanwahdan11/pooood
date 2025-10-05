import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/hard_shadow_box.dart';
import '../../main.dart';
import 'chat_controller.dart';
import 'chat_routes.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  static const route = ChatRoutes.route;

  @override
  Widget build(BuildContext context) {
    final palette = Get.find<AppController>().palette;
    final theme = Theme.of(context);
    final locale = Get.locale?.languageCode ?? 'en';
    return Scaffold(
      backgroundColor: palette.chat,
      appBar: AppBar(
        title: Text('chat'.tr),
        backgroundColor: palette.chat,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('chat_intro'.tr, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isHost = message.authorKey == 'chat_host';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: isHost ? Alignment.centerLeft : Alignment.centerRight,
                      child: HardShadowBox(
                        backgroundColor: isHost ? palette.surface : Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message.authorKey.tr, style: theme.textTheme.bodySmall),
                            const SizedBox(height: 6),
                            Text(message.text(locale), style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            HardShadowBox(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Text('chat'.tr, style: theme.textTheme.bodySmall),
                  ),
                  HardShadowBox(
                    backgroundColor: palette.card,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: const Icon(Icons.send, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

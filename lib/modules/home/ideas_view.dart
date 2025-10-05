import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/hard_shadow_box.dart';
import '../../main.dart';

class IdeasView extends StatelessWidget {
  const IdeasView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    final ideas = controller.featureIdeas();
    final palette = controller.palette;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        title: Text('feature_list_title'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView.separated(
          itemCount: ideas.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final idea = ideas[index];
            final text = idea.text(Get.locale?.languageCode ?? 'en');
            return HardShadowBox(
              backgroundColor: palette.card,
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HardShadowBox(
                    backgroundColor: palette.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Text('${idea.index}'.padLeft(2, '0'), style: theme.textTheme.bodyMedium),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(text, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

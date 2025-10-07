import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/layout_helper.dart';
import '../controllers/features_controller.dart';

class FeaturesView extends GetView<FeaturesController> {
  const FeaturesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('features_title'.tr)),
      body: LayoutHelper.constrain(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('features_subtitle'.tr, style: theme.textTheme.titleMedium?.copyWith(color: theme.hintColor)),
              const SizedBox(height: 24),
              Expanded(
                child: Obx(
                  () => ListView.separated(
                    itemCount: controller.features.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final feature = controller.features[index];
                      final enabled = controller.toggles[feature.id] ?? feature.defaultEnabled;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: enabled
                              ? theme.colorScheme.primaryContainer.withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.8)
                              : theme.cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 22,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(feature.icon, color: enabled ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(feature.titleKey.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 6),
                                  Text(feature.descriptionKey.tr, style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            Switch(
                              value: enabled,
                              onChanged: (value) => controller.toggleFeature(feature, value),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/hard_shadow_box.dart';
import '../../main.dart';
import 'trust_controller.dart';
import 'trust_routes.dart';

class TrustView extends GetView<TrustController> {
  const TrustView({super.key});

  static const route = TrustRoutes.route;

  @override
  Widget build(BuildContext context) {
    final palette = Get.find<AppController>().palette;
    final theme = Theme.of(context);
    final locale = Get.locale ?? const Locale('en');
    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        title: Text('trust_center_title'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HardShadowBox(
              backgroundColor: palette.card,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('trust_center_intro'.tr, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: controller.liveMoments
                        .map(
                          (moment) => HardShadowBox(
                            backgroundColor: palette.surface,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Text(moment.resolve(locale), style: theme.textTheme.bodySmall),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            HardShadowBox(
              backgroundColor: palette.surface,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('trust_badges_title'.tr, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('trust_badges_subtitle'.tr, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                  ...controller.badges.map(
                    (badge) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: HardShadowBox(
                        backgroundColor: palette.card,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(badge.title.resolve(locale), style: theme.textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(badge.description.resolve(locale), style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            HardShadowBox(
              backgroundColor: palette.card,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('trust_vendors_title'.tr, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ...controller.vendors.map(
                    (vendor) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vendor.name.resolve(locale), style: theme.textTheme.titleLarge),
                          Text(vendor.location.resolve(locale), style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            HardShadowBox(
              backgroundColor: palette.surface,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('trust_policies_title'.tr, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ...controller.policies.map(
                    (policy) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(policy.title.resolve(locale), style: theme.textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(policy.summary.resolve(locale), style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            HardShadowBox(
              backgroundColor: palette.surface,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('trust_reports_title'.tr, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('trust_reports_subtitle'.tr, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                  ...controller.reports.map(
                    (report) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          HardShadowBox(
                            backgroundColor: palette.card,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Text(report.period.resolve(locale), style: theme.textTheme.bodySmall),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(report.highlight.resolve(locale), style: theme.textTheme.bodySmall),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            HardShadowBox(
              backgroundColor: palette.card,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('trust_story_title'.tr, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  ...controller.stories.map(
                    (story) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(story.quote.resolve(locale), style: theme.textTheme.bodySmall),
                          const SizedBox(height: 4),
                          Text('${story.author.resolve(locale)} · ${story.role.resolve(locale)}', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            HardShadowBox(
              backgroundColor: palette.surface,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('trust_guidelines_title'.tr, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('trust_guidelines_body'.tr, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),
                  Text('trust_contact_title'.tr, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('trust_contact_subtitle'.tr, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

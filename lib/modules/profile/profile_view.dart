import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/routing/app_routes.dart';
import '../../data/models/app_feature.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () {
          final grouped = _groupFeatures(controller.features);
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _ProfileHeader(theme: theme, controller: controller),
              const SizedBox(height: 24),
              if (controller.recentlyViewed.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('recently_viewed'.tr, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item = controller.recentlyViewed[index];
                          return GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.watchDetails, arguments: item.id),
                            child: GlassContainer(
                              width: 140,
                              padding: const EdgeInsets.all(12),
                              borderRadius: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: item.imagePlaceholder,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(Icons.watch_rounded,
                                          size: 64, color: Colors.white.withOpacity(0.9)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text(item.brand,
                                      style: theme.textTheme.labelSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: controller.recentlyViewed.length,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              if (controller.recentSearches.isNotEmpty)
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('recent_searches'.tr, style: theme.textTheme.titleMedium),
                          const Spacer(),
                          TextButton(
                            onPressed: controller.clearHistory,
                            child: Text('clear_history'.tr),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.recentSearches
                            .map((query) => Chip(label: Text(query)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              ...grouped.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('category_${entry.key}'.tr, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        ...entry.value.map(
                          (feature) => Obx(
                            () => SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              title: Text(feature.titleKey.tr),
                              subtitle: Text(feature.descriptionKey.tr),
                              value: controller.enabledFeatures.contains(feature.id),
                              onChanged: (value) => controller.toggleFeature(feature, value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: controller.signOut,
                icon: const Icon(Icons.logout_rounded),
                label: Text('sign_out'.tr),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, List<AppFeature>> _groupFeatures(List<AppFeature> features) {
    final map = <String, List<AppFeature>>{};
    for (final feature in features) {
      map.putIfAbsent(feature.category ?? 'experience_features', () => []).add(feature);
    }
    return map;
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.theme, required this.controller});

  final ThemeData theme;
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final settings = controller.settingsRepository;
    final isGuest = settings.isGuestMode;
    final name = settings.userName ?? 'guest_name'.tr;
    final email = settings.userEmail ?? 'guest_email'.tr;
    return GlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: AppTheme.accentPrimary,
            child: Text(name.characters.first.toUpperCase(), style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleLarge),
                Text(email, style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(isGuest ? Icons.visibility_off_rounded : Icons.verified_user_rounded,
                        size: 18, color: AppTheme.accentPrimary),
                    const SizedBox(width: 6),
                    Text(isGuest ? 'guest_badge'.tr : 'member_badge'.tr,
                        style: theme.textTheme.labelMedium),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

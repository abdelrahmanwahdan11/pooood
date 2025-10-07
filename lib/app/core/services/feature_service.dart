import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/experience_feature.dart';

class FeatureService extends GetxService {
  static const _prefsKey = 'mind_mirror_features';

  late SharedPreferences _prefs;
  final RxMap<String, bool> _enabled = <String, bool>{}.obs;

  final List<ExperienceFeature> _features = const [
    ExperienceFeature(
      id: 'daily_reflection',
      titleKey: 'feature_daily_reflection_title',
      descriptionKey: 'feature_daily_reflection_desc',
      icon: Icons.sunny,
      highlight: true,
    ),
    ExperienceFeature(
      id: 'weekly_trends',
      titleKey: 'feature_weekly_trends_title',
      descriptionKey: 'feature_weekly_trends_desc',
      icon: Icons.stacked_line_chart,
      highlight: true,
    ),
    ExperienceFeature(
      id: 'emotion_heatmap',
      titleKey: 'feature_emotion_heatmap_title',
      descriptionKey: 'feature_emotion_heatmap_desc',
      icon: Icons.gradient,
      highlight: true,
    ),
    ExperienceFeature(
      id: 'quick_mood',
      titleKey: 'feature_quick_mood_title',
      descriptionKey: 'feature_quick_mood_desc',
      icon: Icons.speed,
    ),
    ExperienceFeature(
      id: 'breathing_coach',
      titleKey: 'feature_breathing_coach_title',
      descriptionKey: 'feature_breathing_coach_desc',
      icon: Icons.air,
    ),
    ExperienceFeature(
      id: 'affirmation_library',
      titleKey: 'feature_affirmation_library_title',
      descriptionKey: 'feature_affirmation_library_desc',
      icon: Icons.auto_awesome,
    ),
    ExperienceFeature(
      id: 'social_share_cards',
      titleKey: 'feature_social_share_title',
      descriptionKey: 'feature_social_share_desc',
      icon: Icons.ios_share,
    ),
    ExperienceFeature(
      id: 'offline_questions',
      titleKey: 'feature_offline_questions_title',
      descriptionKey: 'feature_offline_questions_desc',
      icon: Icons.download_for_offline,
    ),
    ExperienceFeature(
      id: 'theme_scheduler',
      titleKey: 'feature_theme_scheduler_title',
      descriptionKey: 'feature_theme_scheduler_desc',
      icon: Icons.schedule,
    ),
    ExperienceFeature(
      id: 'voice_input',
      titleKey: 'feature_voice_input_title',
      descriptionKey: 'feature_voice_input_desc',
      icon: Icons.mic,
    ),
    ExperienceFeature(
      id: 'chat_history',
      titleKey: 'feature_chat_history_title',
      descriptionKey: 'feature_chat_history_desc',
      icon: Icons.history,
    ),
    ExperienceFeature(
      id: 'export_pdf',
      titleKey: 'feature_export_pdf_title',
      descriptionKey: 'feature_export_pdf_desc',
      icon: Icons.picture_as_pdf,
    ),
    ExperienceFeature(
      id: 'compare_timeline',
      titleKey: 'feature_compare_timeline_title',
      descriptionKey: 'feature_compare_timeline_desc',
      icon: Icons.timeline,
    ),
    ExperienceFeature(
      id: 'home_widgets',
      titleKey: 'feature_home_widgets_title',
      descriptionKey: 'feature_home_widgets_desc',
      icon: Icons.widgets,
    ),
    ExperienceFeature(
      id: 'assistant_shortcuts',
      titleKey: 'feature_assistant_shortcuts_title',
      descriptionKey: 'feature_assistant_shortcuts_desc',
      icon: Icons.shortcut,
    ),
    ExperienceFeature(
      id: 'haptics',
      titleKey: 'feature_haptics_title',
      descriptionKey: 'feature_haptics_desc',
      icon: Icons.vibration,
    ),
    ExperienceFeature(
      id: 'quiz_tips',
      titleKey: 'feature_quiz_tips_title',
      descriptionKey: 'feature_quiz_tips_desc',
      icon: Icons.lightbulb,
    ),
    ExperienceFeature(
      id: 'reverse_helper',
      titleKey: 'feature_reverse_helper_title',
      descriptionKey: 'feature_reverse_helper_desc',
      icon: Icons.sync_alt,
    ),
    ExperienceFeature(
      id: 'streak_tracker',
      titleKey: 'feature_streak_tracker_title',
      descriptionKey: 'feature_streak_tracker_desc',
      icon: Icons.local_fire_department,
    ),
    ExperienceFeature(
      id: 'onboarding_recaps',
      titleKey: 'feature_onboarding_recaps_title',
      descriptionKey: 'feature_onboarding_recaps_desc',
      icon: Icons.replay,
    ),
    ExperienceFeature(
      id: 'avatar_gallery',
      titleKey: 'feature_avatar_gallery_title',
      descriptionKey: 'feature_avatar_gallery_desc',
      icon: Icons.emoji_emotions,
    ),
    ExperienceFeature(
      id: 'high_contrast',
      titleKey: 'feature_high_contrast_title',
      descriptionKey: 'feature_high_contrast_desc',
      icon: Icons.contrast,
    ),
    ExperienceFeature(
      id: 'reduced_motion',
      titleKey: 'feature_reduced_motion_title',
      descriptionKey: 'feature_reduced_motion_desc',
      icon: Icons.motion_photos_off,
    ),
    ExperienceFeature(
      id: 'data_control',
      titleKey: 'feature_data_control_title',
      descriptionKey: 'feature_data_control_desc',
      icon: Icons.privacy_tip,
    ),
    ExperienceFeature(
      id: 'sleep_mode',
      titleKey: 'feature_sleep_mode_title',
      descriptionKey: 'feature_sleep_mode_desc',
      icon: Icons.nights_stay,
    ),
    ExperienceFeature(
      id: 'notification_digest',
      titleKey: 'feature_notification_digest_title',
      descriptionKey: 'feature_notification_digest_desc',
      icon: Icons.notifications_active,
    ),
    ExperienceFeature(
      id: 'notebook_integration',
      titleKey: 'feature_notebook_integration_title',
      descriptionKey: 'feature_notebook_integration_desc',
      icon: Icons.note_alt,
    ),
    ExperienceFeature(
      id: 'custom_questions',
      titleKey: 'feature_custom_questions_title',
      descriptionKey: 'feature_custom_questions_desc',
      icon: Icons.add_circle_outline,
    ),
    ExperienceFeature(
      id: 'focus_mode',
      titleKey: 'feature_focus_mode_title',
      descriptionKey: 'feature_focus_mode_desc',
      icon: Icons.do_not_disturb_on_total_silence,
    ),
    ExperienceFeature(
      id: 'calendar_sync',
      titleKey: 'feature_calendar_sync_title',
      descriptionKey: 'feature_calendar_sync_desc',
      icon: Icons.calendar_today,
    ),
  ];

  List<ExperienceFeature> get features => List.unmodifiable(_features);
  RxMap<String, bool> get toggles => _enabled;

  Future<FeatureService> init() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs.getStringList(_prefsKey) ?? <String>[];
    for (final feature in _features) {
      final isEnabled = stored.contains(feature.id) || feature.defaultEnabled;
      _enabled[feature.id] = isEnabled;
    }
    return this;
  }

  bool isEnabled(String id) => _enabled[id] ?? false;

  List<ExperienceFeature> highlights() =>
      _features.where((feature) => feature.highlight).toList(growable: false);

  Future<void> toggle(String id, bool value) async {
    _enabled[id] = value;
    _enabled.refresh();
    final enabledIds = _enabled.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList(growable: false);
    await _prefs.setStringList(_prefsKey, enabledIds);
  }
}

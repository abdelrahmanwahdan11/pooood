import 'package:flutter/material.dart';

class ExperienceFeature {
  const ExperienceFeature({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    this.highlight = false,
    this.defaultEnabled = true,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final bool highlight;
  final bool defaultEnabled;
}

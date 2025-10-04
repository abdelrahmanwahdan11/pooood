import 'package:flutter/material.dart';

class AppFeature {
  const AppFeature({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    this.category,
    this.requiresPro = false,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
  final String? category;
  final bool requiresPro;
}

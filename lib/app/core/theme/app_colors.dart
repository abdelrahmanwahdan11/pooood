import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primaryYellow = Color(0xFFFFD900);
  static const primaryBlue = Color(0xFF0466C8);
  static const primaryPink = Color(0xFFE56B6F);
  static const textDark = Color(0xFF282828);
  static const lightBackground = Color(0xFFF7F7F9);
  static const darkBackground = Color(0xFF121212);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1A1A1A);

  static const lightGradients = {
    'quiz_card': [Color(0xFFFFF5A6), primaryYellow],
    'insights_card': [Color(0xFFB4D2FF), primaryBlue],
    'compare_card': [Color(0xFFFFC1C4), primaryPink],
  };

  static const darkGradients = {
    'quiz_card': [Color(0xFF6F6400), Color(0xFFFFE257)],
    'insights_card': [Color(0xFF1E3B73), Color(0xFF6FA8FF)],
    'compare_card': [Color(0xFF7A1F29), Color(0xFFFF8A90)],
  };
}

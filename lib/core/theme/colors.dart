import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF012FFF);
  static const Color accent = Color(0xFFE1FF4F);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFFCCCCCC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color glassBackground = Color(0x66012FFF);
  static const Color glassHighlight = Color(0x33E1FF4F);
  static const Color glassShadow = Color(0x33000000);

  static LinearGradient glassGradient({bool reverse = false}) => LinearGradient(
        begin: reverse ? Alignment.bottomRight : Alignment.topLeft,
        end: reverse ? Alignment.topLeft : Alignment.bottomRight,
        colors: const [
          Color(0x66012FFF),
          Color(0x33012FFF),
          Color(0x33E1FF4F),
        ],
      );

  static const List<Color> neonAccent = [
    Color(0xFF012FFF),
    Color(0xFF2746FF),
    Color(0xFFE1FF4F),
  ];
}

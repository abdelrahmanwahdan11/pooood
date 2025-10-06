/*
  هذا الملف يعرّف الثيم العام للتطبيق بالحالتين الفاتحة والداكنة.
  يمكن تعديل الألوان والخطوط بسهولة أو إضافة ثيمات جديدة لاحقاً.
*/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFFF4F6FA),
    textTheme: GoogleFonts.cairoTextTheme(),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFF10121A),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
    useMaterial3: true,
  );
}

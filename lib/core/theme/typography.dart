import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme textTheme = GoogleFonts.outfitTextTheme().copyWith(
    displayLarge: GoogleFonts.outfit(
      fontSize: 42,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.5,
    ),
    displayMedium: GoogleFonts.outfit(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: -1,
    ),
    displaySmall: GoogleFonts.outfit(
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.outfit(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: GoogleFonts.outfit(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: GoogleFonts.outfit(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.outfit(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.outfit(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
    labelLarge: GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.outfit(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );
}

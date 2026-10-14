import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const orange = Color(0xFFFF9800);
  static const orangeDeep = Color(0xFFF17E00);
  static const orangePale = Color(0xFFFFC15A);
  static const gold = Color(0xFFFFD700);
  static const green = Color(0xFF1B4D3E);
  static const greenDeep = Color(0xFF123A30);
  static const ink = Color(0xFF1C201E);
  static const cream = Color(0xFFFFF8E9);
  static const muted = Color(0xFF766B5D);
}

abstract final class AppTheme {
  static ThemeData get light {
    final textTheme = GoogleFonts.poppinsTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.orange,
        primary: AppColors.orange,
        secondary: AppColors.green,
        surface: AppColors.cream,
      ),
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.82),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        hintStyle: GoogleFonts.poppins(color: AppColors.muted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: AppColors.orange.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.green, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.greenDeep,
        contentTextStyle: GoogleFonts.poppins(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

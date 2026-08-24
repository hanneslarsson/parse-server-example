import 'package:flutter/material.dart';

/// Brand palette, matched to the Luma Marine merchandise line: a deep,
/// near-black navy and white as the two core brand colors (see
/// BRAND.md), plus a muted steel-teal used only as a functional UI
/// accent — not part of the core brand identity — for interactive states
/// (active nav, focus rings, status chips) where navy-on-white alone
/// can't carry the distinction.
class AppColors {
  AppColors._();

  static const navy = Color(0xFF0A1930);
  static const navyDark = Color(0xFF060F1F);
  static const navyLight = Color(0xFF1C3A5E);
  static const seafoam = Color(0xFF4AA3B5);
  static const seafoamDark = Color(0xFF357A8C);
  static const sand = Color(0xFFF4F1EA);
  static const fog = Color(0xFFE7ECEF);
  static const fogDark = Color(0xFFCBD5DB);
  static const ink = Color(0xFF14232B);
  static const slate = Color(0xFF5A6B74);
  static const white = Color(0xFFFFFFFF);
  static const danger = Color(0xFFC8553D);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        brightness: Brightness.light,
        primary: AppColors.navy,
        secondary: AppColors.seafoam,
        surface: AppColors.white,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: 'Inter',
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: 'Inter',
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ).copyWith(
        displayLarge: const TextStyle(
          fontFamily: 'InterDisplay',
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: AppColors.ink,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'InterDisplay',
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: AppColors.ink,
        ),
        headlineLarge: const TextStyle(
          fontFamily: 'InterDisplay',
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        headlineMedium: const TextStyle(
          fontFamily: 'InterDisplay',
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        titleLarge: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.fogDark, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fog.withValues(alpha: 0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.fogDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.seafoamDark, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.navy),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.fog,
        selectedColor: AppColors.seafoam.withValues(alpha: 0.2),
        labelStyle: const TextStyle(color: AppColors.ink),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.fogDark),
    );
  }
}

/// Layout breakpoints for a responsive marine-shop layout.
class Breakpoints {
  Breakpoints._();
  static const compact = 640.0;
  static const medium = 1024.0;
  static const expanded = 1440.0;

  static bool isCompact(double width) => width < compact;
  static bool isMedium(double width) => width >= compact && width < medium;
  static bool isExpanded(double width) => width >= medium;
}

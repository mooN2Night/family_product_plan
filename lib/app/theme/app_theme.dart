import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.primaryLight,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        );

    final textTheme =
        GoogleFonts.manropeTextTheme(
          const TextTheme(
            displayLarge: TextStyle(fontWeight: FontWeight.w700),
            displayMedium: TextStyle(fontWeight: FontWeight.w700),
            displaySmall: TextStyle(fontWeight: FontWeight.w700),
            headlineLarge: TextStyle(fontWeight: FontWeight.w700),
            headlineMedium: TextStyle(fontWeight: FontWeight.w700),
            headlineSmall: TextStyle(fontWeight: FontWeight.w600),
            titleLarge: TextStyle(fontWeight: FontWeight.w600),
            titleMedium: TextStyle(fontWeight: FontWeight.w600),
            titleSmall: TextStyle(fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(fontWeight: FontWeight.w400),
            bodyMedium: TextStyle(fontWeight: FontWeight.w400),
            bodySmall: TextStyle(fontWeight: FontWeight.w400),
            labelLarge: TextStyle(fontWeight: FontWeight.w600),
            labelMedium: TextStyle(fontWeight: FontWeight.w500),
            labelSmall: TextStyle(fontWeight: FontWeight.w500),
          ),
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.background,

      fontFamily: GoogleFonts.manrope().fontFamily,

      textTheme: textTheme,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),

      iconTheme: const IconThemeData(color: AppColors.textPrimary),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: const BorderSide(color: AppColors.primary, width: 1.8),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),
    );
  }
}

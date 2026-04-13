import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_typography.dart';

class AppTheme {
  static ThemeData darkTheme(BuildContext context) {
    // Generate the base TextTheme using our responsive typography utility
    final textTheme = AppTypography.createTextTheme(context, AppColors.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Apply the fallback fonts for general coverage
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.black,
        secondary: AppColors.surfaceContainer,
        onSecondary: AppColors.onSurface,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.accentRed,
        outlineVariant: Color(0x268E9198),
      ),
      scaffoldBackgroundColor: AppColors.surface,
      
      // Responsive TextTheme
      textTheme: textTheme.copyWith(
        // We override only branding-specific styles if absolutely needed
        displayLarge: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // UI/UX Pro Max: Interactive Feedback (Ripple/Splash)
      splashFactory: InkSparkle.splashFactory,
      
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), 
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          minimumSize: const Size(64, 48), 
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          // Use the responsive button style from our theme
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

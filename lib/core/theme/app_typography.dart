import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';



/// Responsive Typography System for CiviqQuiz

/// 

/// Breakpoints:

/// - Small: < 480px (Compact mobile)

/// - Medium: 480-960px (Standard mobile / Tablet portrait)

/// - Large: > 960px (Tablet landscape / Large screens)

///

/// Use [AppTypography.of(context)] to access values that adapt dynamically.

class AppTypography {

  static const List<String> fontFallbacks = ['Roboto', 'SF Pro Display', 'SF Pro Text'];



  static double _safeSp(double v) {
    try {
      final s = v.sp;
      if (s.isNaN || s.isInfinite || s <= 0) return v;
      return s;
    } catch (_) {
      return v;
    }
  }



  /// Returns the ideal headline size based on screen width.

  static double headlineSize(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    if (width < 480) return _safeSp(28);

    if (width < 960) return _safeSp(32);

    return _safeSp(36);

  }



  /// Returns the ideal subheadline size based on screen width.
  static double subheadlineSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 480) return _safeSp(22);
    if (width < 960) return _safeSp(25);
    return _safeSp(28);
  }



  /// Returns the ideal body size based on screen width.
  /// Minimum 16sp as requested for accessibility.
  static double bodySize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 480) return _safeSp(16);
    if (width < 960) return _safeSp(17);
    return _safeSp(18);
  }



  /// Caption size is fixed at 14sp for clarity.
  static double captionSize(BuildContext context) => _safeSp(14);



  /// Button size scales between 14 and 16sp.
  static double buttonSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 480) return _safeSp(14);
    return _safeSp(16);
  }



  /// Generates a standard TextTheme that implements these rules.

  static TextTheme createTextTheme(BuildContext context, Color color) {

    // We use ScreenUtil's .sp for all sizes to ensure scaling with accessibility settings

    return TextTheme(

      // Headline (28-36sp)

      displayLarge: GoogleFonts.roboto(

        fontSize: headlineSize(context),

        fontWeight: FontWeight.w900,

        color: color,

        letterSpacing: -0.5,

      ),

      headlineMedium: GoogleFonts.roboto(

        fontSize: subheadlineSize(context),

        fontWeight: FontWeight.bold,

        color: color,

      ),

      // Body (16-18sp)

      bodyLarge: GoogleFonts.roboto(

        fontSize: bodySize(context),

        height: 1.5,

        color: color.withValues(alpha: 0.9),

      ),

      bodyMedium: GoogleFonts.roboto(

        fontSize: bodySize(context) - 1, // Slightly smaller for dense content

        height: 1.4,

        color: color.withValues(alpha: 0.7),

      ),

      // Caption (14sp)

      labelSmall: GoogleFonts.roboto(

        fontSize: captionSize(context),

        fontWeight: FontWeight.w500,

        color: color.withValues(alpha: 0.5),

        letterSpacing: 0.5,

      ),

      // Button (14-16sp)

      labelLarge: GoogleFonts.roboto(

        fontSize: buttonSize(context),

        fontWeight: FontWeight.w700,

        color: color,

        letterSpacing: 1.2,

      ),

    );

  }

}


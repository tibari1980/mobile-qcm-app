import 'package:flutter/material.dart';



class AppColors {

  // --- CiviqueQuiz Premium Palette ---

  

  static const Color surface = Color(0xFF00142A); // Base bleu nuit

  static const Color surfaceDarker = Color(0xFF000D1A); // Bleu nuit profond

  static const Color onSurface = Color(0xFFD2E4FF);

  

  static const Color primary = Color(0xFF00B8D4); // Cyan CiviqueQuiz

  static const Color primaryNeon = Color(0xFF00D4FF); // Cyan éclatant premium

  static const Color primaryGlow = Color(0x3300E5FF); // Halo de lueur cyan

  

  static const Color accentRed = Color(0xFF680013); 

  static const Color accentRedNeon = Color(0xFFFF2D55); 

  static const Color accentPurpleNeon = Color(0xFF9D00FF); 

  static const Color warningYellowNeon = Color(0xFFFFD600); 

  

  static const Color successGreen = Color(0xFF20BF6B); 

  static const Color successGreenNeon = Color(0xFF00FF94); 

  

  static const Color surfaceContainer = Color(0xFF04203B);

  static const Color surfaceContainerHigh = Color(0xFF122B46);

  static const Color surfaceContainerHighest = Color(0xFF1E3652);



  // Spécifique CiviqueQuiz (Boutons et Badges)

  static const Color xpBadgeBg = Color(0xFF002233);

  static const Color xpBadgeText = Color(0xFF00E5FF);



  // Status Colors

  static const Color success = Color(0xFF38E090);

  static const Color warning = Color(0xFFFFB300);



  // Card Glow Tokens (Dynamic based on context if possible, but static hues are safer)

  static Color getCyanGlow(BuildContext context) => 

      primaryNeon.withValues(alpha: isDark(context) ? 0.4 : 0.15);

  static Color getRedGlow(BuildContext context) => 

      accentRedNeon.withValues(alpha: isDark(context) ? 0.4 : 0.15);

  static Color getGreenGlow(BuildContext context) => 

      successGreenNeon.withValues(alpha: isDark(context) ? 0.4 : 0.15);

  static Color getPurpleGlow(BuildContext context) => 

      accentPurpleNeon.withValues(alpha: isDark(context) ? 0.4 : 0.15);





  // --- Dynamic Color Management ---



  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;



  static Color getSurface(BuildContext context) => isDark(context) ? surface : const Color(0xFFF8F9FB);

  static Color getOnSurface(BuildContext context) => isDark(context) ? Colors.white : const Color(0xFF00142A);

  static Color getCardColor(BuildContext context) => isDark(context) ? surfaceContainer : Colors.white;



  // --- Theme Builders ---



  static ThemeData getTheme(bool isDark) {

    final base = isDark ? ThemeData.dark() : ThemeData.light();

    final primaryColor = primaryNeon;



    return base.copyWith(

      primaryColor: primaryColor,

      scaffoldBackgroundColor: isDark ? surface : const Color(0xFFF8F9FB),

      colorScheme: ColorScheme.fromSeed(

        seedColor: primaryColor,

        brightness: isDark ? Brightness.dark : Brightness.light,

        surface: isDark ? surface : const Color(0xFFF8F9FB),

        onSurface: isDark ? Colors.white : const Color(0xFF00142A),

      ),

      textTheme: base.textTheme.apply(

        bodyColor: isDark ? Colors.white : const Color(0xFF00142A),

        displayColor: isDark ? Colors.white : const Color(0xFF00142A),

      ),

      cardTheme: CardThemeData(

        color: isDark ? surfaceContainer : Colors.white,

        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      ),

    );

  }



  // --- 3D & Atmospheric Depth Tokens ---

  

  static Gradient getBackgroundGradient(BuildContext context) {

    final dark = isDark(context);

    return LinearGradient(

      begin: Alignment.topCenter,

      end: Alignment.bottomCenter,

      colors: dark 

        ? [surface, surfaceDarker] 

        : [const Color(0xFFFFFFFF), const Color(0xFFF0F4F8)], 

    );

  }



  static const Gradient primary3DGradient = LinearGradient(

    begin: Alignment.topLeft,

    end: Alignment.bottomRight,

    colors: [primaryNeon, Color(0xFF00B8D4)],

  );



  static const Gradient continueButtonGradient = LinearGradient(

    begin: Alignment.centerLeft,

    end: Alignment.centerRight,

    colors: [Color(0xFF3CD7FF), Color(0xFF00B8D4)],

  );



  static List<BoxShadow> getPremiumShadow(BuildContext context) {

    final dark = isDark(context);

    return [

      BoxShadow(

        color: Colors.black.withValues(alpha: dark ? 0.5 : 0.08),

        offset: const Offset(0, 24),

        blurRadius: 48,

      ),

      BoxShadow(

        color: primaryNeon.withValues(alpha: dark ? 0.1 : 0.03),

        offset: const Offset(0, 0),

        blurRadius: 12,

      ),

    ];

  }

}


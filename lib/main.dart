import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

import 'features/splash/splash_page.dart';

import 'features/intro/intro_page.dart';

import 'features/navigation/main_wrapper.dart';

import 'core/services/theme_service.dart';
import 'core/services/stats_service.dart';
import 'core/services/quiz_service.dart';

import 'theme/app_theme.dart';



final themeService = ThemeService();



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  // Expert Core Initializations
  try {
    await StatsService.init();
    await QuizService.init();
  } catch (e) {
    debugPrint("Critical initialization error: $e");
    // Continue execution to show ErrorWidget or fallback UI if possible
  }

  

  // Privacy Policy Local 100%: Prevent unbundled fonts from fetching to Google

  // Fix: Re-enabled runtime fetching to resolve console errors (fonts were missing from assets)

  GoogleFonts.config.allowRuntimeFetching = true;



  // Mobile Optimization: Lock orientation to Portrait for professional UI/UX

  await SystemChrome.setPreferredOrientations([

    DeviceOrientation.portraitUp,

  ]);



  // Immersive Experience: Setup Transparent StatusBar & Adaptive NavBar

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(

    statusBarColor: Colors.transparent,

    statusBarIconBrightness: Brightness.light, 

    systemNavigationBarColor: Colors.transparent,

    systemNavigationBarDividerColor: Colors.transparent,

    systemNavigationBarIconBrightness: Brightness.light,

  ));



  // UI/UX Pro Max: Global Stability Error Handler

  ErrorWidget.builder = (FlutterErrorDetails details) {

    return Material(

      color: const Color(0xFF00142A),

      child: Center(

        child: Padding(

          padding: const EdgeInsets.all(24.0),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              const Icon(Icons.error_outline, color: Color(0xFF00E5FF), size: 48),

              const SizedBox(height: 16),

              const Text(

                "Oups ! Une erreur de rendu est survenue.",

                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),

                textAlign: TextAlign.center,

              ),

              const SizedBox(height: 8),

              Text(

                details.exception.toString(),

                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),

                textAlign: TextAlign.center,

                maxLines: 5,

                overflow: TextOverflow.ellipsis,

              ),

            ],

          ),

        ),

      ),

    );

  };



  runApp(const CiviqQuizApp());

}



class CiviqQuizApp extends StatelessWidget {

  const CiviqQuizApp({super.key});



  @override

  Widget build(BuildContext context) {

    return ScreenUtilInit(

      designSize: const Size(393, 852),

      minTextAdapt: true,

      splitScreenMode: true,

      useInheritedMediaQuery: true, // Crucial for Web stability

      builder: (context, child) {

        return ListenableBuilder(

          listenable: themeService,

          builder: (context, _) {

            // Performance Optimization: Precache critical images

            precacheImage(const AssetImage('assets/images/marianne_3d.png'), context);

            precacheImage(const AssetImage('assets/images/marianne_hero.png'), context);

            precacheImage(const AssetImage('assets/images/eiffel_tour_3d.png'), context);



            return MaterialApp(

              title: 'CiviqQuiz',

              themeMode: themeService.themeMode,

              // We use our centralized responsive theme system

              theme: AppTheme.darkTheme(context), 

              darkTheme: AppTheme.darkTheme(context),

              debugShowCheckedModeBanner: false,

              home: const SplashPage(),

              routes: {

                '/intro': (context) => const IntroPage(),

                '/main': (context) => const MainWrapper(),

              },

            );

          },

        );

      },

    );

  }

}


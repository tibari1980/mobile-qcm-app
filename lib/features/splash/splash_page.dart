import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

import '../../core/widgets/responsive_layout.dart';

import '../../core/services/quiz_service.dart';



class SplashPage extends StatefulWidget {

  const SplashPage({super.key});



  @override

  State<SplashPage> createState() => _SplashPageState();

}



class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  late Animation<double> _scaleAnimation;

  late Animation<double> _opacityAnimation;



  @override

  void initState() {

    super.initState();

    _animationController = AnimationController(

      vsync: this,

      duration: const Duration(milliseconds: 2000),

    );



    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(

      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),

    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(

      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),

    );



    _animationController.forward();



    // AUTO-NAV: Intelligent transition based on pre-loaded state
    Future.delayed(const Duration(milliseconds: 2200), () async {
      if (!mounted) return;

      try {
        final bool hasPath = QuizService.currentPathCode != 'NONE';
        
        if (!hasPath) {
          Navigator.of(context).pushReplacementNamed('/intro');
        } else {
          Navigator.of(context).pushReplacementNamed('/main', arguments: 0);
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/intro');
        }
      }
    });

  }



  @override

  void dispose() {

    _animationController.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.surface, // Stitch Deep Night base

      resizeToAvoidBottomInset: false,

      body: ResponsiveLayout(

        showParticles: true,

        useSafeArea: false,

        child: LayoutBuilder(

          builder: (context, constraints) {

            final bool isSmall = constraints.maxWidth < 360;

            

            return Center(

              child: Padding(

                padding: const EdgeInsets.symmetric(horizontal: 40.0),

                child: AnimatedBuilder(

                  animation: _animationController,

                  builder: (context, child) {

                    return Opacity(

                      opacity: _opacityAnimation.value,

                      child: Transform.scale(

                        scale: _scaleAnimation.value,

                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            // 1: Monumental 3D Hero image (Stitch Style)

                            Semantics(

                              label: 'Logo institutionnel 3D de la Marianne, symbole de la République Française.',

                              image: true,

                              child: Container(

                                width: isSmall ? 200 : 280,

                                height: isSmall ? 200 : 280,

                                decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(32),

                                  boxShadow: [

                                    BoxShadow(

                                      color: AppColors.primaryNeon.withValues(alpha: 0.15),

                                      blurRadius: isSmall ? 60 : 100,

                                      spreadRadius: 20,

                                    ),

                                  ],

                                ),

                                child: ClipRRect(

                                  borderRadius: BorderRadius.circular(32),

                                  child: Image.asset(

                                    'assets/images/marianne_3d.png',

                                    fit: BoxFit.cover,

                                  ),

                                ),

                              ),

                            ),

                            

                            SizedBox(height: isSmall ? 40 : 60),

                            

                            // 2: Cinematic Typography (Stitch Style)

                            RichText(

                              textAlign: TextAlign.center,

                              text: TextSpan(

                                style: TextStyle(

                                  fontSize: isSmall ? 28 : 40,

                                  fontWeight: FontWeight.w900,

                                  height: 1.1,

                                  letterSpacing: 1.5,

                                  color: Colors.white,

                                ),

                                children: [

                                  const TextSpan(text: 'Devenez Citoyen par\n'),

                                  TextSpan(

                                    text: "l'Excellence",

                                    style: TextStyle(

                                      color: AppColors.primaryNeon,

                                      shadows: [

                                        Shadow(color: AppColors.primaryNeon.withValues(alpha: 0.5), blurRadius: 30),

                                      ],

                                    ),

                                  ),

                                  const TextSpan(text: '.'),

                                ],

                              ),

                            ),

                            

                            const SizedBox(height: 24),

                            

                            // 3: Institutional Description (Stitch Style)

                            Text(

                              "Une préparation immersive pour votre carte de séjour ou nationalité. Maîtrisez l'histoire et les valeurs de la République.",

                              textAlign: TextAlign.center,

                              style: TextStyle(

                                color: Colors.white.withValues(alpha: 0.5),

                                fontSize: isSmall ? 10 : 13,

                                height: 1.6,

                                fontWeight: FontWeight.w600,

                              ),

                            ),

                            

                            const SizedBox(height: 100),

                          ],

                        ),

                      ),

                    );

                  },

                ),

              ),

            );

          },

        ),

      ),

    );

  }

}


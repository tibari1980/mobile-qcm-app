import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

import '../../core/widgets/glass_card.dart';

import '../../core/widgets/responsive_layout.dart';



class UserGuideScreen extends StatelessWidget {

  const UserGuideScreen({super.key});



  @override

  Widget build(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);



    return ResponsiveLayout(

      showParticles: true,

      child: Scaffold(

        backgroundColor: Colors.transparent,

        resizeToAvoidBottomInset: false,

        appBar: AppBar(

          backgroundColor: Colors.transparent,

          elevation: 0,

          leading: IconButton(

            icon: Icon(Icons.close_rounded, color: onSurface),

            onPressed: () => Navigator.pop(context),

          ),

          title: Text(

            'MODE D\'EMPLOI',

            style: TextStyle(color: onSurface, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16),

          ),

        ),

        body: ListView(

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

          children: [

            _buildGuideSection(

              context,

              'ACCUEIL',

              'Votre tableau de bord quotidien. Consultez votre progression globale, vos derniers scores et lancez rapidement une session.',

              Icons.home_rounded,

            ),

            const SizedBox(height: 20),

            _buildGuideSection(

              context,

              'QUIZ RÉVISION',

              'Le cœur de l\'application. Répondez aux questions officielles. Attention : vous avez 45 secondes par question !',

              Icons.flag_rounded,

            ),

            const SizedBox(height: 20),

            _buildGuideSection(

              context,

              'LIVRET CITOYEN',

              'Révisez les thèmes par catégorie (Histoire, Géographie, Société) pour approfondir vos connaissances spécifiques.',

              Icons.auto_stories_rounded,

            ),

            const SizedBox(height: 20),

            _buildGuideSection(

              context,

              'STATISTIQUES',

              'Analysez vos performances détaillées par thème pour identifier vos points forts et les sujets à retravailler.',

              Icons.leaderboard_rounded,

            ),

            const SizedBox(height: 40),

            GlassCard(

              child: Padding(

                padding: const EdgeInsets.all(24),

                child: Column(

                  children: [

                    const Icon(Icons.tips_and_updates_rounded, color: AppColors.primaryNeon, size: 32),

                    const SizedBox(height: 16),

                    Text(

                      'CONSEIL D\'ÉLITE',

                      style: TextStyle(color: onSurface, fontWeight: FontWeight.bold, letterSpacing: 1),

                    ),

                    const SizedBox(height: 8),

                    Text(

                      'Pratiquez au moins 15 minutes par jour pour garantir une mémorisation optimale des valeurs de la République.',

                      textAlign: TextAlign.center,

                      style: TextStyle(color: onSurface.withValues(alpha: 0.6), height: 1.5),

                    ),

                  ],

                ),

              ),

            ),

            const SizedBox(height: 100),

          ],

        ),

      ),

    );

  }



  Widget _buildGuideSection(BuildContext context, String title, String desc, IconData icon) {

    final onSurface = AppColors.getOnSurface(context);

    return GlassCard(

      child: Padding(

        padding: const EdgeInsets.all(24),

        child: Row(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(

                color: AppColors.primaryNeon.withValues(alpha: 0.1),

                shape: BoxShape.circle,

              ),

              child: Icon(icon, color: AppColors.primaryNeon, size: 24),

            ),

            const SizedBox(width: 20),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style: TextStyle(color: onSurface, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),

                  ),

                  const SizedBox(height: 8),

                  Text(

                    desc,

                    style: TextStyle(color: onSurface.withValues(alpha: 0.6), height: 1.5, fontSize: 13),

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

}


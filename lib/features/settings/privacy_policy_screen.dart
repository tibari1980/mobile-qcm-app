import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

import '../../core/widgets/glass_card.dart';

import '../../core/widgets/responsive_layout.dart';



class PrivacyPolicyScreen extends StatelessWidget {

  const PrivacyPolicyScreen({super.key});



  @override

  Widget build(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    

    return Scaffold(

      backgroundColor: AppColors.getSurface(context),

      resizeToAvoidBottomInset: false,

      body: ResponsiveLayout(

        showParticles: true,

        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 32),

            Row(

              children: [

                IconButton(

                  onPressed: () => Navigator.pop(context),

                  icon: Icon(Icons.arrow_back_ios_rounded, color: onSurface, size: 20),

                ),

                const SizedBox(width: 8),

                Text(

                  'CONFIDENTIALITÉ',

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4, color: onSurface),

                ),

              ],

            ),

            const SizedBox(height: 40),

            

            Expanded(

              child: SingleChildScrollView(

                physics: const BouncingScrollPhysics(),

                child: Column(

                  children: [

                    _buildPrivacySection(

                      context,

                      Icons.security_rounded,

                      'STOCKAGE 100% LOCAL',

                      'Toutes vos données (score, XP, historique) sont enregistrées exclusivement sur votre téléphone. Aucune donnée ne quitte votre appareil.',

                    ),

                    const SizedBox(height: 24),

                    _buildPrivacySection(

                      context,

                      Icons.cloud_off_rounded,

                      'ZÉRO SERVEUR / CLOUD',

                      "CiviqQuiz Révision ne possède pas de base de données externe. Nous n'avons aucun moyen d'accéder à vos informations personnelles ou à votre progression.",

                    ),

                    const SizedBox(height: 24),

                    _buildPrivacySection(

                      context,

                      Icons.visibility_off_rounded,

                      'ACCÈS RESTREINT',

                      "Le système assure que seul CiviqQuiz Révision peut accéder aux données qu'il enregistre. Aucune autre application ne peut lire vos résultats.",

                    ),

                    const SizedBox(height: 24),

                    _buildPrivacySection(

                      context,

                      Icons.delete_forever_rounded,

                      'DROIT À L\'OUBLI',

                      "Désinstaller l'application supprime définitivement toutes vos données locales. Vous avez également une option 'Effacer Tout' dans les Paramètres.",

                    ),

                    const SizedBox(height: 48),

                    Center(

                      child: Text(

                        'VOTRE VIE PRIVÉE EST NOTRE PRIORITÉ.',

                        textAlign: TextAlign.center,

                        style: TextStyle(color: AppColors.primaryNeon, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),

                      ),

                    ),

                    const SizedBox(height: 40),

                  ],

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }



  Widget _buildPrivacySection(BuildContext context, IconData icon, String title, String description) {

    final onSurface = AppColors.getOnSurface(context);

    return GlassCard(

      child: Padding(

        padding: const EdgeInsets.all(24),

        child: Row(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(

              padding: const EdgeInsets.all(8),

              decoration: BoxDecoration(color: AppColors.primaryNeon.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),

              child: Icon(icon, color: AppColors.primaryNeon, size: 20),

            ),

            const SizedBox(width: 20),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(title, style: TextStyle(color: onSurface, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),

                  const SizedBox(height: 8),

                  Text(

                    description,

                    style: TextStyle(color: onSurface.withValues(alpha: 0.6), fontSize: 14, height: 1.5, fontWeight: FontWeight.w500),

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


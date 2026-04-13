import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

import '../../core/widgets/glass_card.dart';

import '../../core/widgets/responsive_layout.dart';

import '../../core/services/stats_service.dart';

import '../../core/services/quiz_service.dart';

import '../../main.dart'; // To access themeService

import 'history_screen.dart';

import 'user_guide_screen.dart';

import 'about_screen.dart';

import 'package:url_launcher/url_launcher.dart';



class SettingsScreen extends StatelessWidget {

  final VoidCallback? onChangePath;

  const SettingsScreen({super.key, this.onChangePath});



  Future<void> _resetProgress(BuildContext context) async {

    final onSurface = AppColors.getOnSurface(context);

    final bool? confirm = await showDialog<bool>(

      context: context,

      builder: (context) => AlertDialog(

        backgroundColor: AppColors.getSurface(context),

        title: Text('Tout recommencer ?', style: TextStyle(color: onSurface, fontWeight: FontWeight.bold)),

        content: Text('Souhaitez-vous vraiment effacer votre progression ? Toutes vos statistiques seront perdues définitivement.', style: TextStyle(color: onSurface.withValues(alpha: 0.7))),

        actions: [

          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ANNULER')),

          TextButton(

            onPressed: () => Navigator.pop(context, true), 

            child: const Text('RÉINITIALISER', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))

          ),

        ],

      ),

    );



    if (confirm == true) {

      await StatsService.resetData();

      if (context.mounted) {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(content: Text('Progression réinitialisée avec succès'))

        );

      }

    }

  }



  void _contactSupport() async {

    final Uri emailLaunchUri = Uri(

      scheme: 'mailto',

      path: 'support@civiqquiz.com',

      query: 'subject=Support CiviqQuiz Révision',

    );

    if (await canLaunchUrl(emailLaunchUri)) {

      await launchUrl(emailLaunchUri);

    }

  }



  @override

  Widget build(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);



    return ResponsiveLayout(

      showParticles: true,

      child: ListView(

        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),

        children: [

          Text(

            'PARAMÈTRES',

            style: TextStyle(

              color: onSurface,

              fontSize: 32,

              fontWeight: FontWeight.w900,

              letterSpacing: 2,

            ),

          ),

          const SizedBox(height: 8),

          Text(

            'Gérez votre expérience de révision',

            style: TextStyle(color: onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w500),

          ),

          

          const SizedBox(height: 48),

          

          // Section: Apparence

          _buildSectionHeader(context, 'APPARENCE'),

          ListenableBuilder(

            listenable: themeService,

            builder: (context, _) => GlassCard(

              child: SwitchListTile(

                secondary: Icon(

                  themeService.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,

                  color: AppColors.primaryNeon,

                ),

                title: Text('Mode Sombre', style: TextStyle(color: onSurface, fontWeight: FontWeight.bold)),

                value: themeService.isDarkMode,

                onChanged: (_) => themeService.toggleTheme(),

                activeThumbColor: AppColors.primaryNeon,

                activeTrackColor: AppColors.primaryNeon.withValues(alpha: 0.2),

              ),

            ),

          ),



          const SizedBox(height: 24),

          

          // Section: Profil & Parcours

          _buildSectionHeader(context, 'ENTRAÎNEMENT'),

          GlassCard(

            child: Column(

              children: [

                ListTile(

                  leading: const Icon(Icons.psychology_rounded, color: AppColors.primaryNeon),

                  title: Text('Parcours actuel', style: TextStyle(color: onSurface, fontWeight: FontWeight.bold)),

                  subtitle: Text(

                    QuizService.currentPathCode == 'NONE' ? 'À sélectionner au lancement' : QuizService.currentPathName, 

                    style: TextStyle(color: onSurface.withValues(alpha: 0.6))

                  ),

                  trailing: Icon(Icons.chevron_right_rounded, color: onSurface.withValues(alpha: 0.1)),

                  onTap: onChangePath,

                ),

                Divider(color: onSurface.withValues(alpha: 0.05), height: 1),

                ListTile(

                  leading: const Icon(Icons.history_rounded, color: AppColors.primaryNeon),

                  title: Text('Historique des tests', style: TextStyle(color: onSurface, fontWeight: FontWeight.bold)),

                  subtitle: Text('Visualisez vos scores passés', style: TextStyle(color: onSurface.withValues(alpha: 0.38), fontSize: 11)),

                  trailing: Icon(Icons.chevron_right_rounded, color: onSurface.withValues(alpha: 0.1)),

                  onTap: () => Navigator.push(

                    context, 

                    MaterialPageRoute(builder: (context) => const HistoryScreen())

                  ),

                ),

                Divider(color: onSurface.withValues(alpha: 0.05), height: 1),

                ListTile(

                  leading: const Icon(Icons.menu_book_rounded, color: AppColors.primaryNeon),

                  title: Text('Mode d\'emploi', style: TextStyle(color: onSurface, fontWeight: FontWeight.bold)),

                  trailing: Icon(Icons.open_in_new_rounded, color: onSurface.withValues(alpha: 0.1), size: 18),

                  onTap: () => Navigator.push(

                    context, 

                    MaterialPageRoute(builder: (context) => const UserGuideScreen())

                  ),

                ),

              ],

            ),

          ),

          

          const SizedBox(height: 24),

          

          // Section: Support & Aide

          _buildSectionHeader(context, 'ASSISTANCE'),

          GlassCard(

            child: Column(

              children: [

                ListTile(

                  leading: const Icon(Icons.support_agent_rounded, color: AppColors.primaryNeon),

                  title: Text('Contacter l\'assistance', style: TextStyle(color: onSurface, fontWeight: FontWeight.bold)),

                  onTap: _contactSupport,

                ),

                Divider(color: onSurface.withValues(alpha: 0.05), height: 1),

                ListTile(

                  leading: const Icon(Icons.info_outline_rounded, color: AppColors.primaryNeon),

                  title: Text('À propos', style: TextStyle(color: onSurface, fontWeight: FontWeight.bold)),

                  subtitle: Text('Version 1.0.0 (Révision 2024)', style: TextStyle(color: onSurface.withValues(alpha: 0.38), fontSize: 11)),

                  trailing: Icon(Icons.chevron_right_rounded, color: onSurface.withValues(alpha: 0.1)),

                  onTap: () => Navigator.push(

                    context, 

                    MaterialPageRoute(builder: (context) => const AboutScreen())

                  ),

                ),

              ],

            ),

          ),

          

          const SizedBox(height: 48),

          

          // Section: Danger Zone

          _buildSectionHeader(context, 'GESTION DES DONNÉES'),

          GlassCard(

            child: ListTile(

              leading: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),

              title: const Text('Effacer les données', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),

              onTap: () => _resetProgress(context),

            ),

          ),

          

          const SizedBox(height: 120), // Padding for bottom bar

        ],

      ),

    );

  }



  Widget _buildSectionHeader(BuildContext context, String title) {

    return Padding(

      padding: const EdgeInsets.only(left: 4, bottom: 12),

      child: Text(

        title,

        style: TextStyle(

          color: AppColors.getOnSurface(context).withValues(alpha: 0.3),

          fontSize: 11,

          fontWeight: FontWeight.w900,

          letterSpacing: 2,

        ),

      ),

    );

  }

}


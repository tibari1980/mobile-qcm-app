import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';

import '../../core/widgets/glass_card.dart';

import '../../core/widgets/responsive_layout.dart';



class AboutScreen extends StatelessWidget {

  const AboutScreen({super.key});



  Future<void> _launchUrl(String url) async {

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {

      await launchUrl(uri);

    }

  }



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

                  'À PROPOS',

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4, color: onSurface),

                ),

              ],

            ),

            const SizedBox(height: 48),

            

            Expanded(

              child: ListView(

                physics: const BouncingScrollPhysics(),

                children: [

                  _buildProfileCard(context),

                  const SizedBox(height: 32),

                  _buildContactSection(context),

                  const SizedBox(height: 32),

                  _buildAppInfo(context),

                  const SizedBox(height: 40),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }



  Widget _buildProfileCard(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    return GlassCard(

      child: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          children: [

            Container(

              width: 80,

              height: 80,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                gradient: LinearGradient(

                  colors: [AppColors.primaryNeon, AppColors.primaryNeon.withValues(alpha: 0.5)],

                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,

                ),

                boxShadow: [

                  BoxShadow(color: AppColors.primaryNeon.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2),

                ],

              ),

              child: const Icon(Icons.person_rounded, color: Colors.white, size: 40),

            ),

            const SizedBox(height: 20),

            Text(

              'ZEROUAL TIBARI',

              style: TextStyle(color: onSurface, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2),

            ),

            const SizedBox(height: 4),

            Text(

              'INGÉNIEUR FULL STACK',

              style: TextStyle(color: AppColors.primaryNeon.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),

            ),

            const SizedBox(height: 24),

            Text(

              'Développeur passionné par les solutions innovantes et l\'accessibilité numérique. Créateur de CiviqQuiz pour accompagner les futurs citoyens français.',

              textAlign: TextAlign.center,

              style: TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),

            ),

          ],

        ),

      ),

    );

  }



  Widget _buildContactSection(BuildContext context) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        const Padding(

          padding: EdgeInsets.only(left: 8, bottom: 16),

          child: Text(

            'COORDONNÉES PROFESSIONNELLES',

            style: TextStyle(color: AppColors.primaryNeon, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),

          ),

        ),

        GlassCard(

          child: Column(

            children: [

              _buildContactItem(context, Icons.phone_iphone_rounded, 'Téléphone', '+33 6 25 49 16 40', () => _launchUrl('tel:+33625491640')),

              Divider(color: AppColors.getOnSurface(context).withValues(alpha: 0.05), height: 1, indent: 50),

              _buildContactItem(context, Icons.alternate_email_rounded, 'Email Support', 'support@civiqquiz.com', () => _launchUrl('mailto:support@civiqquiz.com')),

              Divider(color: AppColors.getOnSurface(context).withValues(alpha: 0.05), height: 1, indent: 50),

              _buildContactItem(context, Icons.email_outlined, 'Email Contact', 'contact@civiqquiz.com', () => _launchUrl('mailto:contact@civiqquiz.com')),

            ],

          ),

        ),

      ],

    );

  }



  Widget _buildContactItem(BuildContext context, IconData icon, String label, String value, VoidCallback onTap) {

    final onSurface = AppColors.getOnSurface(context);

    return Semantics(

      button: true,

      label: '$label : $value. Tapez deux fois pour lancer l\'action.',

      child: ListTile(

        onTap: onTap,

        leading: Container(

          padding: const EdgeInsets.all(8),

          decoration: BoxDecoration(color: onSurface.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),

          child: Icon(icon, color: onSurface.withValues(alpha: 0.7), size: 18),

        ),

        title: Text(label, style: TextStyle(color: onSurface.withValues(alpha: 0.24), fontSize: 10, fontWeight: FontWeight.bold)),

        subtitle: Text(value, style: TextStyle(color: onSurface, fontSize: 14, fontWeight: FontWeight.w900)),

        trailing: Icon(Icons.open_in_new_rounded, color: onSurface.withValues(alpha: 0.24), size: 14),

      ),

    );

  }



  Widget _buildAppInfo(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    return Center(

      child: Column(

        children: [

          Text(

            'VERSION APPLICATION',

            style: TextStyle(color: onSurface.withValues(alpha: 0.1), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 3),

          ),

          const SizedBox(height: 8),

          Text(

            'CIVIQQUIZ (OFFICIEL)',

            style: TextStyle(color: onSurface.withValues(alpha: 0.2), fontSize: 11, fontWeight: FontWeight.bold),

          ),

        ],

      ),

    );

  }

}


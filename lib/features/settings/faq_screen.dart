import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

import '../../core/widgets/glass_card.dart';

import '../../core/widgets/responsive_layout.dart';



class FAQScreen extends StatelessWidget {

  const FAQScreen({super.key});



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

                  'AIDE & FAQ',

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4, color: onSurface),

                ),

              ],

            ),

            const SizedBox(height: 40),

            

            Expanded(

              child: ListView(

                physics: const BouncingScrollPhysics(),

                children: [

                  _buildFAQSection(context, 'L\'EXAMEN CIVIQUE 2026', [

                    _buildFAQItem(

                      context,

                      'Combien y a-t-il de questions ?',

                      'L\'examen de naturalisation comporte désormais 40 questions au total (28 connaissances générales et 12 mises en situation).',

                    ),

                    _buildFAQItem(

                      context,

                      'Quel score faut-il pour réussir ?',

                      'Vous devez obtenir un minimum de 32 bonnes réponses sur 40 (soit 80% de réussite).',

                    ),

                    _buildFAQItem(

                      context,

                      'Combien de temps dure l\'épreuve ?',

                      'La durée maximale autorisée pour répondre aux 40 questions est de 45 minutes.',

                    ),

                    _buildFAQItem(

                      context,

                      'Quelle est la durée de validité ?',

                      'Une fois obtenu, le certificat de réussite à l\'examen civique est valable à vie.',

                    ),

                  ]),

                  

                  const SizedBox(height: 32),

                  _buildFAQSection(context, 'PROGRESSION DANS L\'APP', [

                    _buildFAQItem(

                      context,

                      'Comment gagner de l\'XP ?',

                      'Chaque bonne réponse vous rapporte des points. Terminer un quiz complet vous donne un bonus d\'XP basé sur votre score.',

                    ),

                    _buildFAQItem(

                      context,

                      'À quoi servent les niveaux ?',

                      'Les niveaux débloquent de nouveaux défis et reflètent votre préparation. 1000 XP sont nécessaires pour passer au niveau supérieur.',

                    ),

                    _buildFAQItem(

                      context,

                      'Puis-je réinitialiser mes stats ?',

                      'Oui, dans les Paramètres, une option permet de supprimer votre historique et de repartir de zéro.',

                    ),

                  ]),

                  

                  const SizedBox(height: 32),

                  _buildFAQSection(context, 'SÉCURITÉ & DONNÉES', [

                    _buildFAQItem(

                      context,

                      'Mes données sont-elles partagées ?',

                      'Absolument pas. CiviqQuiz Révision utilise un stockage 100% local. Aucune donnée ne quitte votre téléphone.',

                    ),

                    _buildFAQItem(

                      context,

                      'L\'app fonctionne-t-elle sans internet ?',

                      'Oui, une fois les questions chargées au premier démarrage, l\'application est totalement utilisable hors-ligne.',

                    ),

                  ]),

                  

                  const SizedBox(height: 48),

                  Center(

                    child: Text(

                      'BESOIN D\'AIDE SUPPLÉMENTAIRE ?',

                      style: TextStyle(color: onSurface.withValues(alpha: 0.24), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),

                    ),

                  ),

                  const SizedBox(height: 16),

                  Center(

                    child: Column(

                      children: [

                        Text(

                          '+33 6 25 49 16 40',

                          style: TextStyle(color: AppColors.primaryNeon.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w900),

                        ),

                        const SizedBox(height: 8),

                        Text(

                          'support@civiqquiz.com',

                          style: TextStyle(color: onSurface.withValues(alpha: 0.38), fontSize: 13, fontWeight: FontWeight.w500),

                        ),

                      ],

                    ),

                  ),

                  const SizedBox(height: 40),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }



  Widget _buildFAQSection(BuildContext context, String title, List<Widget> items) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Padding(

          padding: const EdgeInsets.only(left: 8, bottom: 16),

          child: Text(

            title,

            style: const TextStyle(color: AppColors.primaryNeon, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),

          ),

        ),

        GlassCard(

          child: Column(children: items),

        ),

      ],

    );

  }



  Widget _buildFAQItem(BuildContext context, String question, String answer) {

    final onSurface = AppColors.getOnSurface(context);

    return Semantics(

      container: true,

      label: 'Question : $question. Cliquez pour voir la réponse.',

      child: Theme(

        data: ThemeData(dividerColor: Colors.transparent),

        child: ExpansionTile(

          title: Text(

            question,

            style: TextStyle(color: onSurface, fontSize: 14, fontWeight: FontWeight.bold),

          ),

          iconColor: AppColors.primaryNeon,

          collapsedIconColor: onSurface.withValues(alpha: 0.24),

          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          children: [

            Semantics(

              label: 'Réponse : $answer',

              child: Padding(

                padding: const EdgeInsets.only(bottom: 16),

                child: Text(

                  answer,

                  style: TextStyle(color: onSurface.withValues(alpha: 0.6), fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}


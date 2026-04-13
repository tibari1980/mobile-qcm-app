import 'package:flutter/material.dart';

import '../constants/app_colors.dart';



class PremiumDrawer extends StatelessWidget {

  const PremiumDrawer({super.key});



  @override

  Widget build(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    final surface = AppColors.getSurface(context);

    

    return Drawer(

      backgroundColor: Colors.transparent,

      elevation: 0,

      width: MediaQuery.of(context).size.width * 0.85,

      child: Container(

        decoration: BoxDecoration(

          color: surface.withValues(alpha: 0.98),

          border: Border(right: BorderSide(color: onSurface.withValues(alpha: 0.1))),

        ),

        child: Column(

          children: [

            _buildHeader(context),

            const SizedBox(height: 24),

            Expanded(

              child: ListView(

                padding: const EdgeInsets.symmetric(horizontal: 16),

                children: [

                  _MenuItem(

                    icon: Icons.dashboard_rounded,

                    title: 'TABLEAU DE BORD',

                    onTap: () => Navigator.pop(context),

                    isSelected: true,

                    onSurface: onSurface,

                  ),

                  _MenuItem(

                    icon: Icons.school_rounded,

                    title: 'SIMULATION EXAMEN',

                    onTap: () {

                      Navigator.pop(context);

                    },

                    onSurface: onSurface,

                  ),

                  _MenuItem(

                    icon: Icons.map_rounded,

                    title: 'PARCOURS CITOYEN',

                    onTap: () => Navigator.pop(context),

                    onSurface: onSurface,

                  ),

                  _MenuItem(

                    icon: Icons.location_on_rounded,

                    title: 'CENTRES D\'EXAMEN',

                    onTap: () => Navigator.pop(context),

                    onSurface: onSurface,

                  ),

                  Padding(

                    padding: const EdgeInsets.symmetric(vertical: 20),

                    child: Divider(color: onSurface.withValues(alpha: 0.05), indent: 16, endIndent: 16),

                  ),

                  _MenuItem(

                    icon: Icons.support_agent_rounded,

                    title: 'SUPPORT & AIDE',

                    onTap: () => Navigator.pop(context),

                    onSurface: onSurface,

                  ),

                  _MenuItem(

                    icon: Icons.info_outline_rounded,

                    title: 'À PROPOS',

                    onTap: () => Navigator.pop(context),

                    onSurface: onSurface,

                  ),

                ],

              ),

            ),

            _buildFooter(context),

          ],

        ),

      ),

    );

  }



  Widget _buildHeader(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    return Container(

      padding: EdgeInsets.only(

        top: MediaQuery.of(context).padding.top + 32,

        bottom: 32,

        left: 24,

        right: 24,

      ),

      decoration: BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [

            AppColors.primary.withValues(alpha: 0.1),

            AppColors.getSurface(context).withValues(alpha: 0),

          ],

        ),

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Container(

                width: 64,

                height: 64,

                decoration: BoxDecoration(

                  shape: BoxShape.circle,

                  gradient: AppColors.primary3DGradient,

                  boxShadow: [

                    BoxShadow(

                      color: AppColors.primaryNeon.withValues(alpha: 0.4),

                      blurRadius: 20,

                      spreadRadius: 2,

                    ),

                  ],

                ),

                child: Padding(

                  padding: const EdgeInsets.all(12),

                  child: Image.asset(

                    'assets/images/marianne_logo.png',

                    fit: BoxFit.contain,

                  ),

                ),

              ),

              const SizedBox(width: 16),

              Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(

                    'CIVIQQUIZ',

                    style: TextStyle(

                      color: onSurface,

                      fontSize: 22,

                      fontWeight: FontWeight.w900,

                      letterSpacing: 2,

                    ),

                  ),

                  const Text(

                    'OFFICIEL',

                    style: TextStyle(

                      color: AppColors.primaryNeon,

                      fontSize: 12,

                      fontWeight: FontWeight.w900,

                      letterSpacing: 3,

                    ),

                  ),

                ],

              ),

            ],

          ),

          const SizedBox(height: 32),

          Container(

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color: onSurface.withValues(alpha: 0.03),

              borderRadius: BorderRadius.circular(16),

              border: Border.all(color: onSurface.withValues(alpha: 0.05)),

            ),

            child: Row(

              children: [

                const CircleAvatar(

                  backgroundColor: AppColors.primary,

                  radius: 12,

                  child: Icon(Icons.person, color: Colors.white, size: 14),

                ),

                const SizedBox(width: 12),

                Text(

                  'Utilisateur Premium',

                  style: TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w600),

                ),

                const Spacer(),

                const Icon(Icons.verified_rounded, color: AppColors.primaryNeon, size: 16),

              ],

            ),

          ),

        ],

      ),

    );

  }



  Widget _buildFooter(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    return Container(

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(

        border: Border(top: BorderSide(color: onSurface.withValues(alpha: 0.05))),

      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(

            'v1.0.0',

            style: TextStyle(color: onSurface.withValues(alpha: 0.24), fontSize: 10, fontWeight: FontWeight.w900),

          ),

          Text(

            'LIBERTÉ â€¢ ÉGALITÉ â€¢ FRATERNITÉ',

            style: TextStyle(

              color: onSurface.withValues(alpha: 0.08),

              fontSize: 8,

              fontWeight: FontWeight.w900,

              letterSpacing: 1,

            ),

          ),

        ],

      ),

    );

  }

}



class _MenuItem extends StatelessWidget {

  final IconData icon;

  final String title;

  final VoidCallback onTap;

  final bool isSelected;

  final Color onSurface;



  const _MenuItem({

    required this.icon,

    required this.title,

    required this.onTap,

    required this.onSurface,

    this.isSelected = false,

  });



  @override

  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 8),

      child: Material(

        color: Colors.transparent,

        child: InkWell(

          onTap: onTap,

          borderRadius: BorderRadius.circular(16),

          child: AnimatedContainer(

            duration: const Duration(milliseconds: 200),

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(16),

              gradient: isSelected

                  ? LinearGradient(

                      colors: [

                        AppColors.primary.withValues(alpha: 0.2),

                        AppColors.primary.withValues(alpha: 0.05),

                      ],

                    )

                  : null,

              border: isSelected ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,

            ),

            child: Row(

              children: [

                Icon(

                  icon,

                  color: isSelected ? AppColors.primaryNeon : onSurface.withValues(alpha: 0.54),

                  size: 20,

                ),

                const SizedBox(width: 16),

                Text(

                  title,

                  style: TextStyle(

                    color: isSelected ? onSurface : onSurface.withValues(alpha: 0.6),

                    fontSize: 11,

                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,

                    letterSpacing: 1.5,

                  ),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}


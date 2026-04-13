import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/widgets/animated_brand_text.dart';
import 'study_data.dart';
import 'study_detail_screen.dart';
import '../../core/services/stats_service.dart';

class StudySelectionScreen extends StatelessWidget {
  const StudySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);

    return ResponsiveLayout(
      showParticles: true,
      useSafeArea: true,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 24.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: AnimatedBrandText(
                text: 'APPRENTISSAGE',
                fontSize: 14,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primaryNeon, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 12),
                Text(
                  'Livret du Citoyen',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w900,
                    color: onSurface,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              "Maîtrisez le référentiel officiel du Ministère de l'Intérieur pour l'entretien d'assimilation.",
              style: TextStyle(
                fontSize: 15.sp,
                color: onSurface.withValues(alpha: 0.5),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40.h),
            
            // THEMES GRID
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.82,
              ),
              itemCount: StudyData.themes.length,
              itemBuilder: (context, index) {
                final theme = StudyData.themes[index];
                return _buildPremiumThemeCard(context, theme);
              },
            ),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }


  Widget _buildPremiumThemeCard(BuildContext context, StudyTheme theme) {
    final onSurface = AppColors.getOnSurface(context);
    
    return FutureBuilder<double>(
      future: StatsService.getThemeProgression(theme.id),
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0.0;
        
        return GlassCard(
          padding: EdgeInsets.zero,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StudyDetailScreen(theme: theme)),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: theme.primaryColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: theme.primaryColor.withValues(alpha: 0.2), blurRadius: 15),
                    ],
                  ),
                  child: Icon(theme.icon, color: theme.primaryColor, size: 30.r),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    theme.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: onSurface,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Stack(
                    children: [
                      Container(height: 4, width: double.infinity, decoration: BoxDecoration(color: onSurface.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(2))),
                      Container(
                        height: 4,
                        width: 100 * progress, 
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [BoxShadow(color: theme.primaryColor.withValues(alpha: 0.5), blurRadius: 4)],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${(progress * 100).toInt()}% MAÎTRISÉ',
                  style: TextStyle(
                    color: onSurface.withValues(alpha: 0.3),
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class PremiumBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PremiumBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Widget navbarContent = Row(
      children: [
        _buildNavItem(context, 0, Icons.home_rounded, 'ACCUEIL', 'Aller à l\'accueil'),
        _buildNavItem(context, 1, Icons.flag_rounded, 'QUIZ', 'Commencer un quiz'),
        _buildNavItem(context, 2, Icons.auto_stories_rounded, 'LIVRET', 'Réviser le livret du citoyen'),
        _buildNavItem(context, 3, Icons.leaderboard_rounded, 'STATS', 'Voir mes statistiques'),
        _buildNavItem(context, 4, Icons.settings_rounded, 'PARAMS', 'Paramètres de l\'application'),
      ],
    );

    return Container(
      height: 85.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.surfaceContainerHighest.withValues(alpha: kIsWeb ? 0.95 : 0.6)
            : Colors.white.withValues(alpha: kIsWeb ? 0.95 : 0.7),
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: onSurface.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 40.r,
            offset: Offset(0, 20.h),
          ),
          BoxShadow(
            color: AppColors.primaryNeon.withValues(alpha: 0.05),
            blurRadius: 10.r,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: kIsWeb 
          ? navbarContent 
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: navbarContent,
            ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, String semantics) {
    final isSelected = currentIndex == index;
    final onSurface = AppColors.getOnSurface(context);
    final color = isSelected ? AppColors.primaryNeon : onSurface.withValues(alpha: 0.3);

    return Expanded(
      child: Semantics(
        label: semantics,
        button: true,
        selected: isSelected,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap(index);
          },
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            transformAlignment: Alignment.center,
            transform: (isSelected && !kIsWeb) 
                ? Matrix4.translationValues(0.0, -4.0, 0.0) 
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: isSelected ? onSurface.withValues(alpha: 0.03) : Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20.r,
                ),
                SizedBox(height: 4.h),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    width: 4.r,
                    height: 4.r,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryNeon,
                      shape: BoxShape.circle,
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

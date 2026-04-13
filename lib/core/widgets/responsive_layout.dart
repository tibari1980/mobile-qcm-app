import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'background_particles.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final bool showParticles;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;
  final bool useSafeArea;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.showParticles = true,
    this.accentColor,
    this.padding,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surfaceDarker,
          ],
        ),
      ),
      child: Stack(
        children: [
          if (showParticles)
            const Positioned.fill(
              child: IgnorePointer(
                child: BackgroundParticles(),
              ),
            ),
          
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                try {
                  final screenWidth = MediaQuery.of(context).size.width;
                  double preferredWidth = screenWidth > 800 ? 800 : screenWidth;
                  
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: preferredWidth.clamp(320.0, 800.0), 
                    ),
                    child: Padding(
                      padding: padding ?? EdgeInsets.zero,
                      child: useSafeArea ? SafeArea(child: child) : child,
                    ),
                  );
                } catch (e) {
                  // Data might not exist yet, ignoring gracefully.
                  return child;
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}

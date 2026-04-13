import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Color? backgroundColor;

  const GlassCard({
    super.key, 
    required this.child, 
    this.onTap, 
    this.semanticsLabel,
    this.padding,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Widget content = Padding(
      padding: padding ?? const EdgeInsets.all(20.0),
      child: child,
    );

    return Semantics(
      label: semanticsLabel ?? (onTap != null ? 'Carte interactive' : null),
      button: onTap != null,
      container: true,
      enabled: true,
      child: Card(
        elevation: 0,
        color: backgroundColor ?? onSurface.withValues(alpha: isDark ? 0.05 : 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: borderColor ?? onSurface.withValues(alpha: 0.1)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: kIsWeb 
              ? content 
              : BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: content,
                ),
        ),
      ),
    );
  }
}

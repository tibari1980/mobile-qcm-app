import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/services/quiz_service.dart';
import '../../core/services/stats_service.dart';
import '../eligibility/eligibility_screen.dart';

class LandingScreen extends StatefulWidget {
  final VoidCallback? onSelection;
  final VoidCallback? onSettingsTap;

  const LandingScreen({super.key, this.onSelection, this.onSettingsTap});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _isChangingPath = false;
  bool _isEligibilityVerified = true;

  @override
  void initState() {
    super.initState();
    _checkEligibility();
  }

  Future<void> _checkEligibility() async {
    final verified = await StatsService.isEligibilityVerified();
    if (mounted) {
      setState(() => _isEligibilityVerified = verified);
    }
  }

  void _handleSelection(String name, String code, int threshold) async {
    QuizService.setPath(name, code, threshold);
    await StatsService.saveSelectedPathway(name, code, threshold);
    await StatsService.setFirstRunComplete();
    
    if (mounted) {
      setState(() {
        _isChangingPath = false;
      });
    }
    
    widget.onSelection?.call();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmall = screenWidth < 360;
    final onSurface = AppColors.getOnSurface(context);
    final String currentPath = QuizService.currentPathCode;
    final bool hasSelection = currentPath != 'NONE';
    final bool showOnlyActive = hasSelection && !_isChangingPath;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildStitchTopBar(context),
            if (!_isEligibilityVerified && !showOnlyActive) ...[
              SizedBox(height: 16.h),
              _buildEligibilityBanner(context),
            ],
            SizedBox(height: 24.h),
            
            _buildHeroSection(context),
            SizedBox(height: 32.h),
            
            Semantics(
              header: true,
              child: Text(
                showOnlyActive ? 'VOTRE PARCOURS\nACTUEL' : 'BIENVENUE SUR CIVIQ\nQUIZ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: onSurface,
                  letterSpacing: 1.w,
                  height: 1.15,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              showOnlyActive 
                  ? 'Concentrez-vous sur votre objectif\net atteignez l\'excellence.'
                  : 'Réussissez votre examen\ncivique français.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.5),
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),

            // Conditional pathway cards
            if (!showOnlyActive || currentPath == 'NAT') ...[
              _buildStitchSelectionCard(
                context: context,
                title: 'NATURALISATION',
                subtitle: 'Accédez au parcours\ncitoyen complet',
                imagePath: 'assets/images/french_id_card.png',
                color: AppColors.accentPurpleNeon,
                glowColor: AppColors.getPurpleGlow(context),
                isSmall: isSmall,
                onTap: () => _handleSelection('NATURALISATION', 'NAT', 80),
              ),
              if (!showOnlyActive) SizedBox(height: 16.h),
            ],
            
            if (!showOnlyActive || currentPath == 'CR') ...[
              _buildStitchSelectionCard(
                context: context,
                title: 'CARTE DE\nRÉSIDENT\n(CR)',
                subtitle: 'Préparez votre\ninstallation durable',
                imagePath: 'assets/images/french_resident.png',
                color: AppColors.primaryNeon,
                glowColor: AppColors.getCyanGlow(context),
                isSmall: isSmall,
                showArrow: true,
                onTap: () => _handleSelection('CR (RÉSIDENT)', 'CR', 75),
              ),
              if (!showOnlyActive) SizedBox(height: 16.h),
            ],
            
            if (!showOnlyActive || currentPath == 'CSP') ...[
              _buildStitchSelectionCard(
                context: context,
                title: 'SÉJOUR\nPLURIANNUELLE\n(CSP)',
                subtitle: 'Questions clés pour votre\nrenouvellement',
                imagePath: 'assets/images/french_sejour.png',
                color: AppColors.successGreenNeon,
                glowColor: AppColors.getGreenGlow(context),
                isSmall: isSmall,
                onTap: () => _handleSelection('CSP (SÉJOUR)', 'CSP', 60),
              ),
            ],

            // Action Button to change pathway
            if (showOnlyActive) ...[
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => setState(() => _isChangingPath = true),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: onSurface.withValues(alpha: 0.1), width: 1.5),
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                  ),
                  child: Text(
                    'MODIFIER LE PARCOURS',
                    style: TextStyle(
                      color: onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w900,
                      fontSize: 12.sp,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
            
            SizedBox(height: 32.h),
            _buildStitchBadge(context, isSmall),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEligibilityBanner(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);
    return GlassCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      borderColor: AppColors.warningYellowNeon.withValues(alpha: 0.3),
      backgroundColor: AppColors.warningYellowNeon.withValues(alpha: 0.05),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.warningYellowNeon.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.help_outline_rounded, color: AppColors.warningYellowNeon, size: 20.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PAS SUR DU PARCOURS ?',
                  style: TextStyle(
                    color: AppColors.warningYellowNeon,
                    fontWeight: FontWeight.w900,
                    fontSize: 10.sp,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Faites le test d\'éligibilité 2026.',
                  style: TextStyle(
                    color: onSurface.withValues(alpha: 0.7),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const EligibilityScreen())
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              backgroundColor: AppColors.warningYellowNeon.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text(
              'TESTER',
              style: TextStyle(
                color: AppColors.warningYellowNeon,
                fontWeight: FontWeight.w900,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStitchTopBar(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(shape: BoxShape.circle, color: onSurface.withValues(alpha: 0.1)),
                child: Icon(Icons.person_outline_rounded, color: onSurface, size: 16.r),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'RÉPUBLIQUE',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10.sp, letterSpacing: 3.w, color: onSurface),
                ),
              ),
            ],
          ),
        ),
        Semantics(
          label: 'Ouvrir les paramètres',
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.settings_outlined, color: onSurface.withValues(alpha: 0.7), size: 20.r),
            onPressed: widget.onSettingsTap,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final double size = 160.r;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size + 40.r,
          height: size + 40.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryNeon.withValues(alpha: 0.12),
                blurRadius: 80,
                spreadRadius: 20,
              ),
            ],
          ),
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.getOnSurface(context).withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                offset: const Offset(0, 16),
                blurRadius: 40,
              ),
              BoxShadow(
                color: AppColors.primaryNeon.withValues(alpha: 0.08),
                blurRadius: 24,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              'assets/images/marianne_3d.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStitchSelectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imagePath,
    required Color color,
    required Color glowColor,
    required bool isSmall,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    final onSurface = AppColors.getOnSurface(context);
    final double imageSize = isSmall ? 70.r : 90.r;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Semantics(
        label: '$title. $subtitle. Sélectionner ce parcours.',
        button: true,
        child: GlassCard(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: isSmall ? 14.h : 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: color.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: _Animated3DCard(
                      imagePath: imagePath,
                      color: color,
                      size: imageSize,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: onSurface,
                            fontSize: isSmall ? 13.sp : 15.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5.w,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: onSurface.withValues(alpha: 0.5),
                            fontSize: isSmall ? 10.sp : 11.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showArrow)
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: onSurface.withValues(alpha: 0.05),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: onSurface.withValues(alpha: 0.3),
                          size: 12.r,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStitchBadge(BuildContext context, bool isSmall) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryNeon.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: AppColors.primaryNeon, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            'CONTENU OFFICIEL 2026',
            style: TextStyle(color: AppColors.getOnSurface(context), fontSize: isSmall ? 7 : 8, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _Animated3DCard extends StatefulWidget {
  final String imagePath;
  final Color color;
  final double size;

  const _Animated3DCard({
    required this.imagePath,
    required this.color,
    required this.size,
  });

  @override
  State<_Animated3DCard> createState() => _Animated3DCardState();
}

class _Animated3DCardState extends State<_Animated3DCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    if (!kIsWeb) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: widget.color.withValues(alpha: 0.08),
            blurRadius: 40,
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          widget.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: widget.color.withValues(alpha: 0.1),
            child: Icon(Icons.credit_card_rounded, color: widget.color, size: widget.size * 0.4),
          ),
        ),
      ),
    );

    if (kIsWeb) return card;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return RepaintBoundary(
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002) 
              ..rotateY(_animation.value)
              ..rotateX(_animation.value * 0.5),
            alignment: Alignment.center,
            child: card,
          ),
        );
      },
    );
  }
}

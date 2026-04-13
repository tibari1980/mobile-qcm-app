import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/widgets/animated_brand_text.dart';
import '../../core/services/quiz_service.dart';
import '../../core/services/stats_service.dart';
import '../../core/widgets/glass_card.dart';
import '../eligibility/eligibility_screen.dart';
import 'intro_model.dart';

// Safe ScreenUtil helpers to prevent NaN/infinite crashes on Web
double _safeH(double v) { try { final s = v.h; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }
double _safeW(double v) { try { final s = v.w; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }
double _safeR(double v) { try { final s = v.r; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }
double _safeSp(double v) { try { final s = v.sp; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnimation = CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToApp(int index) async {
    await StatsService.setFirstRunComplete();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/main', 
        (route) => false, 
        arguments: index
      );
    }
  }

  void _nextStep() async {
    if (_currentIndex < introData.length - 1) {
      setState(() => _currentIndex++);
      _animationController.reset();
      _animationController.forward();
    } else {
      _navigateToApp(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final step = introData[_currentIndex];
    final isSmall = MediaQuery.sizeOf(context).width < 600;
    final onSurface = AppColors.getOnSurface(context);

    return Scaffold(
      backgroundColor: AppColors.getSurface(context),
      resizeToAvoidBottomInset: false,
      body: ResponsiveLayout(
        showParticles: true,
        padding: EdgeInsets.zero,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildStitchHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: _safeW(24)),
                  child: Column(
                    children: [
                      SizedBox(height: _safeH(20)),
                      _buildHeroVisual(step.imagePath),
                      SizedBox(height: _safeH(48)),
                      
                      AnimatedBrandText(
                        text: 'CIVIQQUIZ',
                        fontSize: isSmall ? _safeSp(28) : _safeSp(36),
                        letterSpacing: _safeW(2),
                        height: 1.1,
                      ),
                      
                      SizedBox(height: _safeH(24)),
                      
                      Text(
                        'Une préparation immersive pour votre carte de séjour ou nationalité. Maîtrisez l\'histoire et les valeurs de la République.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: onSurface.withValues(alpha: 0.5),
                          fontSize: isSmall ? _safeSp(11) : _safeSp(13),
                          height: 1.6,
                        ),
                      ),

                      SizedBox(height: _safeH(40)),

                      // Main Action Buttons
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: _safeW(20)),
                        child: Column(
                          children: [
                            PremiumButton(
                              text: 'COMMENCER L\'EXAMEN',
                              icon: Icons.flash_on_rounded,
                              onPressed: _nextStep,
                            ),
                            SizedBox(height: _safeH(16)),
                            _buildEligibilityButton(context),
                          ],
                        ),
                      ),

                      SizedBox(height: _safeH(48)),

                      // Marketing Social Proof Grid
                      _buildMarketingStats(context),

                      SizedBox(height: _safeH(48)),

                      // 100% OFFICIEL BADGE
                      _buildOfficialBadge(context),

                      SizedBox(height: _safeH(60)),
                      
                      Center(
                        child: Opacity(
                          opacity: 0.15,
                          child: Icon(Icons.account_balance_rounded, color: onSurface, size: _safeR(40)),
                        ),
                      ),
                      
                      SizedBox(height: _safeH(100)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEligibilityButton(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EligibilityScreen()),
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primaryNeon.withValues(alpha: 0.5), width: 1.5),
          padding: EdgeInsets.symmetric(vertical: _safeH(18)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_safeR(20))),
          backgroundColor: AppColors.primaryNeon.withValues(alpha: 0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fact_check_rounded, color: AppColors.primaryNeon, size: _safeR(18)),
            SizedBox(width: _safeW(12)),
            Text(
              'VÉRIFIER MON ÉLIGIBILITÉ',
              style: TextStyle(
                color: onSurface,
                fontWeight: FontWeight.w900,
                fontSize: _safeSp(11),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketingStats(BuildContext context) {
    return FutureBuilder<List>(
      future: QuizService.loadQuestions(),
      builder: (context, snapshot) {
        final count = snapshot.data?.length.toString() ?? '...';
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard(context, count, 'Questions', badge: 'ESSAI GRATUIT', color: AppColors.primaryNeon)),
                SizedBox(width: _safeW(16)),
                Expanded(child: _buildStatCard(context, '20K+', 'Candidats', color: AppColors.accentPurpleNeon)),
              ],
            ),
            SizedBox(height: _safeH(16)),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, '45K+', 'Tests passés', color: AppColors.successGreenNeon)),
                SizedBox(width: _safeW(16)),
                Expanded(child: _buildStatCard(context, '80%', 'Requis pour réussir', badge: 'REQUIS', color: AppColors.warningYellowNeon)),
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, {String? badge, required Color color}) {
    final onSurface = AppColors.getOnSurface(context);
    return GlassCard(
      child: Container(
        constraints: BoxConstraints(minHeight: _safeH(130)), // Use minHeight instead of fixed height
        padding: EdgeInsets.symmetric(horizontal: _safeW(12), vertical: _safeH(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_safeR(24)),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: _safeW(8), vertical: _safeH(4)),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(_safeR(8)),
                ),
                child: Text(
                  badge,
                  style: TextStyle(color: color, fontSize: _safeSp(7), fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
              ),
              SizedBox(height: _safeH(10)),
            ],
            Flexible( // Wrap value in Flexible to handle smaller spaces
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    color: onSurface,
                    fontSize: _safeSp(24),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: _safeH(4)),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.5),
                fontSize: _safeSp(9),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficialBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _safeW(12), vertical: _safeH(10)),
      decoration: BoxDecoration(
        color: AppColors.primaryNeon.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(_safeR(16)),
        border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: AppColors.primaryNeon, size: _safeR(14)),
          SizedBox(width: _safeW(8)),
          FutureBuilder<List>(
            future: QuizService.loadQuestions(),
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 400;
              return Text(
                'CONTENU OFFICIEL 2026 ($count QUESTIONS)',
                style: TextStyle(
                  color: AppColors.primaryNeon,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  fontSize: _safeSp(8),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildStitchHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = AppColors.getOnSurface(context);
    return Padding(
      padding: EdgeInsets.only(
        left: _safeW(24), 
        right: _safeW(24), 
        top: MediaQuery.paddingOf(context).top + _safeH(16), 
        bottom: _safeH(16)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'LIBERTÉ',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.primaryNeon,
                  fontWeight: FontWeight.w900,
                  letterSpacing: _safeW(2),
                ),
              ),
            ),
          ),
          SizedBox(width: _safeW(12)),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: TextButton(
                  onPressed: () => _navigateToApp(0), // Settings Shortcut
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'BIENVENUE',
                    style: textTheme.labelSmall?.copyWith(
                      color: onSurface.withValues(alpha: 0.5), 
                      letterSpacing: _safeW(1),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroVisual(String path) {
    return Semantics(
      label: 'Illustration 3D de la Marianne, symbole de la République Française.',
      image: true,
      child: Container(
        width: double.infinity,
        height: _safeH(280),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_safeR(40)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryNeon.withValues(alpha: 0.1),
              blurRadius: _safeR(100),
              spreadRadius: _safeR(20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_safeR(40)),
          child: Image.asset(
            'assets/images/marianne_3d.png', 
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

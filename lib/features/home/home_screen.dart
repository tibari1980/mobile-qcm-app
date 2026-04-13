import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/services/stats_service.dart';
import '../../core/services/quiz_service.dart';
import '../../core/widgets/premium_button.dart';
import '../quiz/quiz_screen.dart';
import '../settings/settings_screen.dart';
import '../eligibility/eligibility_screen.dart';
import 'models/home_badge.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToQuiz;
  const HomeScreen({super.key, this.onNavigateToQuiz});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _heartbeatController;
  final ScrollController _scrollController = ScrollController();
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _isReady = true);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _heartbeatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon));
    }

    return Container(
      color: AppColors.getSurface(context),
      child: ListView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 10.h),
          _buildPremiumHeader(context),
          
          if (QuizService.currentPathCode == 'NONE') ...[
            SizedBox(height: 100.h),
            _buildSelectionPlaceholder(context),
          ] else ...[
            SizedBox(height: 32.h),
            _buildPremiumHeadline(context),
            SizedBox(height: 24.h),
            _buildEligibilityCard(context),
            SizedBox(height: 24.h),
            _buildPremiumProgressionCard(context),
            SizedBox(height: 24.h),
            _buildPremiumStatsGrid(context),
            SizedBox(height: 32.h),
            _buildActionButtons(context),
            
            SizedBox(height: 40.h),
            _buildPremiumBadgeSection(context),
            
            SizedBox(height: 48.h),
            _buildSectionHeader(context, 'Modules de Révision', 'Sélectionnez un thème pour approfondir'),
            SizedBox(height: 24.h),
            _buildThemesGrid(context),
            SizedBox(height: 120.h),
          ],
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return FutureBuilder<int>(
      future: StatsService.getGlobalXp(),
      builder: (context, snapshot) {
        final xp = snapshot.data ?? 0;
        final onSurface = AppColors.getOnSurface(context);
        return Row(
          children: [
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: onSurface.withValues(alpha: 0.1),
                  border: Border.all(color: onSurface.withValues(alpha: 0.05)),
                ),
                child: Center(
                  child: Icon(Icons.person_outline_rounded, size: 20.r, color: onSurface),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            const Expanded(
              child: Text(
                'CIVIQQUIZ',
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.w900, 
                  fontSize: 14, 
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primaryNeon.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryNeon.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                '$xp XP', 
                style: TextStyle(
                  color: AppColors.primaryNeon, 
                  fontWeight: FontWeight.w900, 
                  fontSize: 12.sp,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPremiumHeadline(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);
    
    // Path-specific content
    String headline;
    String description;
    
    switch (QuizService.currentPathCode) {
      case 'NAT':
        headline = 'Objectif\nNaturalisation';
        description = 'Maîtrisez les 366 questions pour devenir citoyen français.';
        break;
      case 'CR':
        headline = 'Objectif\nRésidence (10 ans)';
        description = 'Préparez votre titre de séjour longue durée avec succès.';
        break;
      case 'CSP':
        headline = 'Objectif\nIntégration';
        description = 'Réussissez votre contrat d\'intégration républicaine.';
        break;
      default:
        headline = 'Prêt pour l\'Examen,\nCitoyen ?';
        description = 'Votre progression actuelle est excellente. Il ne vous reste que quelques modules pour atteindre l\'excellence.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 14.h,
              decoration: BoxDecoration(
                color: AppColors.primaryNeon,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'TABLEAU DE BORD', 
              style: TextStyle(
                color: AppColors.primaryNeon, 
                fontWeight: FontWeight.w900, 
                fontSize: 11.sp, 
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          headline, 
          style: TextStyle(
            color: onSurface, 
            fontSize: 32.sp, 
            fontWeight: FontWeight.w900, 
            height: 1.1,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          description,
          style: TextStyle(
            color: onSurface.withValues(alpha: 0.5),
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumProgressionCard(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: StatsService.getGlobalProgression(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {'answered': 0, 'total': 1};
        final progress = (data['answered']! / (data['total']! > 0 ? data['total']! : 1)).clamp(0.0, 1.0);
        final onSurface = AppColors.getOnSurface(context);
        
        return GlassCard(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PROGRESSION GLOBALE', 
                    style: TextStyle(
                      color: AppColors.primaryNeon, 
                      fontWeight: FontWeight.w900, 
                      fontSize: 10.sp,
                      letterSpacing: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNeon.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: AppColors.primaryNeon,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${data['answered']}', 
                    style: TextStyle(
                      color: onSurface, 
                      fontSize: 40.sp, 
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '/ ${data['total']} questions', 
                    style: TextStyle(
                      color: onSurface.withValues(alpha: 0.4), 
                      fontSize: 16.sp, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Stack(
                children: [
                  Container(
                    height: 10.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: 10.h,
                    width: (MediaQuery.of(context).size.width - 96.w) * progress,
                    decoration: BoxDecoration(
                      gradient: AppColors.primary3DGradient,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryNeon.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPremiumStatsGrid(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: StatsService.getGlobalPerformance(),
      builder: (context, snapshot) {
        final perf = snapshot.data ?? {'average': 0, 'avgTime': 0, 'totalQuizzes': 0};
        return Row(
          children: [
            Expanded(
              child: _buildMiniPremiumStat(
                context,
                'PRÉCISION',
                '${perf['average']}%',
                Icons.bolt_rounded,
                AppColors.primaryNeon,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildMiniPremiumStat(
                context,
                'TEMPS MOY.',
                '${perf['avgTime']}s',
                Icons.timer_rounded,
                AppColors.accentPurpleNeon,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMiniPremiumStat(BuildContext context, String label, String value, IconData icon, Color color) {
    final onSurface = AppColors.getOnSurface(context);
    return GlassCard(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 18.r),
          ),
          SizedBox(height: 16.h),
          Text(
            value, 
            style: TextStyle(
              color: onSurface, 
              fontSize: 22.sp, 
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label, 
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.4), 
              fontSize: 10.sp, 
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBadgeSection(BuildContext context) {
    return FutureBuilder<List<HomeBadge>>(
      future: HomeBadge.getUnlockedBadges(),
      builder: (context, snapshot) {
        final unlocked = snapshot.data ?? [];
        final latest = unlocked.isNotEmpty ? unlocked.last : null;
        final onSurface = AppColors.getOnSurface(context);

        return GlassCard(
          padding: EdgeInsets.all(24.r),
          child: Row(
            children: [
              Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      (latest?.color ?? AppColors.primaryNeon).withValues(alpha: 0.2),
                      AppColors.accentPurpleNeon.withValues(alpha: 0.2),
                    ],
                  ),
                  border: Border.all(color: Colors.white10),
                ),
                child: Center(
                  child: Icon(latest?.icon ?? Icons.lock_outline_rounded, color: latest?.color ?? AppColors.primaryNeon, size: 40.r),
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DERNIER BADGE', 
                      style: TextStyle(
                        color: latest?.color ?? AppColors.primaryNeon, 
                        fontWeight: FontWeight.w900, 
                        fontSize: 10.sp,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      latest?.title ?? 'En attente...', 
                      style: TextStyle(
                        color: onSurface, 
                        fontSize: 18.sp, 
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      latest?.description ?? 'Complétez votre premier quiz pour débloquer votre premier badge officiel.',
                      style: TextStyle(
                        color: onSurface.withValues(alpha: 0.5),
                        fontSize: 12.sp,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String subtitle) {
    final onSurface = AppColors.getOnSurface(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: TextStyle(
            color: onSurface, 
            fontSize: 22.sp, 
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle, 
          style: TextStyle(
            color: onSurface.withValues(alpha: 0.4), 
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60.h,
          child: PremiumButton(
            text: 'ENTRAÎNEMENT RAPIDE',
            icon: Icons.flash_on_rounded,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen(theme: 'random'))),
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          width: double.infinity,
          height: 60.h,
          child: OutlinedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen(theme: 'examen_blanc'))),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryNeon.withValues(alpha: 0.3), width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              backgroundColor: AppColors.primaryNeon.withValues(alpha: 0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_turned_in_rounded, color: AppColors.primaryNeon, size: 20.r),
                SizedBox(width: 12.w),
                Text(
                  'SIMULATION EXAMEN', 
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w900, 
                    fontSize: 14.sp,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemesGrid(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: QuizService.getThemeCounts(),
      builder: (context, snapshot) {
        final counts = snapshot.data ?? {};
        final double width = MediaQuery.of(context).size.width;
        
        final List<Map<String, dynamic>> themes = [
          {'title': 'République', 'icon': Icons.account_balance_rounded, 'key': 'principes', 'color': AppColors.primaryNeon},
          {'title': 'Histoire', 'icon': Icons.history_edu_rounded, 'key': 'histoire', 'color': AppColors.accentPurpleNeon},
          {'title': 'Culture', 'icon': Icons.theater_comedy_rounded, 'key': 'culture', 'color': AppColors.successGreenNeon},
          {'title': 'Institutions', 'icon': Icons.apartment_rounded, 'key': 'institutions', 'color': Colors.orangeAccent},
          {'title': 'Vie Pratique', 'icon': Icons.family_restroom_rounded, 'key': 'vie_pratique', 'color': Colors.lightBlueAccent},
          {'title': 'Géographie', 'icon': Icons.public_rounded, 'key': 'geographie', 'color': Colors.amberAccent},
        ];

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width > 600 ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: themes.length,
          itemBuilder: (context, index) {
            final theme = themes[index];
            return _buildPremiumThemeCard(
              context,
              theme['title'],
              theme['icon'],
              theme['key'],
              counts[theme['key']] ?? 0,
              theme['color'],
            );
          },
        );
      },
    );
  }

  Widget _buildPremiumThemeCard(BuildContext context, String title, IconData icon, String key, int count, Color color) {
    final onSurface = AppColors.getOnSurface(context);
    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(theme: key))),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10),
                ],
              ),
              child: Icon(icon, color: color, size: 28.r),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface, 
                fontSize: 14.sp, 
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '$count QUESTIONS',
              style: TextStyle(
                color: onSurface.withValues(alpha: 0.3), 
                fontSize: 9.sp, 
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.ads_click_rounded, color: AppColors.primaryNeon.withValues(alpha: 0.3), size: 64.r),
          SizedBox(height: 16.h),
          const Text(
            "Sélectionnez un parcours\npour commencer", 
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }


  Widget _buildEligibilityCard(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);
    return GlassCard(
      padding: EdgeInsets.all(24.r),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EligibilityScreen())),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryNeon.withValues(alpha: 0.2), AppColors.accentPurpleNeon.withValues(alpha: 0.2)],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.verified_rounded, color: AppColors.primaryNeon, size: 28.r),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ÉLIGIBILITÉ',
                      style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.w900, fontSize: 10.sp, letterSpacing: 1.5),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.accentRedNeon.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'DÉCRET 2026',
                        style: TextStyle(color: AppColors.accentRedNeon, fontSize: 7.sp, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'Dois-je passer l\'examen ?',
                  style: TextStyle(color: onSurface, fontSize: 16.sp, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Test de diagnostic rapide en 7 étapes.',
                  style: TextStyle(color: onSurface.withValues(alpha: 0.5), fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class HeartbeatPainter extends CustomPainter {
  final double val;
  final double prec;
  HeartbeatPainter(this.val, this.prec);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppColors.primaryNeon..strokeWidth = 1.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    final mid = size.height / 2;
    path.moveTo(0, mid);
    for (int i = 0; i < 6; i++) {
        double x = i * (size.width / 6);
        double w = size.width / 6;
        path.lineTo(x + (val * w * 0.5), mid);
        path.lineTo(x + (val * w * 0.7), mid - 8);
        path.lineTo(x + (val * w), mid);
    }
    canvas.drawPath(path, p);
  }
  @override
  bool shouldRepaint(covariant HeartbeatPainter old) => true;
}

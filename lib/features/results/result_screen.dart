import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/widgets/confetti_painter.dart';
import '../../core/services/quiz_service.dart';
import '../../core/services/stats_service.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/widgets/animated_brand_text.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String theme;
  final int durationSeconds;
  final String sessionId;
  final int sessionXp;
  final Map<String, List<int>> sessionThemeStats;

  const ResultScreen({
    super.key, 
    required this.score, 
    required this.total,
    required this.theme,
    required this.durationSeconds,
    required this.sessionId,
    required this.sessionXp,
    required this.sessionThemeStats,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _confettiController;
  Map<String, double> _themeProficiency = {};
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    
    final percentage = (widget.score / widget.total * 100);
    if (percentage >= QuizService.currentThreshold) {
      _confettiController.repeat();
    }
    
    _loadEnhancedStats();
  }

  Future<void> _loadEnhancedStats() async {
    final proficiency = await StatsService.getThemeProficiency();
    if (mounted) {
      setState(() {
        _themeProficiency = proficiency;
        _isLoadingStats = false;
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _getRanking(int percentage) {
    if (percentage >= 95) return 'CITOYEN D\'ÉLITE';
    if (percentage >= 80) return 'AMBASSADEUR RÉPUBLICAIN';
    if (percentage >= 60) return 'CITOYEN ÉMÉRITE';
    if (percentage >= 40) return 'CITOYEN EN DEVENIR';
    return 'DISCIPLE CIVIQUE';
  }

  Color _getRankingColor(int percentage) {
    if (percentage >= QuizService.currentThreshold) return AppColors.successGreenNeon;
    return AppColors.accentRedNeon;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.total > 0 ? widget.total : 1;
    final percentage = (widget.score / total * 100).toInt().clamp(0, 100);
    final isSuccess = percentage >= QuizService.currentThreshold;

    return Scaffold(
      backgroundColor: AppColors.getSurface(context),
      body: ResponsiveLayout(
        showParticles: true,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      children: [
                        _buildMainScoreCard(context, percentage, isSuccess),
                        const SizedBox(height: 32),
                        _buildDetailedStats(context, percentage, isSuccess),
                        const SizedBox(height: 40),
                        _buildThemeAnalysis(context),
                        const SizedBox(height: 40),
                        _buildActions(context, percentage),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isSuccess)
              IgnorePointer(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: ConfettiPainter(animation: _confettiController),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 16, bottom: 16),
      child: const Center(
        child: AnimatedBrandText(
          text: 'RÉSULTATS D\'EXAMEN',
          fontSize: 14,
          letterSpacing: 3,
        ),
      ),
    );
  }

  Widget _buildMainScoreCard(BuildContext context, int percentage, bool isSuccess) {
    final onSurface = AppColors.getOnSurface(context);
    final ranking = _getRanking(percentage);
    final rankingColor = _getRankingColor(percentage);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: rankingColor.withValues(alpha: 0.1),
                  width: 8,
                ),
              ),
            ),
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    rankingColor.withValues(alpha: 0.2),
                    rankingColor.withValues(alpha: 0.05),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: rankingColor.withValues(alpha: 0.1),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: onSurface,
                      ),
                    ),
                    Text(
                      'PRÉCISION',
                      style: TextStyle(
                        color: rankingColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          ranking,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: rankingColor,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isSuccess ? 'Félicitations, vous avez réussi !' : 'Continuez vos efforts, citoyen.',
          style: TextStyle(
            color: onSurface.withValues(alpha: 0.5),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryNeon.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.primaryNeon, size: 20),
              const SizedBox(width: 8),
              Text(
                '+${widget.sessionXp} XP GAGNÉS',
                style: const TextStyle(
                  color: AppColors.primaryNeon,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats(BuildContext context, int percentage, bool isSuccess) {
    final onSurface = AppColors.getOnSurface(context);
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                label: 'RÉUSSITES',
                value: '${widget.score}/${widget.total}',
                color: onSurface,
                onSurface: onSurface,
              ),
              Container(width: 1, height: 40, color: onSurface.withValues(alpha: 0.1)),
              _StatItem(
                label: 'OBJ. MIN.',
                value: '${QuizService.currentThreshold}%',
                color: onSurface.withValues(alpha: 0.5),
                onSurface: onSurface,
              ),
              Container(width: 1, height: 40, color: onSurface.withValues(alpha: 0.1)),
              _StatItem(
                label: 'TEMPS',
                value: '${widget.durationSeconds}s',
                color: onSurface,
                onSurface: onSurface,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeAnalysis(BuildContext context) {
    if (widget.sessionThemeStats.isEmpty) {
      if (_isLoadingStats) return const CircularProgressIndicator(color: AppColors.primaryNeon);
      if (_themeProficiency.isEmpty) return const SizedBox.shrink();
      
      // Fallback to global stats if session stats are empty (shouldn't happen on real sessions)
      final sortedProficiency = _themeProficiency.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      return _buildThemeList(context, 'EXCELLENCE GLOBALE', sortedProficiency.take(3).map((e) => MapEntry(e.key, e.value)).toList());
    }

    final sessionData = widget.sessionThemeStats.entries.map((e) {
      final correct = e.value[0];
      final total = e.value[1];
      final percentage = total > 0 ? (correct / total * 100) : 0.0;
      return MapEntry(e.key, percentage);
    }).toList()..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('ANALYSE DE LA SESSION'),
        const SizedBox(height: 20),
        ...sessionData.map((entry) => _buildThemeProgressRow(context, entry.key, entry.value)),
        
        if (sessionData.any((e) => e.value < 60)) ...[
          const SizedBox(height: 40),
          _buildSectionTitle('POINTS À RENFORCER'),
          const SizedBox(height: 20),
          ...sessionData.where((e) => e.value < 60).take(2).map((entry) => _buildImprovementCard(context, entry.key)),
        ],
      ],
    );
  }

  Widget _buildThemeList(BuildContext context, String title, List<MapEntry<String, double>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 20),
        ...data.map((entry) => _buildThemeProgressRow(context, entry.key, entry.value)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 4, height: 14, decoration: BoxDecoration(color: AppColors.primaryNeon, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryNeon,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeProgressRow(BuildContext context, String theme, double value) {
    final onSurface = AppColors.getOnSurface(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                theme.toUpperCase(),
                style: TextStyle(color: onSurface, fontWeight: FontWeight.w900, fontSize: 13),
              ),
              Text(
                '${value.toInt()}%',
                style: TextStyle(color: AppColors.primaryNeon, fontWeight: FontWeight.w900, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(height: 6, width: double.infinity, decoration: BoxDecoration(color: onSurface.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(3))),
              Container(
                height: 6,
                width: (MediaQuery.of(context).size.width - 48) * (value / 100),
                decoration: BoxDecoration(
                  gradient: AppColors.primary3DGradient,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [BoxShadow(color: AppColors.primaryNeon.withValues(alpha: 0.2), blurRadius: 4)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementCard(BuildContext context, String theme) {
    final onSurface = AppColors.getOnSurface(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.accentRedNeon.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.trending_down_rounded, color: AppColors.accentRedNeon, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.toUpperCase(),
                    style: TextStyle(color: onSurface, fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                  Text(
                    'Renforcez vos connaissances sur ce module.',
                    style: TextStyle(color: onSurface.withValues(alpha: 0.4), fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, int percentage) {
    final onSurface = AppColors.getOnSurface(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 64,
          child: PremiumButton(
            text: 'RETOUR AU MENU',
            icon: Icons.home_rounded,
            onPressed: () async {
              // Result is already auto-saved by QuizController
              Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
            },
          ),
        ),
        const SizedBox(height: 20),
        
        // Premium Share Button
        GestureDetector(
          onTap: () {
            final message = "🇫🇷 J'ai obtenu $percentage% au CiviqQuiz !\n"
                "Parcours : ${QuizService.currentPathName}\n"
                "🎯 Mon score : ${widget.score}/${widget.total}\n"
                "Prêt pour l'excellence républicaine. #CiviqQuiz #France";
            Share.share(message, subject: 'Mon score CiviqQuiz');
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryNeon.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share_rounded, color: AppColors.primaryNeon, size: 20),
                const SizedBox(width: 12),
                Text(
                  'PARTAGER MON SCORE',
                  style: TextStyle(
                    color: onSurface,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color onSurface;
  const _StatItem({required this.label, required this.value, required this.color, required this.onSurface});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: onSurface.withValues(alpha: 0.3), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ],
    );
  }
}

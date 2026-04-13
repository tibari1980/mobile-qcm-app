import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import 'quiz_controller.dart';
import 'quiz_model.dart';
import '../results/result_screen.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/widgets/animated_brand_text.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/services/stats_service.dart';

// Safe ScreenUtil helpers to prevent NaN/infinite crashes on Web
double _safeH(double v) { try { final s = v.h; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }
double _safeW(double v) { try { final s = v.w; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }
double _safeR(double v) { try { final s = v.r; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }
double _safeSp(double v) { try { final s = v.sp; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }

class QuizScreen extends StatefulWidget {
  final String theme;



  const QuizScreen({super.key, required this.theme});



  @override

  State<QuizScreen> createState() => _QuizScreenState();

}



class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {

  late QuizController _controller;

  late AnimationController _entranceController;

  late List<Animation<double>> _choiceAnimations;

  bool _isNavigating = false;



  @override

  void initState() {

    super.initState();

    _controller = QuizController(theme: widget.theme);

    _controller.addListener(_onStateChanged);



    _entranceController = AnimationController(

      vsync: this,

      duration: const Duration(milliseconds: 500),

    );



    _choiceAnimations = List.generate(

      4, // Only 4 choices max in our questions.json

      (index) => CurvedAnimation(

        parent: _entranceController,

        curve: Interval(0.3 + (index * 0.08), 1.0, curve: Curves.easeOutQuart),

      ),

    );



    _entranceController.forward();

  }



  void _onStateChanged() {
    if (mounted) setState(() {});

    // AUTO-NEXT on Timeout

    if (_controller.hasAnswered && _controller.wasTimeout && !_isNavigating) {

      HapticFeedback.vibrate(); // Alert user that time's up

      Future.delayed(const Duration(seconds: 2), () {

        if (mounted && _controller.wasTimeout && !_isNavigating) {

          _onNext();

        }

      });

    }

  }



  void _navigateToResults() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
          ResultScreen(
            score: _controller.score, 
            total: _controller.questions.length, 
            theme: widget.theme,
            durationSeconds: DateTime.now().difference(_controller.startTime ?? DateTime.now()).inSeconds,
            sessionId: _controller.sessionId,
            sessionXp: _controller.sessionXp,
            sessionThemeStats: _controller.getSessionThemeStats(),
          ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }



  @override

  void dispose() {

    _controller.removeListener(_onStateChanged);

    _controller.dispose();

    _entranceController.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    if (_controller.isLoading) {

      return Scaffold(

        backgroundColor: AppColors.getSurface(context),

        body: const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon)),

      );

    }



    final question = _controller.questions.isNotEmpty 

        ? _controller.questions[_controller.currentIndex] 

        : null;



    final onSurface = AppColors.getOnSurface(context);

    final textTheme = Theme.of(context).textTheme;



    return PopScope(

      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {

        if (didPop) return;

        

        final shouldPop = await showDialog<bool>(

          context: context,

          builder: (context) => AlertDialog(

            backgroundColor: AppColors.getSurface(context),

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_safeR(24))),

            title: Text(

              'DÉJÀ FINI ?', 

              style: textTheme.headlineMedium?.copyWith(

                color: AppColors.primaryNeon, 

                fontWeight: FontWeight.w900, 

                letterSpacing: _safeW(1),

                fontSize: _safeSp(18),

              )

            ),

            content: Text(

              'Souhaitez-vous vraiment arrêter votre session en cours ? Votre progression sera perdue.', 

              style: textTheme.bodyLarge?.copyWith(color: onSurface.withValues(alpha: 0.7), fontSize: _safeSp(14))

            ),

            actions: [

              TextButton(

                onPressed: () => Navigator.pop(context, false),

                child: Text(

                  'CONTINUER', 

                  style: textTheme.labelSmall?.copyWith(color: onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold, fontSize: _safeSp(12))

                ),

              ),

              TextButton(

                onPressed: () => Navigator.pop(context, true),

                child: Text(

                  'QUITTER', 

                  style: textTheme.labelSmall?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: _safeSp(12))

                ),

              ),

            ],

          ),

        );



        if (shouldPop == true && context.mounted) {

          Navigator.of(context).pop();

        }

      },

      child: Scaffold(

        backgroundColor: AppColors.getSurface(context),

        resizeToAvoidBottomInset: false,

        body: ResponsiveLayout(

          showParticles: true,

          padding: EdgeInsets.zero,

          child: Stack(

            children: [

              Column(

                children: [

                  _buildPremiumHeader(context),

                  SizedBox(height: _safeH(20)),

                  Expanded(

                    child: question == null 
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, color: onSurface.withValues(alpha: 0.2), size: _safeR(64)),
                              SizedBox(height: _safeH(24)),
                              Text(
                                'AUCUNE QUESTION TROUVÉE', 
                                style: textTheme.headlineSmall?.copyWith(color: onSurface, fontWeight: FontWeight.w900, letterSpacing: 1),
                              ),
                              SizedBox(height: _safeH(12)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: _safeW(48)),
                                child: Text(
                                  'Impossible de charger des questions pour ce thème ou ce parcours actuellement.',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(color: onSurface.withValues(alpha: 0.5)),
                                ),
                              ),
                              SizedBox(height: _safeH(32)),
                              SizedBox(
                                width: _safeW(200),
                                child: PremiumButton(
                                  text: 'RETOUR AU MENU',
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(

                          physics: const BouncingScrollPhysics(),

                          padding: EdgeInsets.symmetric(horizontal: _safeW(24)),

                          child: Column(

                            children: [

                              _buildStatsSection(context),

                              SizedBox(height: _safeH(32)),

                              _buildQuestionSection(context, question),

                              SizedBox(height: _safeH(40)),

                              _buildChoicesGrid(context, question),

                              SizedBox(height: _safeH(180)), 

                            ],

                          ),

                        ),

                  ),

                ],

              ),

              if (_controller.hasAnswered)

                _buildContinueAction(context),

            ],

          ),

        ),

      ),

    );

  }



  Widget _buildPremiumHeader(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    return Container(

      padding: EdgeInsets.symmetric(horizontal: _safeW(24), vertical: _safeH(16)),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          IconButton(

            onPressed: () => Navigator.maybePop(context),

            icon: Icon(Icons.arrow_back_ios_new_rounded, color: onSurface, size: 20.r),

          ),

          const AnimatedBrandText(

            text: 'CIVIQUIZ RÉVISION',

            fontSize: 14,

            letterSpacing: 2,

          ),

          FutureBuilder<int>(

            future: StatsService.getGlobalXp(),

            builder: (context, snapshot) {

              final xp = snapshot.data ?? 0;

              return Container(

                padding: EdgeInsets.symmetric(horizontal: _safeW(12), vertical: _safeH(6)),

                decoration: BoxDecoration(

                  color: AppColors.primaryNeon.withValues(alpha: 0.1),

                  borderRadius: BorderRadius.circular(_safeR(20)),

                  border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.3)),

                ),

                child: Text(

                  '$xp XP',

                  style: TextStyle(

                    color: AppColors.primaryNeon,

                    fontSize: _safeSp(12),

                    fontWeight: FontWeight.w900,

                  ),

                ),

              );

            },

          ),

        ],

      ),

    );

  }



  Widget _buildStatsSection(BuildContext context) {

    final int total = _controller.questions.length;

    final int current = _controller.currentIndex + 1;

    final double progress = total > 0 ? (current - 1) / total : 0;

    final onSurface = AppColors.getOnSurface(context);
    

    final double timerProgress = _controller.timeLeft / 45;

    final Color timerColor = _controller.timeLeft < 10 ? AppColors.accentRedNeon : AppColors.primaryNeon;



    return Row(

      children: [

        Semantics(

          label: 'Temps restant : ${_controller.timeLeft} secondes.',

          child: Stack(

            alignment: Alignment.center,

            children: [

              Container(

                width: _safeR(70),

                height: _safeR(70),

                decoration: BoxDecoration(

                  shape: BoxShape.circle,

                  boxShadow: [

                    BoxShadow(

                      color: timerColor.withValues(alpha: 0.15), 

                      blurRadius: _safeR(15),

                      spreadRadius: _safeR(2),

                    ),

                  ],

                ),

                child: CircularProgressIndicator(

                  value: timerProgress,

                  strokeWidth: _safeR(5),

                  backgroundColor: onSurface.withValues(alpha: 0.05),

                  valueColor: AlwaysStoppedAnimation<Color>(timerColor),

                ),

              ),

              Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  Text(

                    '${_controller.timeLeft}', 

                    style: TextStyle(

                      color: onSurface, 

                      fontSize: _safeSp(20), 

                      fontWeight: FontWeight.w900,

                      fontFamily: 'RobotoMono',

                    ),

                  ),

                  Text(

                    'SEC', 

                    style: TextStyle(

                      color: onSurface.withValues(alpha: 0.4), 

                      fontSize: _safeSp(8), 

                      fontWeight: FontWeight.w900,

                      letterSpacing: 1,

                    ),

                  ),

                ],

              ),

            ],

          ),

        ),

        SizedBox(width: _safeW(24)),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  Text(

                    'MISSION EN COURS', 

                    style: TextStyle(

                      color: onSurface.withValues(alpha: 0.3), 

                      fontSize: _safeSp(9), 

                      fontWeight: FontWeight.w900, 

                      letterSpacing: 1.5,

                    ),

                  ),

                  Text(

                    '$current / $total',

                    style: TextStyle(

                      color: AppColors.primaryNeon, 

                      fontSize: _safeSp(11), 

                      fontWeight: FontWeight.w900,

                    ),

                  ),

                ],

              ),

              SizedBox(height: 12.h),

              Stack(

                children: [

                  Container(

                    height: 8.h,

                    width: double.infinity,

                    decoration: BoxDecoration(

                      color: onSurface.withValues(alpha: 0.05),

                      borderRadius: BorderRadius.circular(4),

                    ),

                  ),

                  AnimatedContainer(

                    duration: const Duration(milliseconds: 500),

                    height: 8.h,

                    width: (MediaQuery.of(context).size.width - 142.w) * progress,

                    decoration: BoxDecoration(

                      gradient: AppColors.primary3DGradient,

                      borderRadius: BorderRadius.circular(4),

                      boxShadow: [

                        BoxShadow(

                          color: AppColors.primaryNeon.withValues(alpha: 0.3),

                          blurRadius: 10,

                        ),

                      ],

                    ),

                  ),

                ],

              ),

              SizedBox(height: 6.h),

              Text(

                'Progression vers le Badge Émérite',

                style: TextStyle(

                  color: onSurface.withValues(alpha: 0.4),

                  fontSize: _safeSp(10),

                  fontWeight: FontWeight.w500,

                ),

              ),

            ],

          ),

        ),

      ],

    );

  }

  Widget _buildQuestionSection(BuildContext context, QuizQuestion question) {

    final onSurface = AppColors.getOnSurface(context);

    return GlassCard(

      padding: EdgeInsets.all(_safeR(28)),

      child: Column(

        children: [

          Container(

            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),

            decoration: BoxDecoration(

              color: AppColors.primaryNeon.withValues(alpha: 0.1),

              borderRadius: BorderRadius.circular(8),

            ),

            child: Text(

              'QUESTION PRINCIPALE',

              style: TextStyle(

                color: AppColors.primaryNeon,

                fontSize: 9.sp,

                fontWeight: FontWeight.w900,

                letterSpacing: 1,

              ),

            ),

          ),

          SizedBox(height: 20.h),

          Text(

            question.question,

            textAlign: TextAlign.center,

            style: TextStyle(

              color: onSurface,

              fontSize: _safeSp(20),

              fontWeight: FontWeight.w900,

              height: 1.4,

            ),

          ),

        ],

      ),

    );

  }



  Widget _buildChoicesGrid(BuildContext context, QuizQuestion question) {

    return Column(

      children: List.generate(

        question.choices.length,

        (index) {

          final animationIndex = index % 4; 

          return FadeTransition(

            opacity: _choiceAnimations[animationIndex],

            child: Transform.translate(

              offset: Offset(0, 30 * (1 - _choiceAnimations[animationIndex].value)),

              child: _buildChoiceItem(context, index, question),

            ),

          );

        },

      ),

    );

  }



  Widget _buildChoiceItem(BuildContext context, int index, QuizQuestion question) {

    final bool isSelected = _controller.selectedAnswerIndex == index;

    final bool hasAnswered = _controller.hasAnswered;

    final bool isCorrect = index == question.answerIndex;

    final String choiceText = question.choices[index];

    final onSurface = AppColors.getOnSurface(context);



    Color borderColor = onSurface.withValues(alpha: 0.1);

    Color bgColor = onSurface.withValues(alpha: 0.02);

    Color textColor = onSurface.withValues(alpha: 0.6);

    Color indicatorColor = onSurface.withValues(alpha: 0.1);



    if (isSelected) {

      borderColor = AppColors.primaryNeon;

      bgColor = AppColors.primaryNeon.withValues(alpha: 0.05);

      textColor = onSurface;

      indicatorColor = AppColors.primaryNeon;

    }



    if (hasAnswered) {

      if (isCorrect) {

        borderColor = AppColors.successGreenNeon;

        bgColor = AppColors.successGreenNeon.withValues(alpha: 0.08);

        textColor = onSurface;

        indicatorColor = AppColors.successGreenNeon;

      } else if (isSelected) {

        borderColor = AppColors.accentRedNeon;

        bgColor = AppColors.accentRedNeon.withValues(alpha: 0.08);

        indicatorColor = AppColors.accentRedNeon;

      }

    }



    return Padding(

      padding: EdgeInsets.only(bottom: _safeH(16)),

      child: Semantics(

        button: true,

        selected: isSelected,

        child: GlassCard(

          padding: EdgeInsets.all(_safeR(20)),

          borderColor: borderColor,

          backgroundColor: bgColor,

          onTap: () {

            if (!hasAnswered) {

              _controller.answerQuestion(index);

              HapticFeedback.mediumImpact();

            }

          },

          child: Row(

            children: [

              AnimatedContainer(

                duration: const Duration(milliseconds: 200),

                width: _safeR(36),

                height: _safeR(36),

                decoration: BoxDecoration(

                  color: indicatorColor.withValues(alpha: 0.1),

                  shape: BoxShape.circle,

                  border: Border.all(color: indicatorColor.withValues(alpha: 0.3), width: 1.5),

                  boxShadow: isSelected ? [

                    BoxShadow(color: indicatorColor.withValues(alpha: 0.2), blurRadius: 8),

                  ] : [],

                ),

                child: Center(

                  child: hasAnswered && isCorrect

                      ? const Icon(Icons.check_rounded, color: AppColors.successGreenNeon, size: 20)

                      : hasAnswered && isSelected && !isCorrect

                          ? const Icon(Icons.close_rounded, color: AppColors.accentRedNeon, size: 20)

                          : Text(

                              String.fromCharCode(65 + index),

                              style: TextStyle(

                                color: isSelected ? AppColors.primaryNeon : onSurface.withValues(alpha: 0.4),

                                fontWeight: FontWeight.w900,

                                fontSize: 14.sp,

                              ),

                            ),

                ),

              ),

              SizedBox(width: _safeW(20)),

              Expanded(

                child: Text(

                  choiceText,

                  style: TextStyle(

                    color: textColor,

                    fontSize: _safeSp(15),

                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }



  Widget _buildContinueAction(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    return Positioned(

      bottom: _safeH(60),

      left: _safeW(24),

      right: _safeW(24),

      child: Column(

        children: [

          SizedBox(

            width: double.infinity,

            height: _safeH(64),

            child: PremiumButton(

              text: 'CONTINUER',

              icon: Icons.arrow_forward_ios_rounded,

              onPressed: _onNext,

            ),

          ),

          SizedBox(height: _safeH(20)),

          Text(

            'L\'EXAMINATEUR VOUS ATTEND',

            style: TextStyle(

              color: onSurface.withValues(alpha: 0.24), 

              fontSize: _safeSp(10), 

              fontWeight: FontWeight.w900, 

              letterSpacing: 2,

            ),

          ),

        ],

      ),

    );

  }



  void _onNext() {

    if (_isNavigating) return; 



    if (_controller.currentIndex < _controller.questions.length - 1) {

      _entranceController.reverse().then((_) {

        if (!mounted) return;

        _controller.nextQuestion();

        _entranceController.forward();

      });

    } else {

      setState(() => _isNavigating = true);

      HapticFeedback.mediumImpact();

      _navigateToResults();

    }

  }

}


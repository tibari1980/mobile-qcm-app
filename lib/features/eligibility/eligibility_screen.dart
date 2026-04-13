import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_button.dart';
import 'eligibility_model.dart';
import 'eligibility_service.dart';
import '../../core/services/stats_service.dart';

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final Map<String, String> _answers = {};
  EligibilityResult? _result;

  void _nextStep(String questionId, String optionId) {
    setState(() {
      _answers[questionId] = optionId;
      if (_currentStep < eligibilityQuestions.length - 1) {
        _currentStep++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _result = EligibilityService.calculateResult(_answers);
        StatsService.setEligibilityVerified(true);
      }
    });
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _pageController.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.getSurface(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _result == null 
                  ? _buildWizard() 
                  : _buildResultView(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);
    final progress = (_currentStep + 1) / eligibilityQuestions.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _result == null ? _previousStep() : Navigator.pop(context),
                icon: Icon(_currentStep == 0 || _result != null ? Icons.close_rounded : Icons.arrow_back_ios_rounded, color: onSurface, size: 24.r),
              ),
              const Text(
                'ÉLIGIBILITÉ 2026',
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.w900, 
                  fontSize: 14, 
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(width: 48), // Spacer
            ],
          ),
          if (_result == null) ...[
            SizedBox(height: 16.h),
            Stack(
              children: [
                Container(
                  height: 4.h,
                  width: double.infinity,
                  decoration: BoxDecoration(color: onSurface.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2)),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 4.h,
                  width: MediaQuery.of(context).size.width * progress,
                  decoration: BoxDecoration(
                    gradient: AppColors.primary3DGradient,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [BoxShadow(color: AppColors.primaryNeon.withValues(alpha: 0.3), blurRadius: 10)],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWizard() {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: eligibilityQuestions.length,
      itemBuilder: (context, index) {
        final q = eligibilityQuestions[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                q.title,
                style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 8.h),
              Text(
                q.description,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14.sp),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: q.options.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, optIndex) {
                    final opt = q.options[optIndex];
                    return _buildOptionCard(q.id, opt);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(String questionId, EligibilityOption opt) {
    final onSurface = AppColors.getOnSurface(context);
    return GlassCard(
      padding: EdgeInsets.all(20.r),
      onTap: () => _nextStep(questionId, opt.id),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opt.label,
                  style: TextStyle(color: onSurface, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                if (opt.description != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    opt.description!,
                    style: TextStyle(color: onSurface.withValues(alpha: 0.5), fontSize: 12.sp),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryNeon, size: 16.r),
        ],
      ),
    );
  }

  Widget _buildResultView(BuildContext context) {
    final res = _result!;
    final onSurface = AppColors.getOnSurface(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          GlassCard(
            padding: EdgeInsets.all(32.r),
            borderColor: res.glowColor.withValues(alpha: 0.3),
            backgroundColor: res.glowColor.withValues(alpha: 0.05),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: res.glowColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: res.glowColor.withValues(alpha: 0.2), blurRadius: 40)],
                  ),
                  child: Icon(
                    res.status == EligibilityStatus.exempt ? Icons.verified_rounded : Icons.info_outline_rounded,
                    color: res.glowColor,
                    size: 48.r,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  res.title,
                  style: TextStyle(color: res.glowColor, fontSize: 24.sp, fontWeight: FontWeight.w900, letterSpacing: 2),
                ),
                SizedBox(height: 16.h),
                Text(
                  res.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: onSurface, fontSize: 16.sp, fontWeight: FontWeight.w600, height: 1.4),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'POINTS CLÉS :',
              style: TextStyle(color: AppColors.primaryNeon, fontSize: 12.sp, fontWeight: FontWeight.w900, letterSpacing: 1.5),
            ),
          ),
          SizedBox(height: 16.h),
          ...res.reasons.map((reason) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline_rounded, color: AppColors.primaryNeon, size: 18.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    reason,
                    style: TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 14.sp, height: 1.4),
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: 48.h),
          PremiumButton(
            text: res.status == EligibilityStatus.mandatory 
                ? 'DÉCOUVRIR LES PARCOURS' 
                : 'TERMINER',
            onPressed: () {
              if (res.status == EligibilityStatus.mandatory) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/main', 
                  (route) => false, 
                  arguments: 1 // Go to Selection Tab
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => setState(() {
              _result = null;
              _currentStep = 0;
              _answers.clear();
            }),
            child: Text('RECOMMENCER LE TEST', style: TextStyle(color: onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.bold, fontSize: 12.sp)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/quiz_service.dart';
import '../../core/services/stats_service.dart';
import '../../core/widgets/premium_bottom_bar.dart';
import '../home/home_screen.dart';
import '../landing/landing_screen.dart';
import '../settings/settings_screen.dart';
import '../stats/stats_screen.dart';
import '../study/study_selection_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 1; // Default to Intro/Landing

  @override
  void initState() {
    super.initState();
    _checkSavedPath();
  }
  Future<void> _checkSavedPath() async {
    final saved = await StatsService.getSelectedPathway();
    if (saved != null) {
      QuizService.setPath(saved['name'], saved['code'], saved['threshold']);
      if (mounted) {
        setState(() {
          _currentIndex = 0; // Go to home if already selected
        });
      }
    }
  }

  Future<void> _onPathSelected() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _checkSavedPath();
  }

  void _onTabTapped(int index) {
    if (mounted) setState(() => _currentIndex = index);
  }

  void _onResetPath() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final navMaxWidth = screenWidth > 600 ? 500.0 : screenWidth * 0.9;

    return Scaffold(
      backgroundColor: AppColors.getSurface(context),
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: navMaxWidth),
            child: PremiumBottomBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(onNavigateToQuiz: () => _onTabTapped(1)),
            LandingScreen(
              onSelection: _onPathSelected,
              onSettingsTap: () => _onTabTapped(4),
            ),
            const StudySelectionScreen(),
            const StatsScreen(),
            SettingsScreen(onChangePath: _onResetPath),
          ],
        ),
      ),
    );
  }
}

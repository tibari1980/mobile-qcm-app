import 'package:flutter/material.dart';
import '../../../core/services/stats_service.dart';

class HomeBadge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const HomeBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.color = Colors.blueAccent,
  });

  static const List<HomeBadge> allBadges = [
    HomeBadge(
      id: 'first_quiz',
      title: 'Premier Pas',
      description: 'Débloqué pour votre premier quiz terminé.',
      icon: Icons.directions_walk_rounded,
      color: Colors.lightBlueAccent,
    ),
    HomeBadge(
      id: 'master_20',
      title: 'Apprenti Citoyen',
      description: 'Débloqué pour 20 questions maîtrisées.',
      icon: Icons.school_rounded,
      color: Colors.tealAccent,
    ),
    HomeBadge(
      id: 'perfect_score',
      title: 'Perfectionniste',
      description: 'Débloqué pour avoir obtenu 100% de réussite.',
      icon: Icons.star_rounded,
      color: Colors.amberAccent,
    ),
    HomeBadge(
      id: 'republic_expert',
      title: 'Garde des Sceaux',
      description: 'Débloqué pour 50 questions sur les valeurs républicaines.',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF00D1FF), // primaryNeon-ish
    ),
    HomeBadge(
      id: 'historian',
      title: 'Historien',
      description: 'Débloqué pour 50 questions sur l\'histoire de France.',
      icon: Icons.history_edu_rounded,
      color: Colors.deepPurpleAccent,
    ),
    HomeBadge(
      id: 'master_100',
      title: 'Grand Érudit',
      description: 'Débloqué pour 100 questions maîtrisées au total.',
      icon: Icons.emoji_events_rounded,
      color: Colors.orangeAccent,
    ),
  ];

  static Future<List<HomeBadge>> getUnlockedBadges() async {
    final history = await StatsService.getHistory();
    final mastered = await StatsService.getMasteredIds();
    
    final unlocked = <HomeBadge>[];

    // 1. Premier Pas
    if (history.isNotEmpty) {
      unlocked.add(allBadges.firstWhere((b) => b.id == 'first_quiz'));
    }

    // 2. Apprenti Citoyen
    if (mastered.length >= 20) {
      unlocked.add(allBadges.firstWhere((b) => b.id == 'master_20'));
    }

    // 3. Perfectionniste
    if (history.any((r) => r.precision >= 100)) {
      unlocked.add(allBadges.firstWhere((b) => b.id == 'perfect_score'));
    }

    // 4. Grand Erudit
    if (mastered.length >= 100) {
      unlocked.add(allBadges.firstWhere((b) => b.id == 'master_100'));
    }

    // Note: Theme-specific badges (Historian/Republic) could be calculated 
    // by checking question IDs against their categories, but for now we'll 
    // stick to these primary achievements to ensure performance.
    
    return unlocked;
  }
}

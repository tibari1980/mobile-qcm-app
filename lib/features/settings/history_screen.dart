import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/services/stats_service.dart';
import '../results/quiz_result_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = AppColors.getOnSurface(context);
    final surface = AppColors.getSurface(context);

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: FutureBuilder<List<QuizResult>>(
          future: StatsService.getHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryNeon));
            }

            final history = snapshot.data ?? [];

            // Use simple ListView for header and list to avoid layout fighting on Web
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios_rounded, color: onSurface, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'HISTORIQUE',
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.w900, 
                        letterSpacing: 4, 
                        color: onSurface
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                if (history.isEmpty)
                  _buildEmptyState(onSurface)
                else
                  // Map results to Widgets directly in the ListView children
                  ...history.map((result) => _buildHistoryCard(context, result, onSurface)),

                const SizedBox(height: 32),
                
                if (history.isNotEmpty)
                  PremiumButton(
                    text: 'RÉINITIALISER L\'HISTORIQUE',
                    icon: Icons.delete_forever_rounded,
                    onPressed: () => _handleReset(context, surface, onSurface),
                  ),
                
                const SizedBox(height: 48),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color onSurface) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Icon(Icons.history_edu_rounded, color: onSurface.withValues(alpha: 0.05), size: 100),
        const SizedBox(height: 24),
        Text(
          'AUCUN QUIZ TERMINÉ',
          style: TextStyle(color: onSurface.withValues(alpha: 0.2), fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        const SizedBox(height: 8),
        Text(
          'Vos résultats apparaîtront ici.',
          style: TextStyle(color: onSurface.withValues(alpha: 0.1), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(BuildContext context, QuizResult result, Color onSurface) {
    final bool isSuccess = result.precision >= 75;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          title: Text(
            result.theme.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(color: AppColors.primaryNeon, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, color: onSurface.withValues(alpha: 0.3), size: 10),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('dd MMMM yyyy • HH:mm').format(result.date),
                    style: TextStyle(color: onSurface.withValues(alpha: 0.5), fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'PARCOURS: ${result.path}',
                style: TextStyle(color: onSurface.withValues(alpha: 0.24), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${result.precision.toInt()}%',
                style: TextStyle(
                  color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '${result.score}/${result.total}',
                style: TextStyle(color: onSurface.withValues(alpha: 0.3), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleReset(BuildContext context, Color surface, Color onSurface) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surface,
        title: Text('TOUT EFFACER ?', style: TextStyle(color: onSurface, fontWeight: FontWeight.w900, letterSpacing: 1)),
        content: Text('Cette action est irréversible.', style: TextStyle(color: onSurface.withValues(alpha: 0.7))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ANNULER')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('EFFACER', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      await StatsService.resetData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Historique effacé')));
        Navigator.pop(context);
      }
    }
  }
}

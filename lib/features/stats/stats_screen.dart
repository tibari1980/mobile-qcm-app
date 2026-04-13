import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fl_chart/fl_chart.dart';

import '../../core/constants/app_colors.dart';

import '../../core/widgets/glass_card.dart';

import '../../core/services/stats_service.dart';

// Safe ScreenUtil helpers to prevent NaN/infinite crashes on Web
double _safeH(double v) { try { final s = v.h; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }
double _safeW(double v) { try { final s = v.w; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }
double _safeR(double v) { try { final s = v.r; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }
double _safeSp(double v) { try { final s = v.sp; return (s.isNaN || s.isInfinite || s <= 0) ? v : s; } catch (_) { return v; } }

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});



  @override

  State<StatsScreen> createState() => _StatsScreenState();

}



class _StatsScreenState extends State<StatsScreen> {

  @override

  Widget build(BuildContext context) {

    return Padding(

      padding: EdgeInsets.symmetric(horizontal: _safeW(24), vertical: _safeH(32)),

      child: SingleChildScrollView(

        physics: const BouncingScrollPhysics(),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox(height: _safeH(32)),

            _buildStatHeader(context),

            SizedBox(height: _safeH(48)),

            

            _buildSectionTitle(context, 'ÉVOLUTION DE PRÉCISION'),

            _buildLineChartSection(context),

            

            SizedBox(height: _safeH(40)),

            _buildSectionTitle(context, 'PERFORMANCE PAR THÈME'),

            _buildBarChartSection(context),

            

            SizedBox(height: _safeH(40)),

            _buildSectionTitle(context, 'PROGRESSION DE NIVEAU'),

            _buildLevelProgress(context),

            

            SizedBox(height: _safeH(120)), // Bottom Bar Padding

          ],

        ),

      ),

    );

  }



  Widget _buildSectionTitle(BuildContext context, String title) {

    final textTheme = Theme.of(context).textTheme;

    return Padding(

      padding: EdgeInsets.only(bottom: _safeH(24)),

      child: FittedBox(

        fit: BoxFit.scaleDown,

        alignment: Alignment.centerLeft,

        child: Text(

          title,

          style: textTheme.labelSmall?.copyWith(

            color: AppColors.getOnSurface(context).withValues(alpha: 0.3),

            fontSize: _safeSp(11),

            fontWeight: FontWeight.w900,

            letterSpacing: _safeW(2),

          ),

        ),

      ),

    );

  }



  Widget _buildStatHeader(BuildContext context) {

    return FutureBuilder(

      future: Future.wait([

        StatsService.getGlobalXp(),

        StatsService.getGlobalPerformance(),

        StatsService.getTotalQuestions(),

      ]),

      builder: (context, snapshot) {

        if (snapshot.hasError) {

          return Center(

            child: Padding(

              padding: EdgeInsets.all(_safeR(24)),

              child: Text(

                'Erreur lors du chargement des statistiques',

                style: TextStyle(color: AppColors.accentRedNeon, fontSize: _safeSp(12)),

              ),

            ),

          );

        }

        if (!snapshot.hasData || snapshot.data == null) return SizedBox(height: _safeH(100));

        final list = snapshot.data as List;

        if (list.length < 3) return SizedBox(height: _safeH(100));

        

        final int xp = list[0] as int;

        final Map<String, dynamic> perf = list[1] as Map<String, dynamic>;

        final int totalQ = list[2] as int;



        return SingleChildScrollView(

          scrollDirection: Axis.horizontal,

          physics: const BouncingScrollPhysics(),

          child: Row(

            children: [

              SizedBox(

                width: _safeW(120),

                child: _buildHeaderCard(context, 'PRÉCISION', '${perf['average']}%', Icons.track_changes_rounded),

              ),

              SizedBox(width: _safeW(12)),

              SizedBox(

                width: _safeW(160),

                child: _buildHeaderCard(

                  context,

                  'XP TOTAL', 

                  xp.toString(), 

                  Icons.bolt_rounded,

                  info: 'Chaque quiz réussi augmente votre XP.',

                ),

              ),

              SizedBox(width: _safeW(12)),

              SizedBox(

                width: _safeW(130),

                child: _buildHeaderCard(context, 'QUESTIONS', totalQ.toString(), Icons.question_answer_rounded),

              ),

            ],

          ),

        );

      },

    );

  }



  Widget _buildHeaderCard(BuildContext context, String label, String value, IconData icon, {String? info}) {

    final onSurface = AppColors.getOnSurface(context);

    final textTheme = Theme.of(context).textTheme;

    return GlassCard(

      semanticsLabel: '$label : $value. ${info ?? ''}',

      child: Padding(

        padding: EdgeInsets.all(_safeR(16)),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                Icon(icon, color: AppColors.primaryNeon, size: _safeR(16)),

                if (info != null)

                  Tooltip(

                    message: info,

                    triggerMode: TooltipTriggerMode.tap,

                    child: Icon(Icons.info_outline_rounded, color: onSurface.withValues(alpha: 0.24), size: _safeR(12)),

                  ),

              ],

            ),

            SizedBox(height: _safeH(12)),

            Text(

              value, 

              style: textTheme.headlineMedium?.copyWith(

                color: onSurface,

                fontSize: _safeSp(20),

                fontWeight: FontWeight.w900,

              )

            ),

            SizedBox(height: _safeH(4)),

            Text(

              label, 

              style: textTheme.labelSmall?.copyWith(

                color: onSurface.withValues(alpha: 0.24),

                fontSize: _safeSp(8),

                fontWeight: FontWeight.bold,

                letterSpacing: _safeW(1),

              )

            ),

          ],

        ),

      ),

    );

  }



  Widget _buildLineChartSection(BuildContext context) {

    return FutureBuilder<List<double>>(

      future: StatsService.getPrecisionHistory(),

      builder: (context, snapshot) {

        final data = snapshot.data ?? [];

        if (data.isEmpty) return _buildEmptyState(context, 'Réalisez des quiz pour voir vos tendances.');



        return Semantics(

          label: 'Graphique d\'évolution de votre précision. ${data.length} derniers quiz analysés.',

          child: RepaintBoundary(

            child: Container(

              height: _safeH(180),

              padding: EdgeInsets.only(right: _safeW(24), top: _safeH(16), bottom: _safeH(8)),

              child: LineChart(

                LineChartData(

                  gridData: const FlGridData(show: false),

                  titlesData: const FlTitlesData(

                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  ),

                  borderData: FlBorderData(show: false),

                  minX: 0,

                  maxX: (data.length > 1 ? data.length - 1 : 1).toDouble(),

                  minY: 0,

                  maxY: 100,

                  lineBarsData: [

                    LineChartBarData(

                      spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i])),

                      isCurved: true,

                      color: AppColors.primaryNeon,

                      barWidth: 4,

                      dotData: const FlDotData(show: false),

                      belowBarData: BarAreaData(

                        show: true,

                        gradient: LinearGradient(

                          colors: [AppColors.primaryNeon.withValues(alpha: 0.3), Colors.transparent],

                          begin: Alignment.topCenter,

                          end: Alignment.bottomCenter,

                        ),

                      ),

                    ),

                  ],

                ),

              ),

            ),

          ),

        );

      },

    );

  }



  Widget _buildBarChartSection(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<Map<String, double>>(

      future: StatsService.getThemeProficiency(),

      builder: (context, snapshot) {

        final data = snapshot.data ?? {};

        if (data.isEmpty) return _buildEmptyState(context, 'Les performances par thème s\'afficheront ici.');



        return Semantics(

          label: 'Histogramme de performance par thème. ${data.length} thèmes évalués.',

          child: Container(

            height: _safeH(200),

            padding: EdgeInsets.all(_safeR(16)),

            child: BarChart(

              BarChartData(

                gridData: const FlGridData(show: false),

                titlesData: FlTitlesData(

                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                  bottomTitles: AxisTitles(

                    sideTitles: SideTitles(

                      showTitles: true,

                      interval: 1,

                      getTitlesWidget: (value, meta) {

                        final keys = data.keys.toList();

                        final index = value.toInt();

                        if (index < 0 || index >= keys.length || value % 1 != 0) return const SizedBox();

                        String title = keys[index];

                        if (title.length > 3) title = title.substring(0, 3);

                        return Padding(

                          padding: EdgeInsets.only(top: _safeH(8)),

                          child: Text(

                            title, 

                            style: textTheme.labelSmall?.copyWith(

                              color: onSurface.withValues(alpha: 0.38),

                              fontSize: _safeSp(8),

                              fontWeight: FontWeight.bold,

                            )

                          ),

                        );

                      },

                    ),

                  ),

                ),

                borderData: FlBorderData(show: false),

                barGroups: List.generate(data.length, (i) {

                  return BarChartGroupData(

                    x: i,

                    barRods: [

                      BarChartRodData(

                        toY: data.values.elementAt(i),

                        color: AppColors.primaryNeon,

                        width: _safeW(16),

                        borderRadius: BorderRadius.circular(_safeR(4)),

                        backDrawRodData: BackgroundBarChartRodData(

                          show: true,

                          toY: 100,

                          color: onSurface.withValues(alpha: 0.05),

                        ),

                      ),

                    ],

                  );

                }),

              ),

            ),

          ),

        );

      },

    );

  }



  Widget _buildLevelProgress(BuildContext context) {

    final onSurface = AppColors.getOnSurface(context);

    final textTheme = Theme.of(context).textTheme;



    return FutureBuilder<int>(

      future: StatsService.getGlobalXp(),

      builder: (context, snapshot) {

        final xp = snapshot.data ?? 0;

        final level = (xp / 1000).floor() + 1;

        final currentXpInLevel = xp % 1000;

        final progress = currentXpInLevel / 1000;



        return GlassCard(

          semanticsLabel: 'Niveau actuel : $level. Expérience : $currentXpInLevel sur 1000 points.',

          child: Padding(

            padding: EdgeInsets.all(_safeR(24)),

            child: Row(

              children: [

                Container(

                  width: _safeR(50),

                  height: _safeR(50),

                  decoration: BoxDecoration(

                    color: AppColors.primaryNeon.withValues(alpha: 0.1),

                    shape: BoxShape.circle,

                    border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.3)),

                  ),

                  child: Center(

                    child: Text(

                      level.toString(),

                      style: textTheme.headlineLarge?.copyWith(

                        color: AppColors.primaryNeon,

                        fontSize: _safeSp(24),

                        fontWeight: FontWeight.w900,

                      ),

                    ),

                  ),

                ),

                SizedBox(width: _safeW(20)),

                Expanded(

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [

                          Flexible(

                            child: Text(

                              'NIVEAU ACTUEL', 

                              overflow: TextOverflow.ellipsis,

                              style: textTheme.labelSmall?.copyWith(

                                color: onSurface.withValues(alpha: 0.7),

                                fontSize: _safeSp(10),

                                fontWeight: FontWeight.w900,

                                letterSpacing: _safeW(1),

                              )

                            ),

                          ),

                          SizedBox(width: _safeW(8)),

                          Text(

                            '$currentXpInLevel / 1000 XP', 

                            style: textTheme.labelSmall?.copyWith(

                              color: onSurface.withValues(alpha: 0.38),

                              fontSize: _safeSp(10),

                              fontWeight: FontWeight.bold,

                            )

                          ),

                        ],

                      ),

                      SizedBox(height: _safeH(12)),

                      ClipRRect(

                        borderRadius: BorderRadius.circular(_safeR(10)),

                        child: LinearProgressIndicator(

                          value: progress,

                          minHeight: _safeH(8),

                          backgroundColor: onSurface.withValues(alpha: 0.1),

                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryNeon),

                        ),

                      ),

                    ],

                  ),

                ),

              ],

            ),

          ),

        );

      },

    );

  }



  Widget _buildEmptyState(BuildContext context, String text) {

    final onSurface = AppColors.getOnSurface(context);

    final textTheme = Theme.of(context).textTheme;

    return Container(

      width: double.infinity,

      padding: EdgeInsets.all(_safeR(40)),

      decoration: BoxDecoration(

        color: onSurface.withValues(alpha: 0.02),

        borderRadius: BorderRadius.circular(_safeR(24)),

        border: Border.all(color: onSurface.withValues(alpha: 0.05)),

      ),

      child: Column(

        children: [

          Icon(Icons.bar_chart_rounded, color: onSurface.withValues(alpha: 0.1), size: _safeR(40)),

          SizedBox(height: _safeH(16)),

          Text(

            text,

            textAlign: TextAlign.center,

            style: textTheme.bodyLarge?.copyWith(

              color: onSurface.withValues(alpha: 0.24),

              fontSize: _safeSp(11),

              fontWeight: FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }

}


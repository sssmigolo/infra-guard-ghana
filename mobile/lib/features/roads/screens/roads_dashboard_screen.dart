// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Roads Dashboard Screen (CV AI)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/models/models.dart';
import '../../../shared/models/sample_data.dart';

class RoadsDashboardScreen extends StatelessWidget {
  const RoadsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.ghanaGreen.withValues(alpha: 0.2),
                      isDark ? AppColors.darkBg : AppColors.lightBg,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [AppColors.ghanaGreen, Color(0xFF008B50)]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.add_road_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Road CV AI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText)),
                                Text('Computer Vision Intelligence', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _QuickStat(value: '12', label: 'Open\nReports', color: AppColors.ghanaRed),
                            const SizedBox(width: 12),
                            _QuickStat(value: '5', label: 'In\nProgress', color: AppColors.warning),
                            const SizedBox(width: 12),
                            _QuickStat(value: '84', label: 'Fixed\nThis Month', color: AppColors.ghanaGreen),
                            const SizedBox(width: 12),
                            _QuickStat(value: '340km', label: 'Roads\nMonitored', color: AppColors.info),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.camera_alt,
                        label: 'Report Issue',
                        color: AppColors.ghanaGreen,
                        onTap: () => context.go('/roads/report'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.format_list_numbered,
                        label: 'Priority List',
                        color: AppColors.ghanaGold,
                        onTap: () => context.go('/roads/priorities'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Road Condition Summary
                Text('Road Condition Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      _ConditionBar(label: 'Good', percentage: 0.45, color: AppColors.roadGood),
                      const SizedBox(height: 12),
                      _ConditionBar(label: 'Fair', percentage: 0.30, color: AppColors.roadFair),
                      const SizedBox(height: 12),
                      _ConditionBar(label: 'Poor', percentage: 0.18, color: AppColors.roadPoor),
                      const SizedBox(height: 12),
                      _ConditionBar(label: 'Critical', percentage: 0.07, color: AppColors.roadCritical),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Reports
                Text('Recent Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ...SampleData.roadReports.map((report) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RoadReportCard(report: report),
                )),

                const SizedBox(height: 24),

                // Climate Vulnerability
                Text('Climate Vulnerability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                GlassCard(
                  borderColor: AppColors.info.withValues(alpha: 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.cloud, color: AppColors.info),
                          const SizedBox(width: 8),
                          Text('Rainfall Impact Forecast', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Heavy rainfall expected in Greater Accra (Mar 6-8). 3 road segments at HIGH risk of accelerated degradation. AI recommends pre-emptive drainage clearing.',
                        style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          StatusBadge(label: 'N1 Highway', color: AppColors.ghanaRed),
                          const SizedBox(width: 8),
                          StatusBadge(label: 'Kaneshie Rd', color: AppColors.ghanaRed),
                          const SizedBox(width: 8),
                          StatusBadge(label: 'Ring Road W', color: AppColors.warning),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _QuickStat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 9, color: color.withValues(alpha: 0.8)), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
            Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _ConditionBar extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;
  const _ConditionBar({required this.label, required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(width: 40, child: Text('${(percentage * 100).toInt()}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.right)),
      ],
    );
  }
}

class _RoadReportCard extends StatelessWidget {
  final RoadReport report;
  const _RoadReportCard({required this.report});

  Color get _conditionColor {
    switch (report.condition) {
      case RoadCondition.critical: return AppColors.roadCritical;
      case RoadCondition.poor: return AppColors.roadPoor;
      case RoadCondition.fair: return AppColors.roadFair;
      case RoadCondition.good: return AppColors.roadGood;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(label: report.defectType.name.toUpperCase(), color: _conditionColor),
              const SizedBox(width: 8),
              StatusBadge(label: report.status.toUpperCase(), color: report.status == 'open' ? AppColors.ghanaRed : AppColors.warning),
              const Spacer(),
              RiskScoreIndicator(score: report.aiConfidence, size: 36),
            ],
          ),
          const SizedBox(height: 12),
          Text(report.address, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          if (report.aiAnalysis != null)
            Text(report.aiAnalysis!, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              if (report.estimatedRepairCost != null) ...[
                Icon(Icons.payments, size: 14, color: AppColors.ghanaGold),
                const SizedBox(width: 4),
                Text('GH₵ ${report.estimatedRepairCost!.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
              ],
              if (report.timeToFailureDays != null) ...[
                Icon(Icons.schedule, size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text('${report.timeToFailureDays}d to failure', style: TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w500)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

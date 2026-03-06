// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Electricity Dashboard Screen (Dumsor AI)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/models/models.dart';
import '../../../shared/models/sample_data.dart';

class ElectricityDashboardScreen extends StatelessWidget {
  const ElectricityDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
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
                      AppColors.ghanaGold.withValues(alpha: 0.2),
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
                                gradient: const LinearGradient(colors: [AppColors.ghanaGold, Color(0xFFE5BC00)]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.bolt_rounded, color: AppColors.ghanaBlack, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dumsor AI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText)),
                                Text('Power Grid Intelligence', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Quick stats
                        Row(
                          children: [
                            _QuickStat(value: '1', label: 'Active\nOutage', color: AppColors.ghanaRed),
                            const SizedBox(width: 12),
                            _QuickStat(value: '3', label: 'Predicted\n24-72h', color: AppColors.warning),
                            const SizedBox(width: 12),
                            _QuickStat(value: '97.2%', label: 'Grid\nUptime', color: AppColors.ghanaGreen),
                            const SizedBox(width: 12),
                            _QuickStat(value: '24.5k', label: 'Affected\nUsers', color: AppColors.info),
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
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.auto_graph,
                        label: 'View Predictions',
                        color: AppColors.ghanaGold,
                        onTap: () => context.go('/electricity/prediction'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.camera_alt,
                        label: 'Tech Workflow',
                        color: AppColors.ghanaGreen,
                        onTap: () => context.go('/electricity/technician'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Active Outages
                Text('Active Outages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 12),
                ...SampleData.outages.where((o) => o.status == OutageStatus.active).map((outage) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OutageCard(outage: outage),
                )),

                const SizedBox(height: 24),

                // Upcoming Predictions
                Text('AI Predictions (24-72h)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 12),
                ...SampleData.predictions.map((pred) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PredictionCard(prediction: pred),
                )),

                const SizedBox(height: 24),

                // Maintenance Schedule
                Text('Maintenance Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      _MaintenanceItem(title: 'Osu Transformer T-012', subtitle: 'Replace unit – 3 outages traced', date: 'Mar 10', priority: 'HIGH'),
                      const Divider(height: 24),
                      _MaintenanceItem(title: 'East Legon Feeder F-07', subtitle: 'Cable inspection due', date: 'Mar 15', priority: 'MEDIUM'),
                      const Divider(height: 24),
                      _MaintenanceItem(title: 'Achimota Substation', subtitle: 'Annual preventive maintenance', date: 'Mar 22', priority: 'LOW'),
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

class _OutageCard extends StatelessWidget {
  final Outage outage;
  const _OutageCard({required this.outage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      borderColor: AppColors.ghanaRed.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(label: 'ACTIVE', color: AppColors.ghanaRed, icon: Icons.warning),
              const Spacer(),
              Text('${outage.affectedCustomers.toString()} affected', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(outage.area, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(outage.cause ?? 'Unknown cause', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          if (outage.predictedEnd != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: AppColors.warning),
                const SizedBox(width: 6),
                Text(
                  'Est. restoration: ${outage.predictedEnd!.difference(DateTime.now()).inHours}h remaining',
                  style: TextStyle(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: outage.confidenceScore,
            backgroundColor: AppColors.ghanaRed.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation(AppColors.ghanaRed),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text('AI Confidence: ${(outage.confidenceScore * 100).toInt()}%', style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          ),
        ],
      ),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  final OutagePrediction prediction;
  const _PredictionCard({required this.prediction});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hours = prediction.predictedStart.difference(DateTime.now()).inHours;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(
                label: '${(prediction.probability * 100).toInt()}% likely',
                color: prediction.probability > 0.7 ? AppColors.ghanaRed : AppColors.warning,
              ),
              const Spacer(),
              Text('In ${hours}h', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ghanaGold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(prediction.area, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(prediction.reason, style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: prediction.contributingFactors.map((f) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(f, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _MaintenanceItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String priority;

  const _MaintenanceItem({required this.title, required this.subtitle, required this.date, required this.priority});

  Color get _priorityColor {
    switch (priority) {
      case 'HIGH': return AppColors.ghanaRed;
      case 'MEDIUM': return AppColors.warning;
      default: return AppColors.ghanaGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(color: _priorityColor, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(date, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            StatusBadge(label: priority, color: _priorityColor),
          ],
        ),
      ],
    );
  }
}

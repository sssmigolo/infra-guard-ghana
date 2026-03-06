// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Outage Prediction Detail Screen

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/models/sample_data.dart';

class OutagePredictionScreen extends StatelessWidget {
  const OutagePredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Predictions'),
        actions: [
          IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            GlassCard(
              padding: const EdgeInsets.all(20),
              borderColor: AppColors.ghanaGold.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_graph, color: AppColors.ghanaGold),
                      const SizedBox(width: 8),
                      Text('Prediction Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _SummaryItem(label: 'Next 24h', value: '1 area', color: AppColors.ghanaRed)),
                      Expanded(child: _SummaryItem(label: 'Next 48h', value: '2 areas', color: AppColors.warning)),
                      Expanded(child: _SummaryItem(label: 'Next 72h', value: '3 areas', color: AppColors.info)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'AI model trained on 5 years of ECG outage data, weather patterns, and load curves for Greater Accra, Ashanti, and Northern regions.',
                    style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Detailed predictions
            Text('Detailed Forecasts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...SampleData.predictions.map((pred) {
              final hours = pred.predictedStart.difference(DateTime.now()).inHours;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(pred.area, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (pred.probability > 0.7 ? AppColors.ghanaRed : AppColors.warning).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${(pred.probability * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: pred.probability > 0.7 ? AppColors.ghanaRed : AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(icon: Icons.schedule, label: 'Expected in', value: '${hours} hours'),
                      _DetailRow(icon: Icons.timer, label: 'Est. duration', value: '${pred.estimatedDuration.inHours} hours'),
                      _DetailRow(icon: Icons.info_outline, label: 'Reason', value: pred.reason),
                      _DetailRow(icon: Icons.psychology, label: 'AI confidence', value: '${(pred.confidenceScore * 100).toInt()}%'),
                      const SizedBox(height: 12),
                      Text('Contributing Factors', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      ...pred.contributingFactors.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Container(width: 4, height: 4, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.ghanaGold)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(f, style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))),
                          ],
                        ),
                      )),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.notification_add, size: 16),
                              label: Text('Set Alert', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.assignment, size: 16),
                              label: Text('Work Order', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.ghanaGold),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

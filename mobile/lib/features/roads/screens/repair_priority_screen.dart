// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Repair Priority List Screen

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/models/models.dart';
import '../../../shared/models/sample_data.dart';

class RepairPriorityScreen extends StatelessWidget {
  const RepairPriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sortedReports = List<RoadReport>.from(SampleData.roadReports)
      ..sort((a, b) => (a.timeToFailureDays ?? 999).compareTo(b.timeToFailureDays ?? 999));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Priority List'),
        actions: [
          IconButton(icon: Icon(Icons.picture_as_pdf), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedReports.length,
        itemBuilder: (context, index) {
          final report = sortedReports[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Priority header
                  Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _urgencyColor(report).withValues(alpha: 0.15),
                        ),
                        child: Center(child: Text('#${index + 1}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _urgencyColor(report)))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(report.address, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            Text(report.defectType.name.toUpperCase(), style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                      StatusBadge(label: '${report.timeToFailureDays ?? "?"}d', color: _urgencyColor(report)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (report.aiAnalysis != null)
                    Text(report.aiAnalysis!, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.payments, size: 14, color: AppColors.ghanaGold),
                      const SizedBox(width: 4),
                      Text('GH₵ ${report.estimatedRepairCost?.toStringAsFixed(0) ?? "TBD"}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 12), textStyle: TextStyle(fontSize: 12)),
                          child: Text('Assign Contractor'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _urgencyColor(RoadReport report) {
    final days = report.timeToFailureDays ?? 999;
    if (days <= 7) return AppColors.ghanaRed;
    if (days <= 30) return AppColors.warning;
    return AppColors.ghanaGreen;
  }
}

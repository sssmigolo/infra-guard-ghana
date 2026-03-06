// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Work Orders Screen

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/models/models.dart';
import '../../../shared/models/sample_data.dart';

class WorkOrdersScreen extends StatelessWidget {
  const WorkOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Orders'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: SampleData.workOrders.length,
        itemBuilder: (context, index) {
          final wo = SampleData.workOrders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              borderColor: wo.type == WorkOrderType.combined
                  ? AppColors.warning.withValues(alpha: 0.3) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        wo.type == WorkOrderType.electricity ? Icons.bolt
                            : wo.type == WorkOrderType.roads ? Icons.add_road
                            : Icons.merge_type,
                        color: wo.type == WorkOrderType.electricity ? AppColors.ghanaGold
                            : wo.type == WorkOrderType.roads ? AppColors.ghanaGreen
                            : AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(
                        label: wo.type.name.toUpperCase(),
                        color: wo.type == WorkOrderType.combined ? AppColors.warning : AppColors.info,
                      ),
                      const Spacer(),
                      StatusBadge(
                        label: wo.priority.name.toUpperCase(),
                        color: wo.priority == WorkOrderPriority.critical ? AppColors.ghanaRed
                            : wo.priority == WorkOrderPriority.high ? AppColors.warning
                            : AppColors.ghanaGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(wo.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(wo.description, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(wo.location, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                      const Spacer(),
                      if (wo.urgencyScore != null)
                        RiskScoreIndicator(score: wo.urgencyScore!, size: 32),
                    ],
                  ),
                  if (wo.assignedTeam != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.group, size: 14, color: AppColors.ghanaGold),
                        const SizedBox(width: 4),
                        Expanded(child: Text(wo.assignedTeam!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                        StatusBadge(label: wo.status.toUpperCase(), color: wo.status == 'in_progress' ? AppColors.info : AppColors.ghanaGold),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

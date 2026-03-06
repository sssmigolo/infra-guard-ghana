// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Analytics & Dashboard Screen

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Analytics & Reports'),
            actions: [
              IconButton(
                icon: Icon(Icons.picture_as_pdf),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDF report generation coming soon!'), backgroundColor: AppColors.ghanaGold),
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // KPI Cards
                Row(
                  children: [
                    Expanded(child: MetricCard(title: 'Downtime Saved', value: '847h', icon: Icons.speed, color: AppColors.ghanaGold, trend: '+23%', subtitle: 'This quarter vs last')),
                    const SizedBox(width: 12),
                    Expanded(child: MetricCard(title: 'Roads Fixed', value: '142km', icon: Icons.add_road, color: AppColors.ghanaGreen, trend: '+18%', subtitle: 'Year to date')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: MetricCard(title: 'CO₂ Reduced', value: '4.2t', icon: Icons.eco, color: AppColors.success, trend: '-15%', subtitle: 'Generator hours saved')),
                    const SizedBox(width: 12),
                    Expanded(child: MetricCard(title: 'Reports Filed', value: '2,847', icon: Icons.assignment, color: AppColors.info, trend: '+45%', subtitle: 'By citizens this month')),
                  ],
                ),
                const SizedBox(height: 24),

                // Power Uptime Chart placeholder
                Text('Grid Uptime Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('97.2%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.ghanaGreen)),
                          const SizedBox(width: 8),
                          StatusBadge(label: '+2.1%', color: AppColors.ghanaGreen),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Current grid uptime', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                      const SizedBox(height: 20),
                      // Chart placeholder
                      SizedBox(
                        height: 160,
                        child: CustomPaint(
                          size: Size(double.infinity, 160),
                          painter: _ChartPainter(isDark: isDark),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'].map((m) =>
                          Text(m, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                        ).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Regional breakdown
                Text('Regional Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    children: [
                      _RegionRow(region: 'Greater Accra', outages: 12, roads: 45, score: 0.78),
                      const Divider(height: 20),
                      _RegionRow(region: 'Ashanti', outages: 8, roads: 32, score: 0.82),
                      const Divider(height: 20),
                      _RegionRow(region: 'Northern', outages: 15, roads: 28, score: 0.65),
                      const Divider(height: 20),
                      _RegionRow(region: 'Western', outages: 6, roads: 22, score: 0.88),
                      const Divider(height: 20),
                      _RegionRow(region: 'Volta', outages: 9, roads: 18, score: 0.74),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Cross-module intelligence
                Text('Cross-Module Intelligence', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                GlassCard(
                  borderColor: AppColors.warning.withValues(alpha: 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.ghanaGold),
                          const SizedBox(width: 8),
                          Text('AI Correlation Engine', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _CorrelationItem(
                        text: 'Road X flooding will damage power line Y in 48 hrs',
                        score: 92,
                        type: 'COMBINED',
                      ),
                      const SizedBox(height: 8),
                      _CorrelationItem(
                        text: 'Transformer T-045 degradation accelerated by nearby road vibration',
                        score: 76,
                        type: 'INFRASTRUCTURE',
                      ),
                      const SizedBox(height: 8),
                      _CorrelationItem(
                        text: 'Load spike predicted during Kumasi market day + road closure',
                        score: 68,
                        type: 'PREDICTION',
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

class _RegionRow extends StatelessWidget {
  final String region;
  final int outages;
  final int roads;
  final double score;
  const _RegionRow({required this.region, required this.outages, required this.roads, required this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(region, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        SizedBox(width: 60, child: Row(children: [Icon(Icons.bolt, size: 12, color: AppColors.ghanaGold), const SizedBox(width: 4), Text('$outages', style: TextStyle(fontSize: 12))])),
        SizedBox(width: 60, child: Row(children: [Icon(Icons.add_road, size: 12, color: AppColors.ghanaGreen), const SizedBox(width: 4), Text('$roads', style: TextStyle(fontSize: 12))])),
        RiskScoreIndicator(score: score, size: 32),
      ],
    );
  }
}

class _CorrelationItem extends StatelessWidget {
  final String text;
  final int score;
  final String type;
  const _CorrelationItem({required this.text, required this.score, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkBg : AppColors.lightBg),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (score > 80 ? AppColors.ghanaRed : AppColors.warning).withValues(alpha: 0.15),
            ),
            child: Center(child: Text('$score%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: score > 80 ? AppColors.ghanaRed : AppColors.warning))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: TextStyle(fontSize: 12), maxLines: 2),
                const SizedBox(height: 4),
                StatusBadge(label: type, color: AppColors.info),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final bool isDark;
  _ChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.ghanaGold
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final points = [0.3, 0.25, 0.35, 0.2, 0.15, 0.1];

    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = points[i] * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = ((i - 1) / (points.length - 1)) * size.width;
        final prevY = points[i - 1] * size.height;
        final cpX1 = prevX + (x - prevX) / 3;
        final cpX2 = x - (x - prevX) / 3;
        path.cubicTo(cpX1, prevY, cpX2, y, x, y);
      }
    }
    canvas.drawPath(path, paint);

    // Fill gradient
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.ghanaGold.withValues(alpha: 0.2), AppColors.ghanaGold.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Dots
    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = points[i] * size.height;
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = AppColors.ghanaGold);
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = isDark ? AppColors.darkBg : Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

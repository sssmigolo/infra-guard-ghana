// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Home Screen (Unified Ghana Resilience Map)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/models/models.dart';
import '../../../shared/models/sample_data.dart';
import '../widgets/map_layer_toggle.dart';
import '../widgets/asset_info_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _showPowerGrid = true;
  bool _showRoadNetwork = true;
  bool _showOutageHeatmap = true;
  bool _showFloodRisk = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Map placeholder (replace with GoogleMap widget)
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF0D1B2A), const Color(0xFF1B2838), const Color(0xFF0D1B2A)]
                    : [const Color(0xFFE8EDF5), const Color(0xFFD4DCE8), const Color(0xFFE8EDF5)],
              ),
            ),
            child: CustomPaint(
              painter: _MapGridPainter(isDark: isDark),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.map_rounded,
                      size: 64,
                      color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                          .withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ghana Resilience Map',
                      style: TextStyle(
                        fontSize: 16,
                        color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Connect Google Maps API to activate',
                      style: TextStyle(
                        fontSize: 12,
                        color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // Search bar
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    borderRadius: 24,
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.ghanaGold, Color(0xFFE5BC00)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.shield_rounded, size: 18, color: AppColors.ghanaBlack),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search locations, assets...',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.ghanaGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.mic, size: 16, color: AppColors.ghanaGold),
                              const SizedBox(width: 4),
                              Text('Twi', style: TextStyle(fontSize: 11, color: AppColors.ghanaGold, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Layer toggles
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        MapLayerToggle(
                          icon: Icons.bolt,
                          label: 'Power Grid',
                          isActive: _showPowerGrid,
                          color: AppColors.ghanaGold,
                          onTap: () => setState(() => _showPowerGrid = !_showPowerGrid),
                        ),
                        const SizedBox(width: 8),
                        MapLayerToggle(
                          icon: Icons.add_road,
                          label: 'Roads',
                          isActive: _showRoadNetwork,
                          color: AppColors.ghanaGreen,
                          onTap: () => setState(() => _showRoadNetwork = !_showRoadNetwork),
                        ),
                        const SizedBox(width: 8),
                        MapLayerToggle(
                          icon: Icons.thermostat,
                          label: 'Outage Heat',
                          isActive: _showOutageHeatmap,
                          color: AppColors.ghanaRed,
                          onTap: () => setState(() => _showOutageHeatmap = !_showOutageHeatmap),
                        ),
                        const SizedBox(width: 8),
                        MapLayerToggle(
                          icon: Icons.water,
                          label: 'Flood Risk',
                          isActive: _showFloodRisk,
                          color: AppColors.info,
                          onTap: () => setState(() => _showFloodRisk = !_showFloodRisk),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom quick alerts panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [Colors.transparent, AppColors.darkBg.withValues(alpha: 0.95)]
                      : [Colors.transparent, AppColors.lightBg.withValues(alpha: 0.95)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Active alerts
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.ghanaRed,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.ghanaRed.withValues(alpha: _pulseController.value * 0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '3 Active Alerts',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All', style: TextStyle(color: AppColors.ghanaGold, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Alert cards
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _AlertCard(
                          icon: Icons.bolt,
                          iconColor: AppColors.ghanaRed,
                          title: 'Active Outage: Osu',
                          subtitle: '12,500 affected • Est. 4hrs remaining',
                          urgency: 'HIGH',
                          onTap: () => context.go('/electricity'),
                        ),
                        const SizedBox(width: 12),
                        _AlertCard(
                          icon: Icons.warning_amber_rounded,
                          iconColor: AppColors.warning,
                          title: 'Cross-Module Alert',
                          subtitle: 'Kaneshie flood → Power line at risk',
                          urgency: '92%',
                          onTap: () => context.go('/work-orders'),
                        ),
                        const SizedBox(width: 12),
                        _AlertCard(
                          icon: Icons.add_road,
                          iconColor: AppColors.ghanaRed,
                          title: 'Critical: Kaneshie Road',
                          subtitle: 'Severe flooding • 7 days to failure',
                          urgency: 'CRITICAL',
                          onTap: () => context.go('/roads'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FAB for quick report
          Positioned(
            right: 16,
            bottom: 160,
            child: FloatingActionButton(
              heroTag: 'report',
              backgroundColor: AppColors.ghanaGold,
              onPressed: () {
                _showQuickReportSheet(context);
              },
              child: const Icon(Icons.add_a_photo, color: AppColors.ghanaBlack),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _ReportOption(
                    icon: Icons.bolt,
                    label: 'Power Issue',
                    color: AppColors.ghanaGold,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/electricity/technician');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ReportOption(
                    icon: Icons.add_road,
                    label: 'Road Issue',
                    color: AppColors.ghanaGreen,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/roads/report');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String urgency;
  final VoidCallback onTap;

  const _AlertCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.urgency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                const Spacer(),
                StatusBadge(label: urgency, color: iconColor),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ReportOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple map grid painter for placeholder
class _MapGridPainter extends CustomPainter {
  final bool isDark;
  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Simulated map dots for Ghana locations
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final locations = [
      (0.45, 0.65, AppColors.ghanaRed),    // Accra
      (0.35, 0.45, AppColors.ghanaGold),   // Kumasi
      (0.4, 0.25, AppColors.ghanaGreen),   // Tamale
      (0.55, 0.55, AppColors.info),        // Koforidua
      (0.25, 0.6, AppColors.warning),      // Cape Coast
    ];

    for (final loc in locations) {
      dotPaint.color = (loc.$3 as Color).withValues(alpha: 0.3);
      canvas.drawCircle(
        Offset(size.width * loc.$1, size.height * loc.$2),
        12,
        dotPaint,
      );
      dotPaint.color = (loc.$3 as Color).withValues(alpha: 0.7);
      canvas.drawCircle(
        Offset(size.width * loc.$1, size.height * loc.$2),
        4,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

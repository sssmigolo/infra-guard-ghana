// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Map Layer Toggle Widget

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MapLayerToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const MapLayerToggle({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: isDark ? 0.2 : 0.15)
              : (isDark ? AppColors.darkCard.withValues(alpha: 0.8) : AppColors.lightCard.withValues(alpha: 0.8)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color.withValues(alpha: 0.5) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isActive ? color : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? color : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

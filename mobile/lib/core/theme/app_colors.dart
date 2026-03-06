// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - App Theme Colors (Ghana Flag Accent)

import 'package:flutter/material.dart';

/// Ghana-inspired color palette for InfraGuard AI
class AppColors {
  AppColors._();

  // === Ghana Flag Colors ===
  static const Color ghanaGold = Color(0xFFFCD116);
  static const Color ghanaGreen = Color(0xFF006B3F);
  static const Color ghanaRed = Color(0xFFCE1126);
  static const Color ghanaBlack = Color(0xFF000000);

  // === Primary Palette ===
  static const Color primary = ghanaGold;
  static const Color primaryDark = Color(0xFFE5BC00);
  static const Color primaryLight = Color(0xFFFFF3C4);

  // === Semantic Colors ===
  static const Color success = ghanaGreen;
  static const Color successLight = Color(0xFFD4EDDA);
  static const Color danger = ghanaRed;
  static const Color dangerLight = Color(0xFFFCE4E8);
  static const Color warning = Color(0xFFFF9500);
  static const Color warningLight = Color(0xFFFFF3CD);
  static const Color info = Color(0xFF0A84FF);
  static const Color infoLight = Color(0xFFCCE5FF);

  // === Road Condition Colors ===
  static const Color roadGood = Color(0xFF34C759);
  static const Color roadFair = Color(0xFFFFCC02);
  static const Color roadPoor = Color(0xFFFF3B30);
  static const Color roadCritical = Color(0xFF8B0000);

  // === Dark Mode ===
  static const Color darkBg = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF141929);
  static const Color darkCard = Color(0xFF1C2137);
  static const Color darkBorder = Color(0xFF2A3050);
  static const Color darkText = Color(0xFFF0F0F5);
  static const Color darkTextSecondary = Color(0xFF8E92A4);

  // === Light Mode ===
  static const Color lightBg = Color(0xFFF8F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightText = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // === Glassmorphism ===
  static const Color glassDark = Color(0x33FFFFFF);
  static const Color glassLight = Color(0x80FFFFFF);
  static const Color glassBorder = Color(0x40FFFFFF);
}

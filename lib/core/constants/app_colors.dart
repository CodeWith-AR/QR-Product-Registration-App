import 'package:flutter/material.dart';

/// All color constants for AuthentiCheck design system.
/// Sourced from the Stitch design system tokens.
class AppColors {
  AppColors._();

  // ── Primary ──
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF3525CD);
  static const Color primaryContainer = Color(0xFF4F46E5);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFDAD7FF);

  // ── Secondary ──
  static const Color secondary = Color(0xFF9333EA);
  static const Color secondaryLight = Color(0xFF9E41F5);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ── Tertiary ──
  static const Color tertiary = Color(0xFF0EA5E9);
  static const Color tertiaryDark = Color(0xFF004D70);

  // ── Surfaces ──
  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EA);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceDim = Color(0xFFD8DADC);

  // ── On Surface ──
  static const Color onBackground = Color(0xFF191C1E);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF464555);

  // ── Outline ──
  static const Color outline = Color(0xFF777587);
  static const Color outlineVariant = Color(0xFFC7C4D8);

  // ── Error ──
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // ── Status ──
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFEAB308);
  static const Color warningBg = Color(0xFFFEF9C3);
  static const Color infoBg = Color(0xFFE0E7FF);

  // ── Inverse ──
  static const Color inverseSurface = Color(0xFF2D3133);
  static const Color inverseOnSurface = Color(0xFFEFF1F3);
  static const Color inversePrimary = Color(0xFFC3C0FF);

  // ── Gradient ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF9333EA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFEDE9FE), Color(0xFFE0E7FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

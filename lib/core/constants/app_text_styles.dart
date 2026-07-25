import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography styles using Manrope font family.
/// Matches the Stitch design system typography tokens.
class AppTextStyles {
  AppTextStyles._();

  // ── Display ──
  static TextStyle displayLg = GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 40 / 32,
    letterSpacing: -0.64,
    color: AppColors.onSurface,
  );

  // ── Headline ──
  static TextStyle headlineMd = GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.24,
    color: AppColors.onSurface,
  );

  static TextStyle headlineSm = GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 28 / 20,
    color: AppColors.onSurface,
  );

  // ── Title ──
  static TextStyle titleSm = GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: AppColors.onSurface,
  );

  static TextStyle titleXs = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    color: AppColors.onSurface,
  );

  // ── Body ──
  static TextStyle bodyLg = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  static TextStyle bodyMd = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.onSurface,
  );

  static TextStyle bodySm = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.onSurfaceVariant,
  );

  // ── Label ──
  static TextStyle labelCaps = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 0.6,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle labelMd = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    color: AppColors.onSurface,
  );

  // ── Button ──
  static TextStyle button = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    color: AppColors.onPrimary,
  );

  static TextStyle buttonSm = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    color: AppColors.onPrimary,
  );
}

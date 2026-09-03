import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografia do Atlas (Inter; letter-spacing negativo em títulos).
abstract class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final primary = brightness == Brightness.dark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondary = brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return _build(primary, secondary);
  }

  static TextTheme textThemeForPalette(AppPalette palette) {
    return _build(palette.textPrimary, palette.textSecondary);
  }

  static TextTheme _build(Color primary, Color secondary) {
    final base = GoogleFonts.interTextTheme();

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: primary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.1,
      ),
      displayMedium: base.displayMedium?.copyWith(
        color: primary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.15,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: primary,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: primary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: primary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: primary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: primary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: secondary,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: primary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: base.labelMedium?.copyWith(
        color: secondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: secondary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Métrica grande (valores numéricos em destaque).
  static TextStyle metric(BuildContext context, {double size = 28}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: AppColors.textPrimary(context),
      height: 1.1,
    );
  }

  /// Título das abas principais e sheets (Home, Workouts, Settings…).
  static TextStyle shellTitle(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      height: 1.1,
      color: AppColors.textPrimary(context),
    );
  }

  /// Alias semântico — mesmo peso visual do shell title.
  static TextStyle sheetTitle(BuildContext context) => shellTitle(context);

  static TextStyle pageTitle(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: AppColors.textPrimary(context),
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: AppColors.textPrimary(context),
    );
  }

  static TextStyle cardTitle(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      height: 1.15,
      color: AppColors.textPrimary(context),
    );
  }

  static TextStyle meta(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary(context),
    );
  }

  static TextStyle body(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: AppColors.textPrimary(context),
    );
  }

  static TextStyle caption(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary(context),
    );
  }
}

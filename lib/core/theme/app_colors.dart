import 'package:flutter/material.dart';

/// Tokens de cor do Atlas: dark-first monocromático + accent pontual.
class AppColors {
  AppColors._();

  // Accent (Atlas)
  static const Color accent = Color(0xFF6E947C);
  static const Color mutedTeal = accent;

  // Dark surfaces
  static const Color darkSurface = Color(0xFF0A0A0D);
  static const Color darkSurfaceSecondary = Color(0xFF222226);
  static const Color darkComponent = Color(0xFF2E2E33);
  static const Color darkComponentHover = Color(0xFF46474C);
  static const Color darkBorder = Color(0xFF525359);

  // Light surfaces
  static const Color lightSurface = Color(0xFFF0F0F2);
  static const Color lightSurfaceSecondary = Color(0xFFFFFFFF);
  static const Color lightComponent = Color(0xFFE8EBED);
  static const Color lightComponentHover = Color(0xFFD8DBDE);
  static const Color lightBorder = Color(0xFFC8CCD0);

  // Text
  static const Color darkTextPrimary = Color(0xFFE6E6E6);
  static const Color darkTextSecondary = Color(0xFFA8A9B2);
  static const Color lightTextPrimary = Color(0xFF0A0A0D);
  static const Color lightTextSecondary = Color(0xFF525359);

  // Neutros / utilitários
  static const Color platinum = Color(0xFFE8EBED);
  static const Color white = Color(0xFFFFFFFF);
  static const Color carbon = Color(0xFF272727);
  static const Color black = Color(0xFF000000);

  // Estados
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);

  // Helpers contextuais
  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurface
          : lightSurface;

  static Color surfaceSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurfaceSecondary
          : lightSurfaceSecondary;

  static Color component(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkComponent
          : lightComponent;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextPrimary
          : lightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextSecondary
          : lightTextSecondary;

  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBorder
          : lightBorder;
}

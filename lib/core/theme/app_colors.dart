import 'package:atlas_mobile_pi1/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Tokens de cor do Atlas.
///
/// Preferir helpers contextuais ([accentOf], [component], etc.) — eles leem
/// o [AppPalette] do tema ativo. Constantes estáticas restantes são semânticas
/// ([error], [white]) ou usadas pela tipografia.
class AppColors {
  AppColors._();

  // Text
  static const Color darkTextPrimary = Color(0xFFE6E6E6);
  static const Color darkTextSecondary = Color(0xFFA8A9B2);
  static const Color lightTextPrimary = Color(0xFF0A0A0D);
  static const Color lightTextSecondary = Color(0xFF525359);

  // Neutros / estados
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE53935);

  static AppPalette paletteOf(BuildContext context) {
    return Theme.of(context).extension<AppPalette>() ?? AppPalettes.dark;
  }

  static Color accentOf(BuildContext context) => paletteOf(context).accent;

  static Color onAccentOf(BuildContext context) => paletteOf(context).onAccent;

  static Color surface(BuildContext context) => paletteOf(context).scaffold;

  static Color surfaceSecondary(BuildContext context) =>
      paletteOf(context).surface;

  static Color component(BuildContext context) => paletteOf(context).component;

  static Color textPrimary(BuildContext context) =>
      paletteOf(context).textPrimary;

  static Color textSecondary(BuildContext context) =>
      paletteOf(context).textSecondary;

  static Color border(BuildContext context) => paletteOf(context).border;

  /// Fundo cinza para controles desabilitados (theme-aware).
  static Color disabledBackground(BuildContext context) {
    final palette = paletteOf(context);
    return palette.component.withValues(
      alpha: palette.isDark ? 0.55 : 0.65,
    );
  }

  /// Texto/ícone para controles desabilitados (theme-aware).
  static Color disabledForeground(BuildContext context) {
    final palette = paletteOf(context);
    return palette.isDark
        ? palette.textSecondary.withValues(alpha: 0.8)
        : palette.textSecondary.withValues(alpha: 0.95);
  }
}

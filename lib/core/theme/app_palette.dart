import 'package:atlas_mobile_pi1/core/theme/app_theme_id.dart';
import 'package:flutter/material.dart';

/// Tokens de cor de um tema Atlas, expostos via [ThemeExtension].
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.id,
    required this.brightness,
    required this.scaffold,
    required this.surface,
    required this.component,
    required this.componentHover,
    required this.border,
    required this.accent,
    required this.onAccent,
    required this.textPrimary,
    required this.textSecondary,
  });

  final AppThemeId id;
  final Brightness brightness;
  final Color scaffold;
  final Color surface;
  final Color component;
  final Color componentHover;
  final Color border;
  final Color accent;
  final Color onAccent;
  final Color textPrimary;
  final Color textSecondary;

  bool get isDark => brightness == Brightness.dark;

  @override
  AppPalette copyWith({
    AppThemeId? id,
    Brightness? brightness,
    Color? scaffold,
    Color? surface,
    Color? component,
    Color? componentHover,
    Color? border,
    Color? accent,
    Color? onAccent,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return AppPalette(
      id: id ?? this.id,
      brightness: brightness ?? this.brightness,
      scaffold: scaffold ?? this.scaffold,
      surface: surface ?? this.surface,
      component: component ?? this.component,
      componentHover: componentHover ?? this.componentHover,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    // Crossing light↔dark: snap instead of lerping mixed tokens (dark text on
    // dark surfaces mid-transition, etc.). Same-brightness themes can lerp.
    if (brightness != other.brightness) {
      return t < 0.5 ? this : other;
    }
    return AppPalette(
      id: t < 0.5 ? id : other.id,
      brightness: brightness,
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      component: Color.lerp(component, other.component, t)!,
      componentHover: Color.lerp(componentHover, other.componentHover, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

/// Catálogo das 7 paletas.
abstract class AppPalettes {
  static AppPalette of(AppThemeId id) => switch (id) {
        AppThemeId.light => light,
        AppThemeId.sunset => sunset,
        AppThemeId.cyberpunk => cyberpunk,
        AppThemeId.storm => storm,
        AppThemeId.ocean => ocean,
        AppThemeId.dark => dark,
        AppThemeId.midnight => midnight,
      };

  static const light = AppPalette(
    id: AppThemeId.light,
    brightness: Brightness.light,
    scaffold: Color(0xFFF0F0F2),
    surface: Color(0xFFFFFFFF),
    component: Color(0xFFE8EBED),
    componentHover: Color(0xFFD8DBDE),
    border: Color(0xFFC8CCD0),
    accent: Color(0xFF6E947C),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0A0A0D),
    textSecondary: Color(0xFF525359),
  );

  /// Por do sol — creme / pêssego / coral.
  static const sunset = AppPalette(
    id: AppThemeId.sunset,
    brightness: Brightness.light,
    scaffold: Color(0xFFFFF5EE),
    surface: Color(0xFFFFFBF7),
    component: Color(0xFFFFE8DC),
    componentHover: Color(0xFFFFD9C7),
    border: Color(0xFFE8C4B0),
    accent: Color(0xFFE07A5F),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF3D2C29),
    textSecondary: Color(0xFF8B6B63),
  );

  /// Retro-futurista — neon amarelo + roxo.
  static const cyberpunk = AppPalette(
    id: AppThemeId.cyberpunk,
    brightness: Brightness.dark,
    scaffold: Color(0xFF0D0A12),
    surface: Color(0xFF1A1225),
    component: Color(0xFF2A1F3D),
    componentHover: Color(0xFF3D2E55),
    border: Color(0xFF5B3F7A),
    accent: Color(0xFFFCEE0A),
    onAccent: Color(0xFF0D0A12),
    textPrimary: Color(0xFFF2E9FF),
    textSecondary: Color(0xFFB39DDB),
  );

  /// Nubank dark — roxos profundos.
  static const storm = AppPalette(
    id: AppThemeId.storm,
    brightness: Brightness.dark,
    scaffold: Color(0xFF12081A),
    surface: Color(0xFF1E0F2E),
    component: Color(0xFF2D1845),
    componentHover: Color(0xFF3F2260),
    border: Color(0xFF5A3480),
    accent: Color(0xFF9B6DFF),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFF0E6FF),
    textSecondary: Color(0xFFB8A0D4),
  );

  /// Fundo do mar — navy / teal.
  static const ocean = AppPalette(
    id: AppThemeId.ocean,
    brightness: Brightness.dark,
    scaffold: Color(0xFF06141C),
    surface: Color(0xFF0C2430),
    component: Color(0xFF143A48),
    componentHover: Color(0xFF1C4F60),
    border: Color(0xFF2A6578),
    accent: Color(0xFF2EC4B6),
    onAccent: Color(0xFF06141C),
    textPrimary: Color(0xFFE0F4F7),
    textSecondary: Color(0xFF8BB8C4),
  );

  /// AMOLED padrão Atlas.
  static const dark = AppPalette(
    id: AppThemeId.dark,
    brightness: Brightness.dark,
    scaffold: Color(0xFF0A0A0D),
    surface: Color(0xFF222226),
    component: Color(0xFF2E2E33),
    componentHover: Color(0xFF46474C),
    border: Color(0xFF525359),
    accent: Color(0xFF6E947C),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFE6E6E6),
    textSecondary: Color(0xFFA8A9B2),
  );

  /// Batman / treino de madrugada — quase preto.
  static const midnight = AppPalette(
    id: AppThemeId.midnight,
    brightness: Brightness.dark,
    scaffold: Color(0xFF000000),
    surface: Color(0xFF0C0C0E),
    component: Color(0xFF16161A),
    componentHover: Color(0xFF242428),
    border: Color(0xFF2E2E33),
    accent: Color(0xFF4A5F8A),
    onAccent: Color(0xFFE8ECF4),
    textPrimary: Color(0xFFD0D0D4),
    textSecondary: Color(0xFF6E6E78),
  );
}

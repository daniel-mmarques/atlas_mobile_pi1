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

/// Catálogo das paletas Atlas (Light → Midnight).
abstract class AppPalettes {
  static AppPalette of(AppThemeId id) => switch (id) {
        AppThemeId.light => light,
        AppThemeId.arctic => arctic,
        AppThemeId.sakura => sakura,
        AppThemeId.sunset => sunset,
        AppThemeId.coffee => coffee,
        AppThemeId.ocean => ocean,
        AppThemeId.storm => storm,
        AppThemeId.cyberpunk => cyberpunk,
        AppThemeId.dark => dark,
        AppThemeId.midnight => midnight,
      };

  /// Clean neutro — branco + cinza + azul.
  static const light = AppPalette(
    id: AppThemeId.light,
    brightness: Brightness.light,
    scaffold: Color(0xFFF0F2F5),
    surface: Color(0xFFFFFFFF),
    component: Color(0xFFD5DAE0),
    componentHover: Color(0xFFC4CAD2),
    border: Color(0xFFB0B7C0),
    accent: Color(0xFF4A7FD4),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0A0A0D),
    textSecondary: Color(0xFF525359),
  );

  /// Gelo — branco + azul-gelo + azul.
  static const arctic = AppPalette(
    id: AppThemeId.arctic,
    brightness: Brightness.light,
    scaffold: Color(0xFFEEF6FA),
    surface: Color(0xFFF8FCFE),
    component: Color(0xFFC8DCE8),
    componentHover: Color(0xFFB4CEDC),
    border: Color(0xFF9CB8C8),
    accent: Color(0xFF3A8BB8),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF163048),
    textSecondary: Color(0xFF5A7A90),
  );

  /// Flores de cerejeira — rosa suave / branco / vinho.
  static const sakura = AppPalette(
    id: AppThemeId.sakura,
    brightness: Brightness.light,
    scaffold: Color(0xFFFFF0F5),
    surface: Color(0xFFFFF9FB),
    component: Color(0xFFF3D0DC),
    componentHover: Color(0xFFE8BCCB),
    border: Color(0xFFDCA8BA),
    accent: Color(0xFFD4789C),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF4A2C3A),
    textSecondary: Color(0xFF9A6B7C),
  );

  /// Pôr do sol — creme / coral / laranja / roxo.
  static const sunset = AppPalette(
    id: AppThemeId.sunset,
    brightness: Brightness.light,
    scaffold: Color(0xFFFFF5EE),
    surface: Color(0xFFFFFBF7),
    component: Color(0xFFFFE0D0),
    componentHover: Color(0xFFFFD0B8),
    border: Color(0xFFE8B8A8),
    accent: Color(0xFFE07A5F),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF3D2C40),
    textSecondary: Color(0xFF8B6B7A),
  );

  /// Café — bege + creme + marrom.
  static const coffee = AppPalette(
    id: AppThemeId.coffee,
    brightness: Brightness.light,
    scaffold: Color(0xFFF5EDE4),
    surface: Color(0xFFFFF9F3),
    component: Color(0xFFE4D2C0),
    componentHover: Color(0xFFD6C0AA),
    border: Color(0xFFC4A890),
    accent: Color(0xFF8B5E3C),
    onAccent: Color(0xFFFFF8F0),
    textPrimary: Color(0xFF2C1A10),
    textSecondary: Color(0xFF7A5C48),
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

  /// Tempestade — roxo azulado + azul elétrico.
  static const storm = AppPalette(
    id: AppThemeId.storm,
    brightness: Brightness.dark,
    scaffold: Color(0xFF0A0E1A),
    surface: Color(0xFF141A2C),
    component: Color(0xFF1E2840),
    componentHover: Color(0xFF2A3858),
    border: Color(0xFF3A4A70),
    accent: Color(0xFF4B8CFF),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFE4E8F4),
    textSecondary: Color(0xFF8A9AB8),
  );

  /// Retro-futurista — preto + amarelo neon + magenta/ciano.
  static const cyberpunk = AppPalette(
    id: AppThemeId.cyberpunk,
    brightness: Brightness.dark,
    scaffold: Color(0xFF0A0810),
    surface: Color(0xFF161022),
    component: Color(0xFF261A38),
    componentHover: Color(0xFF3A2850),
    border: Color(0xFF7A3A8A),
    accent: Color(0xFFFCEE0A),
    onAccent: Color(0xFF0A0810),
    textPrimary: Color(0xFFF2E9FF),
    textSecondary: Color(0xFF5CE1E6),
  );

  /// AMOLED neutro — preto / cinza / branco.
  static const dark = AppPalette(
    id: AppThemeId.dark,
    brightness: Brightness.dark,
    scaffold: Color(0xFF0A0A0D),
    surface: Color(0xFF222226),
    component: Color(0xFF2E2E33),
    componentHover: Color(0xFF46474C),
    border: Color(0xFF525359),
    accent: Color(0xFFB0B4BC),
    onAccent: Color(0xFF0A0A0D),
    textPrimary: Color(0xFFE6E6E6),
    textSecondary: Color(0xFFA8A9B2),
  );

  /// Funil de auth (login, cadastro, onboarding). Não entra no picker.
  static const auth = AppPalette(
    id: AppThemeId.dark,
    brightness: Brightness.dark,
    scaffold: Color(0xFF050506),
    surface: Color(0xFF141416),
    component: Color(0xFF1C1C20),
    componentHover: Color(0xFF2A2A30),
    border: Color(0xFF8E8E96),
    accent: Color(0xFFC0C0C8),
    onAccent: Color(0xFF0A0A0D),
    textPrimary: Color(0xFFF4F4F6),
    textSecondary: Color(0xFFB0B0B8),
  );

  /// Batman / treino de madrugada — preto absoluto.
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

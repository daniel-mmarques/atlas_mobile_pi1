import 'package:flutter/material.dart';

/// Identificadores dos temas de aparência do Atlas.
/// Ordem = seletor (Light → Midnight).
enum AppThemeId {
  light,
  arctic,
  sakura,
  sunset,
  coffee,
  ocean,
  storm,
  cyberpunk,
  dark,
  midnight;

  String get storageName => name;

  String get label => switch (this) {
        AppThemeId.light => 'Light',
        AppThemeId.arctic => 'Arctic',
        AppThemeId.sakura => 'Sakura',
        AppThemeId.sunset => 'Sunset',
        AppThemeId.coffee => 'Coffee',
        AppThemeId.ocean => 'Ocean',
        AppThemeId.storm => 'Storm',
        AppThemeId.cyberpunk => 'Cyberpunk 2077',
        AppThemeId.dark => 'Dark',
        AppThemeId.midnight => 'Midnight',
      };

  /// Ícone que comunica a ideia visual do tema (sem swatches).
  IconData get icon => switch (this) {
        AppThemeId.light => Icons.light_mode_outlined,
        AppThemeId.arctic => Icons.ac_unit_outlined,
        AppThemeId.sakura => Icons.local_florist_outlined,
        AppThemeId.sunset => Icons.wb_twilight_outlined,
        AppThemeId.coffee => Icons.coffee_outlined,
        AppThemeId.ocean => Icons.waves_outlined,
        AppThemeId.storm => Icons.thunderstorm_outlined,
        AppThemeId.cyberpunk => Icons.electric_bolt_outlined,
        AppThemeId.dark => Icons.dark_mode_outlined,
        AppThemeId.midnight => Icons.nightlight_round,
      };

  bool get isDark => switch (this) {
        AppThemeId.light ||
        AppThemeId.arctic ||
        AppThemeId.sakura ||
        AppThemeId.sunset ||
        AppThemeId.coffee =>
          false,
        _ => true,
      };

  static AppThemeId fromStorage(String? value) {
    return AppThemeId.values.firstWhere(
      (e) => e.storageName == value,
      orElse: () => AppThemeId.dark,
    );
  }
}

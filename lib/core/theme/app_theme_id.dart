import 'package:flutter/material.dart';

/// Identificadores dos temas de aparência do Atlas.
enum AppThemeId {
  light,
  sunset,
  cyberpunk,
  storm,
  ocean,
  dark,
  midnight;

  String get storageName => name;

  String get label => switch (this) {
        AppThemeId.light => 'Light',
        AppThemeId.sunset => 'Sunset',
        AppThemeId.cyberpunk => 'Cyberpunk 2077',
        AppThemeId.storm => 'Storm',
        AppThemeId.ocean => 'Ocean',
        AppThemeId.dark => 'Dark',
        AppThemeId.midnight => 'Midnight',
      };

  /// Ícone que comunica a ideia visual do tema (sem swatches).
  IconData get icon => switch (this) {
        AppThemeId.light => Icons.light_mode_outlined,
        AppThemeId.sunset => Icons.wb_twilight_outlined,
        AppThemeId.cyberpunk => Icons.electric_bolt_outlined,
        AppThemeId.storm => Icons.thunderstorm_outlined,
        AppThemeId.ocean => Icons.waves_outlined,
        AppThemeId.dark => Icons.dark_mode_outlined,
        AppThemeId.midnight => Icons.nightlight_round,
      };

  static AppThemeId fromStorage(String? value) {
    return AppThemeId.values.firstWhere(
      (e) => e.storageName == value,
      orElse: () => AppThemeId.dark,
    );
  }
}

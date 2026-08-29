import 'package:atlas_mobile_pi1/data/datasources/local/preferences/repository_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  PreferencesRepository._();

  late final SharedPreferences _sharedPreferences;
  static PreferencesRepository? _instance;

  SharedPreferences get sharedPreferences => _sharedPreferences;

  static Future<void> init() async {
    assert(_instance == null, 'PreferencesRepository is already initialized!');
    _instance = PreferencesRepository._();
    _instance!._sharedPreferences = await SharedPreferences.getInstance();
  }

  static PreferencesRepository get instance {
    assert(_instance != null, 'PreferencesRepository is not initialized!');
    return _instance!;
  }

  bool getUserUnitSystem() {
    return _sharedPreferences.getBool(PreferencesKeys.unitSystem) ?? false;
  }

  Future<bool> toggleUnitSystem() async {
    final current = getUserUnitSystem();
    await _sharedPreferences.setBool(PreferencesKeys.unitSystem, !current);
    return !current;
  }

  Locale getUserLanguage() {
    final code = _sharedPreferences.getString(PreferencesKeys.language) ?? 'pt';
    return Locale(code);
  }

  Future<void> toogleUserLanguage(Locale locale) async {
    await _sharedPreferences.setString(
      PreferencesKeys.language,
      locale.languageCode,
    );
  }

  ThemeMode getThemeMode() {
    final isDark = _sharedPreferences.getBool(PreferencesKeys.themeMode) ?? true;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<ThemeMode> toogleThemeMode() async {
    switch (getThemeMode()) {
      case ThemeMode.light:
        await _sharedPreferences.setBool(PreferencesKeys.themeMode, true);
        return ThemeMode.dark;
      case ThemeMode.dark:
        await _sharedPreferences.setBool(PreferencesKeys.themeMode, false);
        return ThemeMode.light;
      default:
        await _sharedPreferences.setBool(PreferencesKeys.themeMode, true);
        return ThemeMode.dark;
    }
  }
}

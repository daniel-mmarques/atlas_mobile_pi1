import 'package:atlas_mobile_pi1/data/datasources/local/preferences/repository_preferences.dart';
import 'package:flutter/material.dart';

class PreferencesService extends ChangeNotifier {
  PreferencesService(this.preferencesRepository)
      : _currentLanguage = preferencesRepository.getUserLanguage(),
        _isImperialSystem = preferencesRepository.getUserUnitSystem(),
        _currentThememode = preferencesRepository.getThemeMode();

  final PreferencesRepository preferencesRepository;

  ThemeMode _currentThememode;
  Locale _currentLanguage;
  bool _isImperialSystem;

  ThemeMode get themeMode => _currentThememode;
  Locale get currentLanguage => _currentLanguage;
  bool get isImperialSystem => _isImperialSystem;
  bool get isDark => _currentThememode == ThemeMode.dark;

  Future<void> toggleThemeMode() async {
    _currentThememode = await preferencesRepository.toogleThemeMode();
    notifyListeners();
  }

  Future<void> toggleUnitSystem() async {
    _isImperialSystem = await preferencesRepository.toggleUnitSystem();
    notifyListeners();
  }

  Future<void> toggleCurrentLanguage(Locale newLocale) async {
    await preferencesRepository.toogleUserLanguage(newLocale);
    _currentLanguage = newLocale;
    notifyListeners();
  }
}

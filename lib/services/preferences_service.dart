import 'package:atlas_mobile_pi1/core/theme/app_theme_id.dart';
import 'package:atlas_mobile_pi1/data/datasources/local/preferences/repository_preferences.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/set_intensity_mode.dart';
import 'package:flutter/material.dart';

class PreferencesService extends ChangeNotifier {
  PreferencesService(this.preferencesRepository)
      : _currentLanguage = preferencesRepository.getUserLanguage(),
        _isImperialSystem = preferencesRepository.getUserUnitSystem(),
        _appThemeId = preferencesRepository.getAppThemeId(),
        _setIntensityMode = preferencesRepository.getSetIntensityMode();

  final PreferencesRepository preferencesRepository;

  AppThemeId _appThemeId;
  Locale _currentLanguage;
  bool _isImperialSystem;
  SetIntensityMode _setIntensityMode;

  AppThemeId get appThemeId => _appThemeId;
  Locale get currentLanguage => _currentLanguage;
  bool get isImperialSystem => _isImperialSystem;
  SetIntensityMode get setIntensityMode => _setIntensityMode;

  Future<void> setAppThemeId(AppThemeId id) async {
    await preferencesRepository.setAppThemeId(id);
    _appThemeId = id;
    notifyListeners();
  }

  Future<void> cycleAppThemeId() async {
    final values = AppThemeId.values;
    final next = values[(_appThemeId.index + 1) % values.length];
    await setAppThemeId(next);
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

  Future<void> cycleSetIntensityMode() async {
    final values = SetIntensityMode.values;
    final next = values[(_setIntensityMode.index + 1) % values.length];
    await preferencesRepository.setSetIntensityMode(next);
    _setIntensityMode = next;
    notifyListeners();
  }
}

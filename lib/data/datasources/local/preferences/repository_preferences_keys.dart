abstract class PreferencesKeys {
  static const String unitSystem = 'unitSystem';
  static const String language = 'language';
  static const String themeMode = 'isDark';
  static const String appThemeId = 'appThemeId';
  static const String setIntensityMode = 'setIntensityMode';

  static String homeLayout(String userId) => 'homeLayout_$userId';
}

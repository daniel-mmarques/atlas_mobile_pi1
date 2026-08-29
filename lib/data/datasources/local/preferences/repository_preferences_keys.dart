abstract class PreferencesKeys {
  static const String unitSystem = 'unitSystem';
  static const String language = 'language';
  static const String themeMode = 'isDark';

  static String homeLayout(String userId) => 'homeLayout_$userId';
}

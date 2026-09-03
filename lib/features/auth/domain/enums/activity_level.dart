import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extremelyActive;

  String label(AppLocalizations l10n) => switch (this) {
        ActivityLevel.sedentary => l10n.activitySedentary,
        ActivityLevel.lightlyActive => l10n.activityLightly,
        ActivityLevel.moderatelyActive => l10n.activityModerately,
        ActivityLevel.veryActive => l10n.activityVery,
        ActivityLevel.extremelyActive => l10n.activityExtremely,
      };

  static ActivityLevel? fromStorage(String? value) {
    if (value == null) return null;
    for (final level in ActivityLevel.values) {
      if (level.name == value) return level;
    }
    return null;
  }
}

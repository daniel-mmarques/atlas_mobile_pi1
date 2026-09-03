import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';

enum Gender {
  male,
  female,
  other;

  String label(AppLocalizations l10n) => switch (this) {
        Gender.male => l10n.genderMale,
        Gender.female => l10n.genderFemale,
        Gender.other => l10n.genderOther,
      };

  static Gender? fromStorage(String? value) {
    if (value == null) return null;
    for (final g in Gender.values) {
      if (g.name == value) return g;
    }
    return null;
  }
}

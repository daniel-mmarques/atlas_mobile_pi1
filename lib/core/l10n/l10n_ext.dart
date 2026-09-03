import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'package:atlas_mobile_pi1/l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

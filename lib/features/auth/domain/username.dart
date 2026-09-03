import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Helpers for Instagram-style unique handles (stored without leading `@`).
abstract class Username {
  static final _regex = RegExp(r'^[a-z0-9._]{3,30}$');

  static String normalize(String? value) {
    if (value == null) return '';
    var v = value.trim().toLowerCase();
    if (v.startsWith('@')) v = v.substring(1);
    return v.trim();
  }

  /// [l10n] opcional para camadas sem context (repositório); default pt.
  static String? validateFormat(String? value, [AppLocalizations? l10n]) {
    final t = l10n ?? lookupAppLocalizations(const Locale('pt'));
    final normalized = normalize(value);
    if (normalized.isEmpty) {
      return t.validationUsernameRequired;
    }
    if (normalized.length < 3) {
      return t.validationUsernameMin;
    }
    if (normalized.length > 30) {
      return t.validationUsernameMax;
    }
    if (!_regex.hasMatch(normalized)) {
      return t.validationUsernameChars;
    }
    if (normalized.startsWith('.') ||
        normalized.endsWith('.') ||
        normalized.contains('..')) {
      return t.validationUsernameInvalid;
    }
    return null;
  }

  static String handle(String? username) {
    final u = normalize(username);
    if (u.isEmpty) return '@…';
    return '@$u';
  }
}

import 'package:atlas_mobile_pi1/core/utils/date_formatters.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/username.dart';
import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';

abstract class CreateUserValidators {
  static final _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$',
  );
  static final _nameLetterRegex = RegExp(r'[A-Za-zÀ-ÿ]');
  static final _nameAllowedRegex = RegExp(r"^[A-Za-zÀ-ÿ'\-\s]+$");

  static String? username(String? value, AppLocalizations l10n) =>
      Username.validateFormat(value, l10n);

  static String? names(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationNameRequired;
    }

    final name = value.trim();
    if (name.length < 3) {
      return l10n.validationNameMin;
    }
    if (name.length > 80) {
      return l10n.validationNameMax;
    }
    if (!_nameAllowedRegex.hasMatch(name) || !_nameLetterRegex.hasMatch(name)) {
      return l10n.validationNameInvalid;
    }
    return null;
  }

  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationEmailRequired;
    }

    final email = value.trim();
    if (!_emailRegex.hasMatch(email)) {
      return l10n.validationEmailInvalid;
    }
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.validationPasswordRequired;
    }
    if (value.length < 6) {
      return l10n.validationPasswordMin;
    }
    if (value.length > 72) {
      return l10n.validationPasswordMax;
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String password,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.validationConfirmRequired;
    }
    if (value != password) {
      return l10n.validationConfirmMismatch;
    }
    return null;
  }

  static String? age(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationBirthRequired;
    }

    final birthDate = DateFormatters.parseDate(value.trim());
    if (birthDate == null) {
      return l10n.validationBirthInvalid;
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    if (birthDate.isAfter(todayDate)) {
      return l10n.validationBirthFuture;
    }

    final minBirth = DateTime(today.year - 120, today.month, today.day);
    if (birthDate.isBefore(minBirth)) {
      return l10n.validationBirthInvalidRange;
    }

    final maxDate = DateTime(today.year - 15, today.month, today.day);
    if (birthDate.isAfter(maxDate)) {
      return l10n.validationAgeMin;
    }
    return null;
  }

  static String? weight(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationWeightRequired;
    }

    final normalized = value.trim().replaceAll(',', '.');
    final weight = double.tryParse(normalized);

    if (weight == null) {
      return l10n.validationWeightNumeric;
    }
    if (weight < 30 || weight > 300) {
      return l10n.validationWeightRange;
    }
    return null;
  }

  static String? height(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationHeightRequired;
    }

    final normalized = value.trim().replaceAll(',', '.');
    final height = double.tryParse(normalized);

    if (height == null) {
      return l10n.validationHeightNumeric;
    }
    if (height < 1.0 || height > 2.5) {
      return l10n.validationHeightRange;
    }
    return null;
  }

  static String? gender(Gender? value, AppLocalizations l10n) {
    if (value == null) {
      return l10n.validationGenderRequired;
    }
    return null;
  }

  static String? activityLevel(ActivityLevel? value, AppLocalizations l10n) {
    if (value == null) {
      return l10n.validationActivityRequired;
    }
    return null;
  }
}

import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/validators/sign_up_validators.dart';
import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('pt'));

  group('CreateUserValidators', () {
    test('nome rejeita vazio, curto e inválido', () {
      expect(CreateUserValidators.names(null, l10n), isNotNull);
      expect(CreateUserValidators.names('  ', l10n), isNotNull);
      expect(CreateUserValidators.names('ab', l10n), isNotNull);
      expect(CreateUserValidators.names('123', l10n), isNotNull);
      expect(CreateUserValidators.names('Ana', l10n), isNull);
    });

    test('email exige formato válido', () {
      expect(CreateUserValidators.email(null, l10n), isNotNull);
      expect(CreateUserValidators.email('abc', l10n), isNotNull);
      expect(CreateUserValidators.email('abc@', l10n), isNotNull);
      expect(CreateUserValidators.email('user@email.com', l10n), isNull);
    });

    test('senha exige mínimo de 6 caracteres', () {
      expect(CreateUserValidators.password('', l10n), isNotNull);
      expect(CreateUserValidators.password('12345', l10n), isNotNull);
      expect(CreateUserValidators.password('123456', l10n), isNull);
    });

    test('confirmação precisa ser igual à senha', () {
      expect(CreateUserValidators.confirmPassword('', '123456', l10n), isNotNull);
      expect(
        CreateUserValidators.confirmPassword('123457', '123456', l10n),
        isNotNull,
      );
      expect(
        CreateUserValidators.confirmPassword('123456', '123456', l10n),
        isNull,
      );
    });

    test('idade mínima é 15 anos', () {
      expect(CreateUserValidators.age('', l10n), isNotNull);
      expect(CreateUserValidators.age('32/13/2000', l10n), isNotNull);
      expect(CreateUserValidators.age('01/01/2020', l10n), isNotNull);
      expect(CreateUserValidators.age('01/01/1995', l10n), isNull);
    });

    test('altura e peso respeitam faixas', () {
      expect(CreateUserValidators.height('0.9', l10n), isNotNull);
      expect(CreateUserValidators.height('1,75', l10n), isNull);
      expect(CreateUserValidators.weight('20', l10n), isNotNull);
      expect(CreateUserValidators.weight('80', l10n), isNull);
    });

    test('sexo e atividade são obrigatórios', () {
      expect(CreateUserValidators.gender(null, l10n), isNotNull);
      expect(CreateUserValidators.gender(Gender.female, l10n), isNull);
      expect(CreateUserValidators.activityLevel(null, l10n), isNotNull);
      expect(
        CreateUserValidators.activityLevel(ActivityLevel.moderatelyActive, l10n),
        isNull,
      );
    });

    test('username valida formato Instagram', () {
      expect(CreateUserValidators.username(null, l10n), isNotNull);
      expect(CreateUserValidators.username('ab', l10n), isNotNull);
      expect(CreateUserValidators.username('Bad Name', l10n), isNotNull);
      expect(CreateUserValidators.username('daniel_m', l10n), isNull);
      expect(CreateUserValidators.username('@daniel.m', l10n), isNull);
    });
  });
}

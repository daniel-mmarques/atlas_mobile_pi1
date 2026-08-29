import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/validators/sign_up_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreateUserValidators', () {
    test('nome rejeita vazio, curto e inválido', () {
      expect(CreateUserValidators.names(null), isNotNull);
      expect(CreateUserValidators.names('  '), isNotNull);
      expect(CreateUserValidators.names('ab'), isNotNull);
      expect(CreateUserValidators.names('123'), isNotNull);
      expect(CreateUserValidators.names('Ana'), isNull);
    });

    test('email exige formato válido', () {
      expect(CreateUserValidators.email(null), isNotNull);
      expect(CreateUserValidators.email('abc'), isNotNull);
      expect(CreateUserValidators.email('abc@'), isNotNull);
      expect(CreateUserValidators.email('user@email.com'), isNull);
    });

    test('senha exige mínimo de 6 caracteres', () {
      expect(CreateUserValidators.password(''), isNotNull);
      expect(CreateUserValidators.password('12345'), isNotNull);
      expect(CreateUserValidators.password('123456'), isNull);
    });

    test('confirmação precisa ser igual à senha', () {
      expect(CreateUserValidators.confirmPassword('', '123456'), isNotNull);
      expect(CreateUserValidators.confirmPassword('123457', '123456'), isNotNull);
      expect(CreateUserValidators.confirmPassword('123456', '123456'), isNull);
    });

    test('idade mínima é 15 anos', () {
      expect(CreateUserValidators.age(''), isNotNull);
      expect(CreateUserValidators.age('32/13/2000'), isNotNull);
      expect(CreateUserValidators.age('01/01/2020'), isNotNull);
      expect(CreateUserValidators.age('01/01/1995'), isNull);
    });

    test('altura e peso respeitam faixas', () {
      expect(CreateUserValidators.height('0.9'), isNotNull);
      expect(CreateUserValidators.height('1,75'), isNull);
      expect(CreateUserValidators.weight('20'), isNotNull);
      expect(CreateUserValidators.weight('80'), isNull);
    });

    test('sexo e atividade são obrigatórios', () {
      expect(CreateUserValidators.gender(null), isNotNull);
      expect(CreateUserValidators.gender(Gender.female), isNull);
      expect(CreateUserValidators.activityLevel(null), isNotNull);
      expect(
        CreateUserValidators.activityLevel(ActivityLevel.moderatelyActive),
        isNull,
      );
    });
  });
}

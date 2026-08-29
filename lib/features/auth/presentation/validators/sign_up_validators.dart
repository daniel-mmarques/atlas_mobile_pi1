import 'package:atlas_mobile_pi1/core/utils/date_formatters.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';

abstract class CreateUserValidators {
  static final _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$',
  );
  static final _nameLetterRegex = RegExp(r'[A-Za-zÀ-ÿ]');
  static final _nameAllowedRegex = RegExp(r"^[A-Za-zÀ-ÿ'\-\s]+$");

  static String? names(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu nome';
    }

    final name = value.trim();
    if (name.length < 3) {
      return 'O nome precisa ter pelo menos 3 caracteres';
    }
    if (name.length > 80) {
      return 'O nome deve ter no máximo 80 caracteres';
    }
    if (!_nameAllowedRegex.hasMatch(name) || !_nameLetterRegex.hasMatch(name)) {
      return 'Informe um nome válido';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o email';
    }

    final email = value.trim();
    if (!_emailRegex.hasMatch(email)) {
      return 'Informe um email válido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    if (value.length > 72) {
      return 'A senha deve ter no máximo 72 caracteres';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirme a senha';
    }
    if (value != password) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  static String? age(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe sua data de nascimento';
    }

    final birthDate = DateFormatters.parseDate(value.trim());
    if (birthDate == null) {
      return 'Data inválida';
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    if (birthDate.isAfter(todayDate)) {
      return 'A data não pode ser no futuro';
    }

    final minBirth = DateTime(today.year - 120, today.month, today.day);
    if (birthDate.isBefore(minBirth)) {
      return 'Informe uma data de nascimento válida';
    }

    final maxDate = DateTime(today.year - 15, today.month, today.day);
    if (birthDate.isAfter(maxDate)) {
      return 'Idade mínima é 15 anos';
    }
    return null;
  }

  static String? weight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu peso';
    }

    final normalized = value.trim().replaceAll(',', '.');
    final weight = double.tryParse(normalized);

    if (weight == null) {
      return 'Informe um peso numérico';
    }
    if (weight < 30 || weight > 300) {
      return 'Peso deve estar entre 30 e 300 kg';
    }
    return null;
  }

  static String? height(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe sua altura';
    }

    final normalized = value.trim().replaceAll(',', '.');
    final height = double.tryParse(normalized);

    if (height == null) {
      return 'Informe uma altura numérica';
    }
    if (height < 1.0 || height > 2.5) {
      return 'Altura deve estar entre 1,00 e 2,50 m';
    }
    return null;
  }

  static String? gender(Gender? value) {
    if (value == null) {
      return 'Selecione o sexo';
    }
    return null;
  }

  static String? activityLevel(ActivityLevel? value) {
    if (value == null) {
      return 'Selecione o nível de atividade';
    }
    return null;
  }
}

import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/utils/date_formatters.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:flutter/material.dart';

abstract class CreateUserValidators {
  static String? names(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu nome!';
    }
    if (value.trim().length < 3) {
      return 'Nome precisa conter 3 caracteres!';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o email';
    }
    if (!value.contains('@')) {
      return 'Email inválido';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a senha';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
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
    if (value == null || value.isEmpty) {
      return 'Informe sua data de nascimento!';
    }

    final birthDate = DateFormatters.parseDate(value);
    if (birthDate == null) {
      return 'Data inválida';
    }

    final today = DateTime.now();
    final maxDate = DateTime(today.year - 15, today.month, today.day);

    if (birthDate.isAfter(maxDate)) {
      return 'Idade mínima é 15 anos!';
    }
    return null;
  }

  static String? weight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe seu peso!';
    }

    final normalized = value.replaceAll(',', '.');
    final weight = double.tryParse(normalized);

    if (weight == null) {
      return 'Peso inválido!';
    }

    if (weight <= 0) {
      return 'Peso deve ser maior que zero!';
    }

    if (weight < 30 || weight > 300) {
      return 'Peso fora do intervalo permitido!';
    }

    return null;
  }

  static String? height(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe sua altura!';
    }

    final normalized = value.replaceAll(',', '.');
    final height = double.tryParse(normalized);

    if (height == null) {
      return 'Altura inválida!';
    }

    if (height <= 0) {
      return 'Altura deve ser maior que zero!';
    }

    if (height < 1.0 || height > 2.5) {
      return 'Altura fora do intervalo permitido!';
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

class SignUpIconContainer extends StatelessWidget {
  const SignUpIconContainer(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadii.button,
        color: AppColors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(
          icon,
          size: 24,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class SignUpRoundedContainer extends StatelessWidget {
  const SignUpRoundedContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightBorder),
        borderRadius: AppRadii.button,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: child,
      ),
    );
  }
}

import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:atlas_mobile_pi1/core/utils/date_formatters.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/validators/sign_up_validators.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    required this.uid,
    required this.usersRepository,
  });

  final String uid;
  final UserRepository usersRepository;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _currentStep = 0;
  bool _isSaving = false;

  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  Gender? _gender;
  ActivityLevel? _activityLevel;

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _completeRegistration() async {
    setState(() => _isSaving = true);

    try {
      final birthDate = DateFormatters.parseDate(_birthDateController.text);
      if (birthDate == null || _gender == null || _activityLevel == null) {
        throw Exception('Dados incompletos');
      }

      final height = double.parse(
        _heightController.text.replaceAll(',', '.'),
      );
      final weight = double.parse(
        _weightController.text.replaceAll(',', '.'),
      );

      await widget.usersRepository.completeProfile(
        uid: widget.uid,
        name: _nameController.text.trim(),
        birthDate: birthDate,
        gender: _gender!,
        height: height,
        weight: weight,
        activityLevel: _activityLevel!,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível salvar seu perfil. Tente novamente.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = AppResponsive.isCompact(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stepper(
          type: StepperType.horizontal,
          physics: const ClampingScrollPhysics(),
          currentStep: _currentStep,
          steps: [
            Step(
              title: const SizedBox.shrink(),
              label: Text(
                compact ? 'Dados' : 'Dados iniciais',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppResponsive.font(context, base: 12, min: 11),
                ),
              ),
              content: _FirstStepForm(
                formKey: _formKeys[0],
                nameController: _nameController,
                birthDateController: _birthDateController,
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const SizedBox.shrink(),
              label: Text(
                compact ? 'Físico' : 'Físico',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppResponsive.font(context, base: 12, min: 11),
                ),
              ),
              content: _SecondStepForm(
                formKey: _formKeys[1],
                heightController: _heightController,
                weightController: _weightController,
                gender: _gender,
                onGenderChanged: (value) => setState(() => _gender = value),
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const SizedBox.shrink(),
              label: Text(
                'Atividade',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppResponsive.font(context, base: 12, min: 11),
                ),
              ),
              content: _ThirdStepForm(
                formKey: _formKeys[2],
                activityLevel: _activityLevel,
                onActivityChanged: (value) =>
                    setState(() => _activityLevel = value),
              ),
              isActive: _currentStep >= 2,
            ),
          ],
          onStepContinue: () {
            FocusScope.of(context).unfocus();
            final formState = _formKeys[_currentStep].currentState;
            if (formState == null) return;
            if (!formState.validate()) return;

            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _completeRegistration();
            }
          },
          onStepCancel: () {
            FocusScope.of(context).unfocus();
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: _isSaving ? null : details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.button,
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            _currentStep == 2 ? 'Finalizar' : 'Próximo',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: AppResponsive.font(
                                context,
                                base: 15,
                                min: 13,
                              ),
                            ),
                          ),
                  ),
                  if (_currentStep > 0)
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadii.button,
                        ),
                      ),
                      onPressed: _isSaving ? null : details.onStepCancel,
                      icon: const Icon(Icons.chevron_left),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: AppResponsive.font(context, base: 20, min: 16, max: 22),
            color: AppColors.lightTextPrimary,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: AppResponsive.font(context, base: 14, min: 12, max: 15),
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _FirstStepForm extends StatelessWidget {
  const _FirstStepForm({
    required this.formKey,
    required this.nameController,
    required this.birthDateController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController birthDateController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            title: 'Olá! Seja bem vindo! Vamos começar o seu cadastro?',
            subtitle: 'Primeiro informe alguns dados básicos!',
          ),
          const SizedBox(height: 16),
          SignUpRoundedContainer(
            child: Row(
              children: [
                const SignUpIconContainer(Icons.drive_file_rename_outline),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Seu nome',
                      errorMaxLines: 2,
                    ),
                    style: TextStyle(
                      fontSize: AppResponsive.font(context, base: 15, min: 13),
                      color: AppColors.lightTextPrimary,
                    ),
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    validator: CreateUserValidators.names,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SignUpRoundedContainer(
            child: Row(
              children: [
                const SignUpIconContainer(Icons.calendar_month),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.none,
                    controller: birthDateController,
                    readOnly: true,
                    validator: CreateUserValidators.age,
                    style: TextStyle(
                      fontSize: AppResponsive.font(context, base: 15, min: 13),
                      color: AppColors.lightTextPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: '00/00/0000',
                      labelText: 'Data de nascimento',
                      border: InputBorder.none,
                      errorMaxLines: 2,
                    ),
                    onTap: () async {
                      final now = DateTime.now();
                      final pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        lastDate: now,
                        initialDate: DateTime(now.year - 18),
                      );

                      if (pickedDate != null) {
                        birthDateController.text =
                            DateFormatters.formatDate(pickedDate);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondStepForm extends StatelessWidget {
  const _SecondStepForm({
    required this.formKey,
    required this.heightController,
    required this.weightController,
    required this.gender,
    required this.onGenderChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final Gender? gender;
  final ValueChanged<Gender?> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    final stackMetrics = AppResponsive.widthOf(context) < 400;

    final heightField = SignUpRoundedContainer(
      child: Row(
        children: [
          const SignUpIconContainer(Icons.height_rounded),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Altura (m)',
                border: InputBorder.none,
                errorMaxLines: 2,
              ),
              style: TextStyle(
                fontSize: AppResponsive.font(context, base: 15, min: 13),
                color: AppColors.lightTextPrimary,
              ),
              controller: heightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: CreateUserValidators.height,
            ),
          ),
        ],
      ),
    );

    final weightField = SignUpRoundedContainer(
      child: Row(
        children: [
          const SignUpIconContainer(Icons.scale),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: InputBorder.none,
                errorMaxLines: 2,
              ),
              style: TextStyle(
                fontSize: AppResponsive.font(context, base: 15, min: 13),
                color: AppColors.lightTextPrimary,
              ),
              validator: CreateUserValidators.weight,
            ),
          ),
        ],
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            title: 'Nos fale um pouco do seu atual físico!',
            subtitle:
                'Isso nos ajudará a projetar os melhores treinos para você!',
          ),
          const SizedBox(height: 16),
          SignUpRoundedContainer(
            child: DropdownButtonFormField<Gender>(
              key: ValueKey(gender),
              initialValue: gender,
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Sexo',
                errorMaxLines: 2,
              ),
              items: Gender.values
                  .map(
                    (g) => DropdownMenuItem(
                      value: g,
                      child: Text(
                        g.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onGenderChanged,
              validator: CreateUserValidators.gender,
            ),
          ),
          const SizedBox(height: 12),
          if (stackMetrics) ...[
            heightField,
            const SizedBox(height: 12),
            weightField,
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: heightField),
                const SizedBox(width: 12),
                Expanded(child: weightField),
              ],
            ),
        ],
      ),
    );
  }
}

class _ThirdStepForm extends StatelessWidget {
  const _ThirdStepForm({
    required this.formKey,
    required this.activityLevel,
    required this.onActivityChanged,
  });

  final GlobalKey<FormState> formKey;
  final ActivityLevel? activityLevel;
  final ValueChanged<ActivityLevel?> onActivityChanged;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(
            title: 'Qual o seu nível de atividade física?',
            subtitle: 'Escolha a opção que melhor descreve sua rotina.',
          ),
          const SizedBox(height: 16),
          SignUpRoundedContainer(
            child: DropdownButtonFormField<ActivityLevel>(
              key: ValueKey(activityLevel),
              initialValue: activityLevel,
              isExpanded: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Nível de atividade',
                errorMaxLines: 2,
              ),
              items: ActivityLevel.values
                  .map(
                    (level) => DropdownMenuItem(
                      value: level,
                      child: Text(
                        level.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              selectedItemBuilder: (context) {
                return ActivityLevel.values
                    .map(
                      (level) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          level.label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    )
                    .toList();
              },
              onChanged: onActivityChanged,
              validator: CreateUserValidators.activityLevel,
            ),
          ),
        ],
      ),
    );
  }
}

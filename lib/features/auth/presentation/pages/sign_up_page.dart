import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:atlas_mobile_pi1/core/utils/date_formatters.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/validators/sign_up_validators.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/widgets/auth_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static const _titles = [
    'Vamos começar\nseu cadastro',
    'Nos fale um pouco\ndo seu físico',
    'Qual o seu nível\nde atividade?',
  ];

  static const _subtitles = [
    'Primeiro informe alguns dados básicos.',
    'Isso nos ajuda a projetar os melhores treinos.',
    'Escolha a opção que melhor descreve sua rotina.',
  ];

  static const _stepLabels = ['Dados', 'Físico', 'Atividade'];

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

  void _onContinue() {
    FocusScope.of(context).unfocus();
    final formState = _formKeys[_currentStep].currentState;
    if (formState == null) return;
    if (!formState.validate()) return;

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _completeRegistration();
    }
  }

  void _onBack() {
    FocusScope.of(context).unfocus();
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleSize = AppResponsive.font(context, base: 26, min: 20, max: 28);
    final subtitleSize = AppResponsive.font(context, base: 15, min: 13, max: 16);
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final short = AppResponsive.isShort(context);

    return Scaffold(
      backgroundColor: AppColors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final panelMaxHeight = constraints.maxHeight *
                (keyboardOpen ? 0.88 : (short ? 0.78 : 0.72));

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppResponsive.isCompact(context) ? 16 : 24,
                      short ? 12 : 24,
                      AppResponsive.isCompact(context) ? 16 : 24,
                      12,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _titles[_currentStep],
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: titleSize,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: short ? 8 : 12),
                            Text(
                              _subtitles[_currentStep],
                              style: TextStyle(
                                color: AppColors.darkTextSecondary,
                                fontSize: subtitleSize,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: panelMaxHeight),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: AppRadii.authPanel,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        top: short ? 16 : 24,
                        left: 16,
                        right: 16,
                        bottom: 24 + MediaQuery.paddingOf(context).bottom,
                      ),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StepIndicator(
                            currentStep: _currentStep,
                            labels: _stepLabels,
                          ),
                          const SizedBox(height: 20),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: KeyedSubtree(
                              key: ValueKey(_currentStep),
                              child: _buildStepForm(),
                            ),
                          ),
                          if (_currentStep > 0)
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: _isSaving ? null : _onBack,
                                child: Text(
                                  'Voltar',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: AppResponsive.font(
                                      context,
                                      base: 14,
                                      min: 13,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSaving ? null : _onContinue,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  backgroundColor: AppColors.accent,
                                  disabledBackgroundColor:
                                      AppColors.accent.withValues(alpha: 0.6),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: AppRadii.pill,
                                  ),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.white,
                                        ),
                                      )
                                    : Text(
                                        _currentStep == 2
                                            ? 'Finalizar'
                                            : 'Próximo',
                                        style: TextStyle(
                                          fontSize: AppResponsive.font(
                                            context,
                                            base: 16,
                                            min: 14,
                                          ),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepForm() {
    switch (_currentStep) {
      case 0:
        return _FirstStepForm(
          formKey: _formKeys[0],
          nameController: _nameController,
          birthDateController: _birthDateController,
        );
      case 1:
        return _SecondStepForm(
          formKey: _formKeys[1],
          heightController: _heightController,
          weightController: _weightController,
          gender: _gender,
          onGenderChanged: (value) => setState(() => _gender = value),
        );
      default:
        return _ThirdStepForm(
          formKey: _formKeys[2],
          activityLevel: _activityLevel,
          onActivityChanged: (value) => setState(() => _activityLevel = value),
        );
    }
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.labels,
  });

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(left: 6, right: 6, bottom: 18),
                color: i <= currentStep
                    ? AppColors.accent
                    : AppColors.lightBorder,
              ),
            ),
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i <= currentStep
                      ? AppColors.accent
                      : AppColors.lightBorder,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: AppResponsive.font(context, base: 12, min: 11),
                  fontWeight:
                      i == currentStep ? FontWeight.w700 : FontWeight.w500,
                  color: i <= currentStep
                      ? AppColors.black
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            style: authFieldTextStyle(context),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            decoration: authInputDecoration(
              context,
              hint: 'Seu nome',
              icon: Icons.drive_file_rename_outline,
            ),
            validator: CreateUserValidators.names,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: birthDateController,
            style: authFieldTextStyle(context),
            readOnly: true,
            keyboardType: TextInputType.none,
            decoration: authInputDecoration(
              context,
              hint: 'Data de nascimento',
              icon: Icons.calendar_month,
            ),
            validator: CreateUserValidators.age,
            onTap: () async {
              final now = DateTime.now();
              final pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: now,
                initialDate: DateTime(now.year - 18),
              );

              if (pickedDate != null) {
                birthDateController.text = DateFormatters.formatDate(pickedDate);
              }
            },
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

    final heightField = TextFormField(
      controller: heightController,
      style: authFieldTextStyle(context),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      decoration: authInputDecoration(
        context,
        hint: 'Altura (m)',
        icon: Icons.height_rounded,
      ),
      validator: CreateUserValidators.height,
    );

    final weightField = TextFormField(
      controller: weightController,
      style: authFieldTextStyle(context),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      decoration: authInputDecoration(
        context,
        hint: 'Peso (kg)',
        icon: Icons.scale,
      ),
      validator: CreateUserValidators.weight,
    );

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          DropdownButtonFormField<Gender>(
            key: ValueKey(gender),
            initialValue: gender,
            isExpanded: true,
            style: authFieldTextStyle(context),
            dropdownColor: AppColors.white,
            iconEnabledColor: AppColors.accent,
            decoration: authInputDecoration(
              context,
              hint: 'Sexo',
              icon: Icons.person_outline,
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
          const SizedBox(height: 14),
          if (stackMetrics) ...[
            heightField,
            const SizedBox(height: 14),
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: DropdownButtonFormField<ActivityLevel>(
        key: ValueKey(activityLevel),
        initialValue: activityLevel,
        isExpanded: true,
        style: authFieldTextStyle(context),
        dropdownColor: AppColors.white,
        iconEnabledColor: AppColors.accent,
        decoration: authInputDecoration(
          context,
          hint: 'Nível de atividade',
          icon: Icons.directions_run,
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
    );
  }
}

import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/validators/sign_up_validators.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/widgets/auth_input_decoration.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/widgets/auth_theme.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _loading = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await context.read<AuthService>().sendPasswordReset(
            _emailController.text,
          );
      if (mounted) setState(() => _sent = true);
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthTheme(
      child: Builder(builder: (context) => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = context.l10n;
    final titleSize = AppResponsive.font(context, base: 26, min: 20, max: 28);
    final subtitleSize = AppResponsive.font(context, base: 15, min: 13, max: 16);
    final short = AppResponsive.isShort(context);

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: SafeArea(
        bottom: false,
        child: Column(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.authForgotPasswordTitle,
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: titleSize,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: short ? 8 : 12),
                      Text(
                        l10n.authForgotPasswordSubtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: subtitleSize,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary(context),
                borderRadius: AppRadii.authPanel,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  short ? 16 : 24,
                  16,
                  24 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_sent)
                        Text(
                          l10n.authForgotPasswordSent,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary(context),
                            fontSize: subtitleSize,
                            height: 1.4,
                          ),
                        )
                      else
                        TextFormField(
                          controller: _emailController,
                          style: authFieldTextStyle(context),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          enabled: !_loading,
                          decoration: authInputDecoration(
                            context,
                            hint: l10n.authEmailHint,
                            icon: Icons.email_outlined,
                          ),
                          validator: (value) =>
                              CreateUserValidators.email(value, l10n),
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading
                              ? null
                              : (_sent ? () => context.pop() : _submit),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: AppColors.accentOf(context),
                            disabledBackgroundColor: AppColors.accentOf(context)
                                .withValues(alpha: 0.6),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadii.pill,
                            ),
                          ),
                          child: _loading
                              ? SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.onAccentOf(context),
                                  ),
                                )
                              : Text(
                                  _sent
                                      ? l10n.authForgotPasswordBack
                                      : l10n.authForgotPasswordSend,
                                  style: TextStyle(
                                    fontSize: AppResponsive.font(
                                      context,
                                      base: 16,
                                      min: 14,
                                    ),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onAccentOf(context),
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
        ),
      ),
    );
  }
}

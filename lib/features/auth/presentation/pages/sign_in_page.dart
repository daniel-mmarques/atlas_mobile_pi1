import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/validators/sign_up_validators.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/widgets/auth_input_decoration.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLogin = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  void setFormAction(bool action) {
    setState(() {
      isLogin = action;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(
            _emailController.text,
            _passwordController.text,
          );
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> register() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().register(
            _emailController.text,
            _passwordController.text,
          );

      if (!mounted) return;
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final titleSize = AppResponsive.font(context, base: 26, min: 20, max: 28);
    final subtitleSize = AppResponsive.font(context, base: 15, min: 13, max: 16);
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final short = AppResponsive.isShort(context);
    final buttonLabel = isLogin ? l10n.authLogin : l10n.authRegister;

    return Scaffold(
      backgroundColor: AppColors.surface(context),
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
                              l10n.authSetupTitle,
                              style: TextStyle(
                                color: AppColors.textPrimary(context),
                                fontSize: titleSize,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: short ? 8 : 12),
                            Text(
                              l10n.authSetupSubtitle,
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
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: panelMaxHeight),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary(context),
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
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildToggle(context),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              style: authFieldTextStyle(context),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              enabled: !loading,
                              decoration: authInputDecoration(
                                context,
                                hint: l10n.authEmailHint,
                                icon: Icons.email_outlined,
                              ),
                              validator: (value) =>
                                  CreateUserValidators.email(value, l10n),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              style: authFieldTextStyle(context),
                              obscureText: _obscurePassword,
                              textInputAction: isLogin
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              enabled: !loading,
                              onChanged: (_) {
                                if (!isLogin) {
                                  _formKey.currentState?.validate();
                                }
                              },
                              decoration: authInputDecoration(
                                context,
                                hint: l10n.authPasswordHint,
                                icon: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.textSecondary(context),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) =>
                                  CreateUserValidators.password(value, l10n),
                            ),
                            if (!isLogin) ...[
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _confirmPasswordController,
                                style: authFieldTextStyle(context),
                                obscureText: _obscureConfirmPassword,
                                textInputAction: TextInputAction.done,
                                enabled: !loading,
                                decoration: authInputDecoration(
                                  context,
                                  hint: l10n.authConfirmPasswordHint,
                                  icon: Icons.lock_outline,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.textSecondary(context),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) =>
                                    CreateUserValidators.confirmPassword(
                                  value,
                                  _passwordController.text,
                                  l10n,
                                ),
                              ),
                            ],
                            if (isLogin)
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: loading
                                      ? null
                                      : () {
                                          context.push(
                                            AppRoutes.forgotPassword,
                                            extra: _emailController.text.trim(),
                                          );
                                        },
                                  child: Text(
                                    l10n.authForgotPassword,
                                    style: TextStyle(
                                      color: AppColors.accentOf(context),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: loading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (isLogin) {
                                              login();
                                            } else {
                                              register();
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: AppColors.accentOf(context),
                                    disabledBackgroundColor:
                                        AppColors.accentOf(context).withValues(alpha: 0.6),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: AppRadii.pill,
                                    ),
                                  ),
                                  child: loading
                                      ? SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.onAccentOf(context),
                                          ),
                                        )
                                      : Text(
                                          buttonLabel,
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
                            ),
                            const SizedBox(height: 20),
                            _buildSocialDivider(context),
                            const SizedBox(height: 16),
                            _buildSocialButtons(context),
                          ],
                        ),
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

  Future<void> _socialLogin(
    Future<void> Function() action,
  ) async {
    setState(() => loading = true);
    try {
      await action();
      if (!mounted) return;
      final auth = context.read<AuthService>();
      if (auth.needsProfileSetup) {
        context.go(AppRoutes.signup);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget _buildSocialDivider(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.border(context))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            l10n.authOrContinueWith,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: AppResponsive.font(context, base: 13, min: 12),
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border(context))),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: _SocialAuthButton(
            label: l10n.authGoogle,
            icon: Icons.g_mobiledata_rounded,
            enabled: !loading,
            onPressed: () => _socialLogin(
              () => context.read<AuthService>().loginWithGoogle(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SocialAuthButton(
            label: l10n.authApple,
            icon: Icons.apple,
            enabled: !loading,
            onPressed: () => _socialLogin(
              () => context.read<AuthService>().loginWithApple(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final thumbWidth = (constraints.maxWidth - 12) / 2;

        return Container(
          height: 52,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.component(context),
            borderRadius: AppRadii.pill,
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                alignment:
                    isLogin ? Alignment.centerLeft : Alignment.centerRight,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: Container(
                  width: thumbWidth,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary(context),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimary(context)
                            .withValues(alpha: 0.18),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: loading ? null : () => setFormAction(true),
                      child: Center(
                        child: Text(
                          l10n.authLogin,
                          style: TextStyle(
                            fontSize: AppResponsive.font(
                              context,
                              base: 16,
                              min: 14,
                            ),
                            fontWeight: FontWeight.bold,
                            color: isLogin
                                ? AppColors.surface(context)
                                : AppColors.textSecondary(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: loading ? null : () => setFormAction(false),
                      child: Center(
                        child: Text(
                          l10n.authRegister,
                          style: TextStyle(
                            fontSize: AppResponsive.font(
                              context,
                              base: 16,
                              min: 14,
                            ),
                            fontWeight: FontWeight.bold,
                            color: !isLogin
                                ? AppColors.surface(context)
                                : AppColors.textSecondary(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.enabled,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        foregroundColor: AppColors.textPrimary(context),
        side: BorderSide(color: AppColors.border(context)),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.pill),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppResponsive.font(context, base: 14, min: 13),
            ),
          ),
        ],
      ),
    );
  }
}

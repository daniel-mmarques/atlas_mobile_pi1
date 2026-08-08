import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/validators/sign_up_validators.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String button = 'Login';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  void setFormAction(bool action) {
    setState(() {
      isLogin = action;
      button = isLogin ? 'Login' : 'Sign Up';
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

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
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

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.lightTextSecondary,
        fontSize: AppResponsive.font(context, base: 15, min: 13),
      ),
      prefixIcon: Icon(icon, color: AppColors.accent),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: AppRadii.button,
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadii.button,
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadii.button,
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      errorMaxLines: 2,
    );
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
                              'Go ahead and set up\nyour account',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: titleSize,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: short ? 8 : 12),
                            Text(
                              'Sign in-up to enjoy the best managing experience',
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildToggle(context),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: AppResponsive.font(
                                  context,
                                  base: 15,
                                  min: 14,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enabled: !loading,
                              decoration: _inputDecoration(
                                hint: 'Email',
                                icon: Icons.email_outlined,
                              ),
                              validator: CreateUserValidators.email,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: AppResponsive.font(
                                  context,
                                  base: 15,
                                  min: 14,
                                ),
                              ),
                              obscureText: _obscurePassword,
                              textInputAction: isLogin
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              enabled: !loading,
                              decoration: _inputDecoration(
                                hint: 'Password',
                                icon: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: CreateUserValidators.password,
                            ),
                            if (!isLogin) ...[
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _confirmPasswordController,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: AppResponsive.font(
                                    context,
                                    base: 15,
                                    min: 14,
                                  ),
                                ),
                                obscureText: _obscureConfirmPassword,
                                textInputAction: TextInputAction.done,
                                enabled: !loading,
                                decoration: _inputDecoration(
                                  hint: 'Confirm password',
                                  icon: Icons.lock_outline,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.lightTextSecondary,
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
                                ),
                              ),
                            ],
                            if (isLogin)
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot password?',
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
                                    backgroundColor: AppColors.accent,
                                    disabledBackgroundColor:
                                        AppColors.accent.withValues(alpha: 0.6),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: AppRadii.pill,
                                    ),
                                  ),
                                  child: loading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.white,
                                          ),
                                        )
                                      : Text(
                                          button,
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildToggle(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final thumbWidth = (constraints.maxWidth - 12) / 2;

        return Container(
          height: 52,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.lightComponent,
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
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.lightBorder,
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
                          'Login',
                          style: TextStyle(
                            fontSize: AppResponsive.font(
                              context,
                              base: 16,
                              min: 14,
                            ),
                            fontWeight: FontWeight.bold,
                            color: isLogin
                                ? AppColors.black
                                : AppColors.lightTextSecondary,
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
                          'Register',
                          style: TextStyle(
                            fontSize: AppResponsive.font(
                              context,
                              base: 16,
                              min: 14,
                            ),
                            fontWeight: FontWeight.bold,
                            color: !isLogin
                                ? AppColors.black
                                : AppColors.lightTextSecondary,
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

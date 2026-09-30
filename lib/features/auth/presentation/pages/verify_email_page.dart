import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/widgets/auth_theme.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with WidgetsBindingObserver {
  bool _loading = false;
  DateTime? _lastResendAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<AuthService>().reloadCurrentUser().then(
            (_) {},
            onError: (_, _) {},
          );
    }
  }

  Future<void> _reloadAndCheck() async {
    final l10n = context.l10n;
    setState(() => _loading = true);
    try {
      await context.read<AuthService>().reloadCurrentUser();
      if (!mounted) return;
      if (context.read<AuthService>().needsEmailVerification) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.authVerifyStillPending)),
        );
      }
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

  Future<void> _resend() async {
    final now = DateTime.now();
    if (_lastResendAt != null &&
        now.difference(_lastResendAt!) < const Duration(seconds: 45)) {
      return;
    }

    setState(() => _loading = true);
    try {
      await context.read<AuthService>().sendEmailVerification();
      _lastResendAt = DateTime.now();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.authVerifyResent)),
        );
      }
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
    final auth = context.watch<AuthService>();
    final email = auth.user?.email ?? '';
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
                      Text(
                        l10n.authVerifyTitle,
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: titleSize,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: short ? 8 : 12),
                      Text(
                        l10n.authVerifySubtitle(email),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _reloadAndCheck,
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
                                l10n.authVerifyAlreadyDone,
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
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loading ? null : _resend,
                      child: Text(
                        l10n.authVerifyResend,
                        style: TextStyle(
                          color: AppColors.accentOf(context),
                          fontWeight: FontWeight.bold,
                          fontSize: AppResponsive.font(
                            context,
                            base: 14,
                            min: 13,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => context.read<AuthService>().logout(),
                      child: Text(
                        l10n.authVerifySignOut,
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontWeight: FontWeight.w600,
                          fontSize: AppResponsive.font(
                            context,
                            base: 14,
                            min: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

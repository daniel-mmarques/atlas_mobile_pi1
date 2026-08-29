import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/user_role.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> showSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        minChildSize: 0.95,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return SettingsContent(
            scrollController: scrollController,
            asSheet: true,
          );
        },
      );
    },
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SettingsContent(asSheet: false)),
    );
  }
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({
    super.key,
    this.scrollController,
    this.asSheet = false,
  });

  final ScrollController? scrollController;
  final bool asSheet;

  Future<void> _cycleLanguage(PreferencesService preferences) async {
    final current = preferences.currentLanguage.languageCode;
    final next = switch (current) {
      'pt' => const Locale('en'),
      'en' => const Locale('es'),
      _ => const Locale('pt'),
    };
    await preferences.toggleCurrentLanguage(next);
  }

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesService>();
    final auth = context.watch<AuthService>();
    final languageSubtitle = switch (preferences.currentLanguage.languageCode) {
      'en' => 'English',
      'es' => 'Español',
      _ => 'Português',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (asSheet) ...[
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary(context).withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (asSheet)
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    Icons.arrow_downward_rounded,
                    size: 32,
                    color: AppColors.textPrimary(context),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              SizedBox(height: asSheet ? AppSpacing.xl : AppSpacing.sm),
              Text(
                'Settings',
                style: AppTypography.pageTitle(context).copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'How to track workouts and metrics',
                style: AppTypography.meta(context).copyWith(
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              0,
              AppSpacing.pageHorizontal,
              AppSpacing.xxxl,
            ),
            children: [
              _SettingsRow(
                iconLabel: preferences.isImperialSystem ? 'lb' : 'kg',
                title: 'Preferred unit',
                subtitle: preferences.isImperialSystem
                    ? 'Pounds and miles'
                    : 'Kilos and meters',
                onTap: () => preferences.toggleUnitSystem(),
              ),
              _SettingsRow(
                icon: preferences.isDark
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                title: 'Appearance',
                subtitle: preferences.isDark ? 'Dark' : 'Light',
                onTap: () => preferences.toggleThemeMode(),
              ),
              _SettingsRow(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: languageSubtitle,
                onTap: () => _cycleLanguage(preferences),
              ),
              _SettingsRow(
                icon: Icons.fitness_center_outlined,
                title: 'Modo coach',
                subtitle: auth.isCoach
                    ? 'Ativo — área do coach disponível'
                    : 'Desativado',
                onTap: () async {
                  await auth.setRole(
                    auth.isCoach ? UserRole.student : UserRole.coach,
                  );
                },
              ),
              if (auth.isCoach)
                _SettingsRow(
                  icon: Icons.groups_outlined,
                  title: 'Área do coach',
                  subtitle: 'Alunos e vínculos',
                  onTap: () {
                    if (asSheet) Navigator.of(context).maybePop();
                    context.push(AppRoutes.coach);
                  },
                ),
              _SettingsRow(
                icon: Icons.logout_rounded,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                destructive: true,
                onTap: () async {
                  await Navigator.of(context).maybePop();
                  if (context.mounted) {
                    await context.read<AuthService>().logout();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon,
    this.iconLabel,
    this.destructive = false,
  });

  final IconData? icon;
  final String? iconLabel;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final primary =
        destructive ? AppColors.error : AppColors.textPrimary(context);
    final secondary = destructive
        ? AppColors.error.withValues(alpha: 0.7)
        : AppColors.textSecondary(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.component(context),
                shape: BoxShape.circle,
              ),
              child: iconLabel != null
                  ? Text(
                      iconLabel!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: primary,
                      ),
                    )
                  : Icon(icon, size: 22, color: primary),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: secondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 26,
              color: AppColors.textSecondary(context),
            ),
          ],
        ),
      ),
    );
  }
}

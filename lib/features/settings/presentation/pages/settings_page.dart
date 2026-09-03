import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/user_role.dart';
import 'package:atlas_mobile_pi1/features/settings/presentation/widgets/theme_picker.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/set_intensity_mode.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/preferences_service.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> showSettingsSheet(BuildContext context) {
  return showAtlasSheet<void>(
    context: context,
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: AppSpacing.sheetInitial,
        minChildSize: AppSpacing.sheetMin,
        maxChildSize: AppSpacing.sheetMax,
        shouldCloseOnMinExtent: true,
        builder: (_, scrollController) {
          return SettingsContent(
            scrollController: scrollController,
          );
        },
      );
    },
  );
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;

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
    final l10n = context.l10n;
    final preferences = context.watch<PreferencesService>();
    final auth = context.watch<AuthService>();
    final languageSubtitle = switch (preferences.currentLanguage.languageCode) {
      'en' => l10n.langEnglish,
      'es' => l10n.langSpanish,
      _ => l10n.langPortuguese,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AtlasSheetChrome(
          title: l10n.settingsTitle,
          subtitle: l10n.settingsSubtitle,
          onNav: () => Navigator.of(context).maybePop(),
          isDismiss: true,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Expanded(
          child: ListView(
            controller: scrollController,
          padding: EdgeInsets.fromLTRB(
              AppSpacing.sheetPaddingH,
              0,
              AppSpacing.sheetPaddingH,
              AppSpacing.sheetPaddingB,
            ),
            children: [
              _SettingsRow(
                iconLabel: preferences.isImperialSystem ? 'lb' : 'kg',
                title: l10n.settingsPreferredUnit,
                subtitle: preferences.isImperialSystem
                    ? l10n.settingsUnitImperial
                    : l10n.settingsUnitMetric,
                onTap: () => preferences.toggleUnitSystem(),
              ),
              const SizedBox(height: AppSpacing.md),
              const ThemePicker(),
              const SizedBox(height: AppSpacing.lg),
              _SettingsRow(
                icon: Icons.speed_outlined,
                title: l10n.settingsIntensityTitle,
                subtitle: switch (preferences.setIntensityMode) {
                  SetIntensityMode.none => l10n.settingsIntensitySubtitleNone,
                  SetIntensityMode.rpe => l10n.settingsIntensitySubtitleRpe,
                  SetIntensityMode.rir => l10n.settingsIntensitySubtitleRir,
                },
                onTap: () => preferences.cycleSetIntensityMode(),
              ),
              _SettingsRow(
                icon: Icons.language_outlined,
                title: l10n.settingsLanguage,
                subtitle: languageSubtitle,
                onTap: () => _cycleLanguage(preferences),
              ),
              _SettingsRow(
                icon: Icons.fitness_center_outlined,
                title: l10n.settingsCoachMode,
                subtitle: auth.isCoach
                    ? l10n.settingsCoachActive
                    : l10n.settingsCoachInactive,
                onTap: () async {
                  await auth.setRole(
                    auth.isCoach ? UserRole.student : UserRole.coach,
                  );
                },
              ),
              if (auth.isCoach)
                _SettingsRow(
                  icon: Icons.groups_outlined,
                  title: l10n.settingsCoachArea,
                  subtitle: l10n.settingsCoachAreaSubtitle,
                  onTap: () {
                    Navigator.of(context).maybePop();
                    context.push(AppRoutes.coach);
                  },
                ),
              _SettingsRow(
                icon: Icons.logout_rounded,
                title: l10n.settingsLogout,
                subtitle: l10n.settingsLogoutSubtitle,
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
      borderRadius: AppRadii.md,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md + 2),
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

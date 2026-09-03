import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_theme_id.dart';
import 'package:atlas_mobile_pi1/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Linha de Aparência: toque cicla os temas (igual ao Language).
class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesService>();
    final selected = preferences.appThemeId;
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final l10n = context.l10n;

    return InkWell(
      onTap: () => preferences.cycleAppThemeId(),
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
              child: Icon(selected.icon, size: 22, color: primary),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsAppearance,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selected.localizedLabel(l10n),
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
              color: secondary,
            ),
          ],
        ),
      ),
    );
  }
}

extension AppThemeIdL10n on AppThemeId {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
        AppThemeId.light => l10n.themeLight,
        AppThemeId.sunset => l10n.themeSunset,
        AppThemeId.cyberpunk => l10n.themeCyberpunk,
        AppThemeId.storm => l10n.themeStorm,
        AppThemeId.ocean => l10n.themeOcean,
        AppThemeId.dark => l10n.themeDark,
        AppThemeId.midnight => l10n.themeMidnight,
      };
}

import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_palette.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_theme_id.dart';
import 'package:atlas_mobile_pi1/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Aparência: toque expande um seletor; arraste para os lados para trocar o tema.
class ThemePicker extends StatefulWidget {
  const ThemePicker({super.key});

  @override
  State<ThemePicker> createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePicker> {
  static const _expandDuration = Duration(milliseconds: 220);

  bool _expanded = false;
  PageController? _pageController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pageController ??= PageController(
      initialPage: context.read<PreferencesService>().appThemeId.index,
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      final index = context.read<PreferencesService>().appThemeId.index;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = _pageController;
        if (controller == null || !controller.hasClients) return;
        if (controller.page?.round() != index) {
          controller.jumpToPage(index);
        }
      });
    }
  }

  void _onPageChanged(int index) {
    final id = AppThemeId.values[index];
    final preferences = context.read<PreferencesService>();
    if (preferences.appThemeId == id) return;
    preferences.setAppThemeId(id);
  }

  void _goTo(int index) {
    final controller = _pageController;
    if (controller == null || !controller.hasClients) return;
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesService>();
    final selected = preferences.appThemeId;
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final l10n = context.l10n;
    final controller = _pageController!;
    final index = selected.index;
    final canGoLeft = index > 0;
    final canGoRight = index < AppThemeId.values.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: _toggle,
          borderRadius: AppRadii.md,
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
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: _expandDuration,
                  child: Icon(
                    Icons.expand_more_rounded,
                    size: 26,
                    color: secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: _expandDuration,
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: _expanded
              ? Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        _ThemeArrow(
                          icon: Icons.chevron_left_rounded,
                          visible: canGoLeft,
                          onTap: canGoLeft ? () => _goTo(index - 1) : null,
                        ),
                        Expanded(
                          child: PageView.builder(
                            controller: controller,
                            itemCount: AppThemeId.values.length,
                            onPageChanged: _onPageChanged,
                            itemBuilder: (context, pageIndex) {
                              return Center(
                                child: _ThemeOptionLabel(
                                  id: AppThemeId.values[pageIndex],
                                ),
                              );
                            },
                          ),
                        ),
                        _ThemeArrow(
                          icon: Icons.chevron_right_rounded,
                          visible: canGoRight,
                          onTap: canGoRight ? () => _goTo(index + 1) : null,
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _ThemeArrow extends StatelessWidget {
  const _ThemeArrow({
    required this.icon,
    required this.visible,
    required this.onTap,
  });

  final IconData icon;
  final bool visible;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 44,
      child: visible
          ? IconButton(
              onPressed: onTap,
              padding: EdgeInsets.zero,
              icon: Icon(
                icon,
                size: 28,
                color: AppColors.textSecondary(context),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _ThemeOptionLabel extends StatelessWidget {
  const _ThemeOptionLabel({required this.id});

  final AppThemeId id;

  @override
  Widget build(BuildContext context) {
    final accent = AppPalettes.of(id).accent;
    final label = id.localizedLabel(context.l10n);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(id.icon, size: 22, color: accent),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

extension AppThemeIdL10n on AppThemeId {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
        AppThemeId.light => l10n.themeLight,
        AppThemeId.arctic => l10n.themeArctic,
        AppThemeId.sakura => l10n.themeSakura,
        AppThemeId.sunset => l10n.themeSunset,
        AppThemeId.coffee => l10n.themeCoffee,
        AppThemeId.ocean => l10n.themeOcean,
        AppThemeId.storm => l10n.themeStorm,
        AppThemeId.cyberpunk => l10n.themeCyberpunk,
        AppThemeId.dark => l10n.themeDark,
        AppThemeId.midnight => l10n.themeMidnight,
      };
}

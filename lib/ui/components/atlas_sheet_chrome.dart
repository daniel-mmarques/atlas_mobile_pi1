import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Handle padrão das bottom sheets Atlas.
class AtlasSheetHandle extends StatelessWidget {
  const AtlasSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppSpacing.sheetHandleWidth,
        height: AppSpacing.sheetHandleHeight,
        margin: const EdgeInsets.only(top: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.border(context).withValues(alpha: 0.7),
          borderRadius: AppRadii.pill,
        ),
      ),
    );
  }
}

/// Ícone de navegação da sheet (↓ fechar / ← voltar), alinhado à direita.
class AtlasSheetNavIcon extends StatelessWidget {
  const AtlasSheetNavIcon({
    super.key,
    required this.onPressed,
    this.isDismiss = true,
  });

  final VoidCallback onPressed;
  final bool isDismiss;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.minTouch,
      height: AppSpacing.minTouch,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: AppSpacing.minTouch,
          minHeight: AppSpacing.minTouch,
        ),
        icon: Icon(
          isDismiss
              ? Icons.arrow_downward_rounded
              : Icons.arrow_back_rounded,
          size: AppSpacing.iconBack,
          color: AppColors.textPrimary(context),
        ),
      ),
    );
  }
}

/// Cabeçalho: handle + título com seta à direita (+ subtítulo / actions abaixo).
class AtlasSheetChrome extends StatelessWidget {
  const AtlasSheetChrome({
    super.key,
    required this.title,
    this.subtitle,
    this.onNav,
    this.isDismiss = true,
    this.actions = const [],
    this.showHandle = true,
  });

  final String title;
  final String? subtitle;

  /// Fecha (↓) ou volta (←), sempre à direita do título.
  final VoidCallback? onNav;
  final bool isDismiss;

  /// Botões auxiliares — renderizados **abaixo** do título/subtítulo.
  final List<Widget> actions;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHandle) const AtlasSheetHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.sectionGap,
            AppSpacing.sheetPaddingH,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (onNav != null && !isDismiss) ...[
                    AtlasSheetNavIcon(
                      onPressed: onNav!,
                      isDismiss: isDismiss,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.sheetTitle(context),
                    ),
                  ),
                  if (onNav != null && isDismiss) ...[
                    const SizedBox(width: AppSpacing.sm),
                    AtlasSheetNavIcon(
                      onPressed: onNav!,
                      isDismiss: isDismiss,
                    ),
                  ],
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle!,
                  style: AppTypography.meta(context).copyWith(fontSize: 15),
                ),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: AppSpacing.sm),
                      actions[i],
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

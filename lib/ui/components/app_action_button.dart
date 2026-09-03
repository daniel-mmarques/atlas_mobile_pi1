import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AppActionButton extends StatelessWidget {
  const AppActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.foregroundColor,
    this.height = AppSpacing.buttonHeight,
    this.borderRadius = AppRadii.button,
    this.bold = false,
    this.stacked = false,
    this.emphasized = false,
    this.alignStart = false,
  });

  /// CTA de sheet (altura maior, radius alinhado à sheet).
  const AppActionButton.sheet({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.foregroundColor,
    this.bold = true,
    this.stacked = false,
    this.emphasized = true,
    this.alignStart = false,
  })  : height = AppSpacing.buttonHeightLg,
        borderRadius = AppRadii.sheetButton;

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? color;
  final Color? foregroundColor;
  final double height;
  final BorderRadius borderRadius;
  final bool bold;
  final bool stacked;

  /// Fundo invertido para CTA em destaque.
  final bool emphasized;

  /// Ícone + texto alinhados à esquerda (com padding).
  final bool alignStart;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final Color bg;
    final Color fg;

    if (isDisabled) {
      bg = color ?? AppColors.disabledBackground(context);
      fg = foregroundColor ?? AppColors.disabledForeground(context);
    } else if (emphasized) {
      bg = AppColors.textPrimary(context);
      fg = AppColors.surface(context);
    } else if (color != null) {
      bg = color!;
      fg = foregroundColor ?? AppColors.onAccentOf(context);
    } else {
      bg = AppColors.component(context);
      fg = foregroundColor ?? AppColors.textPrimary(context);
    }

    final labelStyle = TextStyle(
      color: fg,
      fontWeight: bold || emphasized ? FontWeight.w600 : FontWeight.w500,
      fontSize: 16,
      letterSpacing: -0.2,
    );

    return Material(
      color: bg,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: stacked
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(icon, color: fg, size: AppSpacing.iconMd),
                    if (icon != null) const SizedBox(height: AppSpacing.xs),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: labelStyle,
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: alignStart ? AppSpacing.lg : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: alignStart
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: fg, size: AppSpacing.iconMd),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          style: labelStyle,
                          textAlign:
                              alignStart ? TextAlign.start : TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

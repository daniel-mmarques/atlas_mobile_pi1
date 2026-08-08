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
    this.height = 48,
    this.borderRadius = AppRadii.button,
    this.bold = false,
    this.stacked = false,
    this.emphasized = false,
  });

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg;
    final Color fg;

    if (emphasized) {
      bg = isDark ? AppColors.white : AppColors.darkSurface;
      fg = isDark ? AppColors.darkSurface : AppColors.white;
    } else if (color != null) {
      bg = color!;
      fg = foregroundColor ?? AppColors.white;
    } else {
      bg = AppColors.component(context);
      fg = foregroundColor ?? AppColors.textPrimary(context);
    }

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
                    if (icon != null) Icon(icon, color: fg, size: 20),
                    if (icon != null) const SizedBox(height: AppSpacing.xs),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: fg,
                        fontWeight: bold || emphasized
                            ? FontWeight.w600
                            : FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: fg, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: fg,
                        fontWeight: bold || emphasized
                            ? FontWeight.w600
                            : FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

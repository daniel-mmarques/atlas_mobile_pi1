import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Botão de ícone circular.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 42,
    this.iconSize = 24,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.component(context);
    final fg = foregroundColor ?? AppColors.textPrimary(context);

    final button = SizedBox(
      width: size,
      height: size,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, size: iconSize, color: fg),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// Alias de [AppIconButton].
class PlatinumIconButton extends StatelessWidget {
  const PlatinumIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(icon: icon, onPressed: onPressed, iconSize: 26);
  }
}

import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.onTap,
    this.onLongPress,
    this.color,
    this.borderRadius = AppRadii.card,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );

    if (onTap == null && onLongPress == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: card,
      ),
    );
  }
}

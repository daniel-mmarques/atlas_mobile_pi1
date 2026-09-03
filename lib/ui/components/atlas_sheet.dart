import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_motion.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_theme_id.dart';
import 'package:atlas_mobile_pi1/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Opens a bottom sheet with consistent radius, duration and curve.
///
/// Background follows the **current** theme (not the color at open time), so
/// switching light↔dark while the sheet is open stays consistent.
Future<T?> showAtlasSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool useRootNavigator = true,
  bool useSafeArea = true,
  Color? backgroundColor,
  double? elevation,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    isDismissible: true,
    enableDrag: true,
    // Transparent so [AtlasThemedSheet] can paint from the live theme.
    backgroundColor: Colors.transparent,
    elevation: elevation ?? 0,
    shape: const RoundedRectangleBorder(borderRadius: AppRadii.sheet),
    sheetAnimationStyle: const AnimationStyle(
      duration: AppMotion.sheet,
      reverseDuration: AppMotion.content,
      curve: AppMotion.sheetCurve,
      reverseCurve: Curves.easeInCubic,
    ),
    builder: (sheetContext) {
      return AtlasThemedSheet(
        backgroundColor: backgroundColor,
        child: builder(sheetContext),
      );
    },
  );
}

/// Sheet chrome that rebuilds when [PreferencesService.appThemeId] changes.
class AtlasThemedSheet extends StatelessWidget {
  const AtlasThemedSheet({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    // Force rebuild on theme id change even if Theme inheritance is delayed
    // on the overlay route during light↔dark switches.
    context.select<PreferencesService, AppThemeId>((p) => p.appThemeId);

    final color = backgroundColor ?? AppColors.surface(context);

    return Material(
      color: color,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.sheet),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// Lightweight fade+slide wrapper for swapping sheet body content.
class AtlasSheetContentTransition extends StatelessWidget {
  const AtlasSheetContentTransition({
    super.key,
    required this.child,
    this.duration = AppMotion.content,
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: AppMotion.contentCurve,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final offset = Tween<Offset>(
          begin: const Offset(0.04, 0),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offset, child: child),
        );
      },
      child: child,
    );
  }
}

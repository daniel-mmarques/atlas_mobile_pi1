import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/set_type.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';

class SetTypeStyle {
  const SetTypeStyle({
    required this.label,
    required this.color,
    required this.title,
    this.icon,
  });

  final String label;
  final Color color;
  final String title;
  final IconData? icon;

  static SetTypeStyle of(
    SetType type,
    int workIndex, {
    required String Function(SetType) titleOf,
  }) {
    switch (type) {
      case SetType.warmUp:
        return SetTypeStyle(
          label: 'W',
          icon: Icons.local_fire_department_rounded,
          color: const Color(0xFFFF8A00),
          title: titleOf(type),
        );
      case SetType.drop:
        return SetTypeStyle(
          label: 'D',
          icon: Icons.south_east_rounded,
          color: const Color(0xFF42A5F5),
          title: titleOf(type),
        );
      case SetType.backoff:
        return SetTypeStyle(
          label: 'B',
          icon: Icons.trending_down_rounded,
          color: const Color(0xFF66BB6A),
          title: titleOf(type),
        );
      case SetType.failure:
        return SetTypeStyle(
          label: 'F',
          icon: Icons.bolt_rounded,
          color: const Color(0xFFEF5350),
          title: titleOf(type),
        );
      case SetType.work:
        return SetTypeStyle(
          label: '$workIndex',
          color: const Color(0xFFB0B3B8),
          title: titleOf(type),
        );
    }
  }
}

class SetTypeBadge extends StatelessWidget {
  const SetTypeBadge({
    super.key,
    required this.type,
    required this.workIndex,
    this.onTap,
    this.compact = false,
    this.size,
    this.outlined = false,
  });

  final SetType type;
  final int workIndex;
  final VoidCallback? onTap;
  final bool compact;
  final double? size;

  /// Contorno colorido + ícone/número (estilo da tela de detalhe).
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final style = SetTypeStyle.of(
      type,
      workIndex,
      titleOf: (_) => '',
    );
    final side = size ?? (compact ? 28.0 : 32.0);
    final primary = AppColors.textPrimary(context);
    final isWork = type == SetType.work;
    final accent = isWork ? primary : style.color;

    final child = isWork
        ? Text(
            style.label,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w800,
              fontSize: side > 36 ? 17 : 13,
            ),
          )
        : Icon(
            style.icon,
            size: side * 0.42,
            color: accent,
          );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: side,
        height: side,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: style.color.withValues(alpha: outlined ? 0.14 : 0.18),
          borderRadius: BorderRadius.circular(outlined || side > 36 ? 12 : 8),
          border: Border.all(
            color: isWork
                ? (outlined
                    ? AppColors.border(context).withValues(alpha: 0.9)
                    : AppColors.border(context))
                : style.color,
            width: outlined ? 1.4 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

Future<SetType?> showSetTypePicker(
  BuildContext context, {
  required SetType current,
  required String Function(SetType) titleOf,
  required String sheetTitle,
}) {
  return showAtlasSheet<SetType>(
    context: context,
    isScrollControlled: false,
    builder: (context) {
      final options = <(SetType, int)>[
        (SetType.work, 1),
        (SetType.warmUp, 0),
        (SetType.drop, 0),
        (SetType.backoff, 0),
        (SetType.failure, 0),
      ];
      final primary = AppColors.textPrimary(context);

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            0,
            AppSpacing.sheetPaddingH,
            AppSpacing.sheetPaddingB,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AtlasSheetChrome(
                title: sheetTitle,
                showHandle: true,
                onNav: () => Navigator.of(context).maybePop(),
                isDismiss: true,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final (type, workIndex) in options)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SetTypeBadge(
                    type: type,
                    workIndex: workIndex,
                    outlined: true,
                    size: 40,
                  ),
                  title: Text(
                    titleOf(type),
                    style: TextStyle(color: primary),
                  ),
                  trailing: type == current
                      ? Icon(Icons.check, color: primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(type),
                ),
            ],
          ),
        ),
      );
    },
  );
}

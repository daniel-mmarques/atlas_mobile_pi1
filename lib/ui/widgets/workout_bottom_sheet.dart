import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class WorkoutBottomSheet extends StatelessWidget {
  const WorkoutBottomSheet({
    super.key,
    required this.workoutName,
    this.onDelete,
    this.onEdit,
    this.onDuplicate,
    this.onShare,
  });

  final String workoutName;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sheetPaddingH,
        0,
        AppSpacing.sheetPaddingH,
        AppSpacing.sheetPaddingB,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AtlasSheetHandle(),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            workoutName,
            style: AppTypography.sheetTitle(context).copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleAction(
                context,
                icon: Icons.copy_rounded,
                label: l10n.profileDuplicate,
                onTap: onDuplicate,
              ),
              _circleAction(
                context,
                icon: Icons.edit_outlined,
                label: l10n.edit,
                onTap: onEdit,
              ),
              _circleAction(
                context,
                icon: Icons.ios_share_rounded,
                label: l10n.share,
                onTap: onShare,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          SlideAction(
            outerColor: const Color(0xFF8E0000),
            innerColor: const Color(0xFFB71C1C),
            sliderRotate: false,
            elevation: 0,
            text: l10n.swipeToDelete,
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onError,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            sliderButtonIcon: Icon(
              Icons.delete_outline_rounded,
              color: Theme.of(context).colorScheme.onError,
            ),
            onSubmit: () {
              onDelete?.call();
              return null;
            },
          ),
        ],
      ),
    );
  }

  static Widget _circleAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          borderRadius: AppRadii.pill,
          onTap: onTap,
          child: Container(
            height: AppSpacing.minTouch + AppSpacing.xxl,
            width: AppSpacing.minTouch + AppSpacing.xxl,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.component(context),
            ),
            child: Icon(icon, size: AppSpacing.iconLg - 2),
          ),
        ),
        const SizedBox(height: AppSpacing.sm - 2),
        Text(
          label,
          style: AppTypography.meta(context).copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }
}

Future<void> showWorkoutBottomSheet(
  BuildContext context, {
  required String workoutName,
  VoidCallback? onDelete,
  VoidCallback? onEdit,
  VoidCallback? onDuplicate,
  VoidCallback? onShare,
}) {
  return showAtlasSheet<void>(
    context: context,
    builder: (_) => WorkoutBottomSheet(
      workoutName: workoutName,
      onDelete: onDelete,
      onEdit: onEdit,
      onDuplicate: onDuplicate,
      onShare: onShare,
    ),
  );
}

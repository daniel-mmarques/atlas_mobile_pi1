import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/show_create_routine_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';

Future<void> showAddSheet(BuildContext context) {
  return showAtlasSheet<void>(
    context: context,
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: AppSpacing.sheetInitial,
        minChildSize: AppSpacing.sheetMin,
        maxChildSize: AppSpacing.sheetMax,
        shouldCloseOnMinExtent: true,
        builder: (_, scrollController) {
          return AddSheet(scrollController: scrollController);
        },
      );
    },
  );
}

class AddSheet extends StatelessWidget {
  const AddSheet({super.key, this.scrollController});

  final ScrollController? scrollController;

  Future<void> _createRoutine(BuildContext context) async {
    Navigator.of(context).pop();
    await showCreateRoutineSheet(context);
  }

  void _comingSoon(BuildContext context, String label) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.addSheetComingSoon(label))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        0,
        0,
        0,
        AppSpacing.sheetPaddingB,
      ),
      children: [
        AtlasSheetChrome(
          title: l10n.addTitle,
          subtitle: l10n.addSubtitle,
          onNav: () => Navigator.of(context).pop(),
          isDismiss: true,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sheetPaddingH,
          ),
          child: Column(
            children: [
              _AddOption(
                icon: Icons.add_rounded,
                title: l10n.addSheetWorkout,
                subtitle: l10n.addSheetWorkoutSubtitle,
                actionLabel: l10n.addActionCreate,
                onAction: () => _createRoutine(context),
              ),
              const SizedBox(height: AppSpacing.sectionGap + AppSpacing.sm),
              _AddOption(
                icon: Icons.auto_awesome_rounded,
                title: l10n.addSheetRoutine,
                subtitle: l10n.addSheetRoutineSubtitle,
                actionLabel: l10n.addActionGet,
                onAction: () => _comingSoon(context, l10n.addSheetRoutine),
              ),
              const SizedBox(height: AppSpacing.sectionGap + AppSpacing.sm),
              _AddOption(
                icon: Icons.open_in_full_rounded,
                title: l10n.addSheetMetrics,
                subtitle: l10n.addSheetMetricsSubtitle,
                actionLabel: l10n.addActionAdd,
                onAction: () => _comingSoon(context, l10n.addSheetMetrics),
              ),
              const SizedBox(height: AppSpacing.sectionGap + AppSpacing.sm),
              _AddOption(
                icon: Icons.folder_outlined,
                title: l10n.addSheetFolder,
                subtitle: l10n.addSheetFolderSubtitle,
                actionLabel: l10n.addActionAdd,
                onAction: () => _comingSoon(context, l10n.addSheetFolder),
              ),
              SizedBox(
                height: MediaQuery.paddingOf(context).bottom > 0
                    ? AppSpacing.sm
                    : AppSpacing.md,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddOption extends StatelessWidget {
  const _AddOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final chipColor = AppColors.component(context);

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: chipColor, shape: BoxShape.circle),
          child: Icon(icon, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: chipColor,
          borderRadius: AppRadii.pill,
          child: InkWell(
            onTap: onAction,
            borderRadius: AppRadii.pill,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

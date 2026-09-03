import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/create_routine_controller.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/exercise_library_sheet.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RoutineBuilderStep extends StatelessWidget {
  const RoutineBuilderStep({
    super.key,
    required this.onClosed,
    this.showHeader = true,
  });

  final VoidCallback onClosed;
  final bool showHeader;

  static String formatRest(Duration rest) {
    final minutes = rest.inMinutes;
    final seconds = rest.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _openLibrary(BuildContext context) async {
    final controller = context.read<CreateRoutineController>();
    final selected = await showSeedExercisePicker(context);
    if (selected == null || !context.mounted) return;
    controller.addExercises(selected);
  }

  Future<void> _saveOnly(BuildContext context) async {
    final controller = context.read<CreateRoutineController>();
    final l10n = context.l10n;
    final template = await controller.save();
    if (!context.mounted) return;
    if (template == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routineNameRequired)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.routineSaved)),
    );
    onClosed();
  }

  Future<void> _start(BuildContext context) async {
    final controller = context.read<CreateRoutineController>();
    final l10n = context.l10n;
    if (!controller.canStart) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routineNameRequired)),
      );
      return;
    }
    final template = await controller.save();
    if (!context.mounted || template == null) return;

    final workoutService = context.read<WorkoutService>();
    final workout = await workoutService.createWorkoutFromTemplate(template);
    if (!context.mounted) return;
    onClosed();
    context.push(AppRoutes.workoutSession(workout.id), extra: workout);
  }

  Future<void> _editName(BuildContext context) async {
    final controller = context.read<CreateRoutineController>();
    final l10n = context.l10n;
    final primary = AppColors.textPrimary(context);
    final textController = TextEditingController(text: controller.name);

    final next = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routineEditName),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: TextStyle(color: primary),
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.routineNameTitle),
          onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(textController.text.trim()),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    textController.dispose();

    if (next == null || !context.mounted) return;
    if (next.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routineNameRequired)),
      );
      return;
    }
    controller.updateName(next);
    await controller.save();
  }

  Future<void> _delete(BuildContext context) async {
    final controller = context.read<CreateRoutineController>();
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routineDeleteConfirmTitle),
        content: Text(l10n.routineDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await controller.deleteRoutine();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.routineDeleted)),
    );
    onClosed();
  }

  Future<void> _openPreferences(BuildContext context) async {
    final controller = context.read<CreateRoutineController>();
    final l10n = context.l10n;
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);

    await showAtlasSheet<void>(
      context: context,
      isScrollControlled: false,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sheetPaddingB),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AtlasSheetChrome(
                  title: l10n.routinePreferencesTitle,
                  onNav: () => Navigator.of(sheetContext).maybePop(),
                  isDismiss: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sheetPaddingH,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.timer_outlined, color: primary),
                        title: Text(l10n.routineDefaultRestTitle),
                        subtitle: Text(
                          formatRest(controller.defaultRest),
                          style: TextStyle(color: secondary),
                        ),
                        trailing: Icon(Icons.chevron_right, color: secondary),
                        onTap: () async {
                          Navigator.of(sheetContext).pop();
                          await _pickDefaultRest(context);
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.edit_outlined, color: primary),
                        title: Text(l10n.routineEditName),
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          _editName(context);
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading:
                            Icon(Icons.calendar_today_outlined, color: primary),
                        title: Text(l10n.routineEditSchedule),
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          controller.goToScheduleEdit();
                        },
                      ),
                      if (controller.openedAsDetail)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          title: Text(
                            l10n.delete,
                            style: const TextStyle(color: AppColors.error),
                          ),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            _delete(context);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDefaultRest(BuildContext context) async {
    final controller = context.read<CreateRoutineController>();
    final l10n = context.l10n;
    const options = <Duration>[
      Duration(seconds: 30),
      Duration(seconds: 45),
      Duration(seconds: 60),
      Duration(seconds: 90),
      Duration(seconds: 120),
      Duration(seconds: 150),
      Duration(seconds: 180),
      Duration(seconds: 240),
      Duration(seconds: 300),
    ];

    final selected = await showAtlasSheet<Duration>(
      context: context,
      isScrollControlled: false,
      builder: (sheetContext) {
        final primary = AppColors.textPrimary(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AtlasSheetChrome(
                title: l10n.routineDefaultRestTitle,
                onNav: () => Navigator.of(sheetContext).maybePop(),
                isDismiss: true,
              ),
              for (final option in options)
                ListTile(
                  title: Text(formatRest(option)),
                  trailing: option == controller.defaultRest
                      ? Icon(Icons.check, color: primary)
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(option),
                ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );

    if (selected == null || !context.mounted) return;
    controller.setDefaultRest(selected);
  }

  Future<void> _persistAndClose(BuildContext context) async {
    final controller = context.read<CreateRoutineController>();
    final shouldPersist = controller.name.trim().isNotEmpty &&
        (controller.exercises.isNotEmpty || controller.openedAsDetail);
    if (shouldPersist) {
      await controller.save();
    }
    if (context.mounted) onClosed();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateRoutineController>();
    final l10n = context.l10n;
    final secondary = AppColors.textSecondary(context);
    const contentBottomPadding = AppSpacing.sheetPaddingB + AppSpacing.lg;
    const actionsBottomPadding = AppSpacing.sheetPaddingB;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _persistAndClose(context);
      },
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeader)
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
                    Expanded(
                      child: Text(
                        controller.name.trim().isEmpty
                            ? l10n.routine
                            : controller.name,
                        style: AppTypography.sheetTitle(context),
                      ),
                    ),
                    AppIconButton(
                      icon: Icons.tune_rounded,
                      onPressed: () => _openPreferences(context),
                      iconSize: AppSpacing.iconMd,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    AtlasSheetNavIcon(
                      onPressed: () => _persistAndClose(context),
                      isDismiss: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  controller.exercises.isEmpty
                      ? l10n.routineBuilderEmptyHint
                      : (controller.selectedPreset ?? l10n.routineCustomWorkout),
                  style: TextStyle(color: secondary, fontSize: 15, height: 1.35),
                ),
              ],
            ),
          ),
        if (!showHeader)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sheetPaddingH,
              AppSpacing.sectionGap,
              AppSpacing.sheetPaddingH,
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppIconButton(
                  icon: Icons.tune_rounded,
                  onPressed: () => _openPreferences(context),
                  iconSize: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.xs),
                AtlasSheetNavIcon(
                  onPressed: () => _persistAndClose(context),
                  isDismiss: true,
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.sectionGap + AppSpacing.sm),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.sheetPaddingH,
              0,
              AppSpacing.sheetPaddingH,
              contentBottomPadding,
            ),
            children: [
              for (var i = 0; i < controller.exercises.length; i++)
                _ExerciseTile(
                  key: ValueKey(
                    '${controller.exercises[i].id}_$i',
                  ),
                  index: i,
                ),
              _AddExercisesRow(onTap: () => _openLibrary(context)),
              const Divider(height: 36),
              _WorkoutNotesField(
                initialValue: controller.notes,
                onChanged: controller.updateNotes,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.sm,
            AppSpacing.sheetPaddingH,
            actionsBottomPadding,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppActionButton(
                  label: l10n.routineStart,
                  icon: Icons.play_arrow_rounded,
                  bold: true,
                  height: AppSpacing.buttonHeightLg,
                  borderRadius: AppRadii.sheetButton,
                  onTap: (!controller.saving && controller.canStart)
                      ? () => _start(context)
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppActionButton(
                  label: controller.saving ? '…' : l10n.save,
                  icon: Icons.save_outlined,
                  bold: true,
                  emphasized: true,
                  height: AppSpacing.buttonHeightLg,
                  borderRadius: AppRadii.sheetButton,
                  onTap: controller.saving ? null : () => _saveOnly(context),
                ),
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }
}

class _WorkoutNotesField extends StatefulWidget {
  const _WorkoutNotesField({
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<_WorkoutNotesField> createState() => _WorkoutNotesFieldState();
}

class _WorkoutNotesFieldState extends State<_WorkoutNotesField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    return TextField(
      controller: _controller,
      style: TextStyle(color: primary, fontSize: 16),
      maxLines: 3,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: context.l10n.addNotesHint,
        hintStyle: TextStyle(color: secondary, fontSize: 16),
        filled: false,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      ),
    );
  }
}

class _AddExercisesRow extends StatelessWidget {
  const _AddExercisesRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border(context), width: 1.5),
        ),
        child: Icon(Icons.add, color: primary, size: 22),
      ),
      title: Text(
        context.l10n.routineAddExercises,
        style: TextStyle(
          color: primary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: secondary, size: 28),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateRoutineController>();
    final exercise = controller.exercises[index];
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final l10n = context.l10n;
    final restLabel = l10n.routineRestTimerLabel(
      RoutineBuilderStep.formatRest(exercise.rest),
    );

    return Dismissible(
      key: ValueKey('dismiss_${exercise.id}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      onDismissed: (_) => controller.removeExercise(index),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        onTap: () => controller.openExercise(index),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border(context), width: 1.5),
          ),
          child: Icon(Icons.check_rounded, color: primary, size: 22),
        ),
        title: Text(
          exercise.name,
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(Icons.timer_outlined, size: 16, color: secondary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  restLabel,
                  style: TextStyle(color: secondary, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: secondary, size: 28),
      ),
    );
  }
}

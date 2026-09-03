import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/create_routine_controller.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/steps/routine_builder_step.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/routine_set_list.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Página de detalhe de um exercício da rotina (séries + nota).
class RoutineExercisePage extends StatelessWidget {
  const RoutineExercisePage({
    super.key,
    required this.exerciseIndex,
  });

  final int exerciseIndex;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateRoutineController>();
    if (exerciseIndex < 0 || exerciseIndex >= controller.exercises.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.closeExercise();
      });
      return const SizedBox.shrink();
    }

    final exercise = controller.exercises[exerciseIndex];
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sheetPaddingH,
          ),
          child: Row(
            children: [
              AtlasSheetNavIcon(
                onPressed: controller.closeExercise,
                isDismiss: false,
              ),
              const Spacer(),
              AppIconButton(
                icon: Icons.info_outline_rounded,
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(exercise.name),
                      content: Text(
                        l10n.routineRestTimerLabel(
                          RoutineBuilderStep.formatRest(exercise.rest),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.cancel),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.sm,
            AppSpacing.sheetPaddingH,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: AppTypography.sheetTitle(context),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.routineExerciseSetsHint,
                style: AppTypography.meta(context).copyWith(fontSize: 14),
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
              AppSpacing.sheetPaddingB,
            ),
            children: [
              RoutineSetList(
                sets: exercise.sets,
                detailStyle: true,
                onTypeChanged: (setIndex, type) async {
                  controller.updateSetType(exerciseIndex, setIndex, type);
                },
                onWeightChanged: (setIndex, value) =>
                    controller.updateWeight(exerciseIndex, setIndex, value),
                onRepsChanged: (setIndex, value) =>
                    controller.updateReps(exerciseIndex, setIndex, value),
                onIntensityChanged: (setIndex, value) =>
                    controller.updateIntensity(exerciseIndex, setIndex, value),
                onRemoveSet: (setIndex) =>
                    controller.removeSet(exerciseIndex, setIndex),
                onAddSet: () => controller.addSet(exerciseIndex),
                onReorder: (oldIndex, newIndex) =>
                    controller.reorderSets(exerciseIndex, oldIndex, newIndex),
              ),
              const Divider(height: 36),
              _ExerciseDetailNotesField(
                key: ValueKey('exercise_note_${exercise.id}'),
                initialValue: exercise.note,
                onChanged: (value) =>
                    controller.updateExerciseNote(exerciseIndex, value),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExerciseDetailNotesField extends StatefulWidget {
  const _ExerciseDetailNotesField({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<_ExerciseDetailNotesField> createState() =>
      _ExerciseDetailNotesFieldState();
}

class _ExerciseDetailNotesFieldState extends State<_ExerciseDetailNotesField> {
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
      maxLines: 4,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: context.l10n.routineExerciseNoteHint,
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

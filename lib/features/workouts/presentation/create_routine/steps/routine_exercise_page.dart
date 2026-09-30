import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/exercises_catalog_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/catalog_exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/create_routine_controller.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/steps/routine_builder_step.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/exercise_media_preview.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/routine_set_list.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineExercisePage extends StatefulWidget {
  const RoutineExercisePage({
    super.key,
    required this.exerciseIndex,
  });

  final int exerciseIndex;

  @override
  State<RoutineExercisePage> createState() => _RoutineExercisePageState();
}

class _RoutineExercisePageState extends State<RoutineExercisePage> {
  CatalogExercise? _catalog;
  bool _loadingCatalog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCatalog());
  }

  Future<void> _loadCatalog() async {
    final controller = context.read<CreateRoutineController>();
    if (widget.exerciseIndex < 0 ||
        widget.exerciseIndex >= controller.exercises.length) {
      return;
    }
    final exercise = controller.exercises[widget.exerciseIndex];
    setState(() => _loadingCatalog = true);
    try {
      final detail = await context
          .read<ExercisesCatalogRepository>()
          .getById(exercise.id);
      if (!mounted) return;
      setState(() {
        _catalog = detail;
        _loadingCatalog = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCatalog = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateRoutineController>();
    if (widget.exerciseIndex < 0 ||
        widget.exerciseIndex >= controller.exercises.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.closeExercise();
      });
      return const SizedBox.shrink();
    }

    final exercise = controller.exercises[widget.exerciseIndex];
    final l10n = context.l10n;
    final videoUrl = (_catalog?.videoUrl.isNotEmpty ?? false)
        ? _catalog!.videoUrl
        : exercise.videoUrl;
    final imageUrl = (_catalog?.imageUrl.isNotEmpty ?? false)
        ? _catalog!.imageUrl
        : exercise.imageUrl;
    final targets = _catalog?.targetMuscles.isNotEmpty == true
        ? _catalog!.targetMuscles
        : [
            if (exercise.target.isNotEmpty) exercise.target,
          ];
    final secondary = _catalog?.secondaryMuscles ?? const <String>[];
    final instructions = _catalog?.instructions ?? const <String>[];

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
                    builder: (dialogContext) => AlertDialog(
                      title: Text(exercise.name),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.routineRestTimerLabel(
                                  RoutineBuilderStep.formatRest(exercise.rest),
                                ),
                                style: AppTypography.meta(dialogContext),
                              ),
                              if (targets.isNotEmpty ||
                                  secondary.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Muscles',
                                  style: AppTypography.meta(dialogContext)
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final m in targets)
                                      Chip(
                                        label: Text(m),
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor:
                                            AppColors.component(dialogContext),
                                      ),
                                    for (final m in secondary)
                                      Chip(
                                        label: Text(m),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                  ],
                                ),
                              ],
                              if (instructions.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Instructions',
                                  style: AppTypography.meta(dialogContext)
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                for (var i = 0; i < instructions.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text('${i + 1}. ${instructions[i]}'),
                                  ),
                              ],
                              if (_loadingCatalog &&
                                  targets.isEmpty &&
                                  instructions.isEmpty) ...[
                                const SizedBox(height: AppSpacing.md),
                                const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
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
              ExerciseMediaPreview(
                videoUrl: videoUrl,
                imageUrl: imageUrl,
                loading: _loadingCatalog,
              ),
              const SizedBox(height: AppSpacing.md),
              RoutineSetList(
                sets: exercise.sets,
                detailStyle: true,
                onTypeChanged: (setIndex, type) async {
                  controller.updateSetType(widget.exerciseIndex, setIndex, type);
                },
                onWeightChanged: (setIndex, value) => controller.updateWeight(
                  widget.exerciseIndex,
                  setIndex,
                  value,
                ),
                onRepsChanged: (setIndex, value) => controller.updateReps(
                  widget.exerciseIndex,
                  setIndex,
                  value,
                ),
                onIntensityChanged: (setIndex, value) =>
                    controller.updateIntensity(
                  widget.exerciseIndex,
                  setIndex,
                  value,
                ),
                onRemoveSet: (setIndex) =>
                    controller.removeSet(widget.exerciseIndex, setIndex),
                onAddSet: () => controller.addSet(widget.exerciseIndex),
                onReorder: (oldIndex, newIndex) => controller.reorderSets(
                  widget.exerciseIndex,
                  oldIndex,
                  newIndex,
                ),
              ),
              const Divider(height: 36),
              _ExerciseDetailNotesField(
                key: ValueKey('exercise_note_${exercise.id}'),
                initialValue: exercise.note,
                onChanged: (value) => controller.updateExerciseNote(
                  widget.exerciseIndex,
                  value,
                ),
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
    return TextField(
      controller: _controller,
      minLines: 2,
      maxLines: 4,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: context.l10n.routineExerciseNoteHint,
        filled: true,
        fillColor: AppColors.component(context),
        border: const OutlineInputBorder(
          borderRadius: AppRadii.button,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

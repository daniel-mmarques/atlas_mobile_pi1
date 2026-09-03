import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_set.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/set_type.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/set_type_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.index,
    this.isEditable = false,
    this.showCheckbox = false,
    this.showAddSet = false,
    this.activeRest,
    this.onWeightChanged,
    this.onRepsChanged,
    this.onToggleSet,
    this.onAddSet,
    this.onRemoveSet,
  });

  final Exercise exercise;
  final int index;

  final bool isEditable;
  final bool showCheckbox;
  final bool showAddSet;
  final Duration? activeRest;

  final void Function(int setIndex, int value)? onWeightChanged;
  final void Function(int setIndex, int value)? onRepsChanged;
  final void Function(int setIndex)? onToggleSet;
  final VoidCallback? onAddSet;
  final void Function(int setIndex)? onRemoveSet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ExerciseHeader(exercise: exercise),
        const SizedBox(height: 14),
        _Notes(note: exercise.note),
        const SizedBox(height: 14),
        _RestTimer(rest: exercise.rest, activeRest: activeRest),
        const SizedBox(height: 14),
        _ExerciseSetList(
          sets: exercise.sets,
          isEditable: isEditable,
          showCheckbox: showCheckbox,
          onWeightChanged: onWeightChanged,
          onRepsChanged: onRepsChanged,
          onToggle: onToggleSet,
          onRemoveSet: onRemoveSet,
        ),
        if (showAddSet) ...[
          const SizedBox(height: 10),
          _AddSetButton(onTap: onAddSet),
        ],
      ],
    );
  }
}

class _ExerciseHeader extends StatelessWidget {
  const _ExerciseHeader({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.component(context),
          child: ClipOval(
            child: exercise.imageUrl.isNotEmpty
                ? Image.network(
                    exercise.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    cacheWidth: 120,
                    cacheHeight: 120,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.fitness_center),
                  )
                : const Icon(Icons.fitness_center),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            exercise.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        const Icon(Icons.more_vert),
      ],
    );
  }
}

class _Notes extends StatelessWidget {
  const _Notes({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    if (note.isEmpty) {
      return Text(
        context.l10n.addNotesHint,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.textSecondary(context),
        ),
      );
    }
    return Text(note, style: const TextStyle(fontSize: 15));
  }
}

class _RestTimer extends StatelessWidget {
  const _RestTimer({required this.rest, this.activeRest});

  final Duration rest;
  final Duration? activeRest;

  @override
  Widget build(BuildContext context) {
    final countdown = activeRest;
    if (countdown != null) {
      final minutes = countdown.inMinutes.toString().padLeft(2, '0');
      final seconds = (countdown.inSeconds % 60).toString().padLeft(2, '0');
      return Row(
        children: [
          Icon(Icons.timer, size: 18, color: AppColors.accentOf(context)),
          const SizedBox(width: 6),
          Text(
            context.l10n.workoutsRestCountdown(minutes, seconds),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.accentOf(context),
            ),
          ),
        ],
      );
    }
    final minutes = rest.inMinutes;
    final seconds = rest.inSeconds % 60;
    return Row(
      children: [
        const Icon(Icons.timer_outlined, size: 18),
        const SizedBox(width: 6),
        Text(context.l10n.workoutsRest(minutes, seconds)),
      ],
    );
  }
}

class _AddSetButton extends StatelessWidget {
  const _AddSetButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.button,
      onTap: onTap,
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: AppRadii.button,
          color: AppColors.component(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 4),
            Text(context.l10n.workoutsAddSet),
          ],
        ),
      ),
    );
  }
}

class _ExerciseSetList extends StatelessWidget {
  const _ExerciseSetList({
    required this.sets,
    required this.isEditable,
    required this.showCheckbox,
    this.onWeightChanged,
    this.onRepsChanged,
    this.onToggle,
    this.onRemoveSet,
  });

  final List<WorkoutSet> sets;
  final bool isEditable;
  final bool showCheckbox;

  final void Function(int setIndex, int value)? onWeightChanged;
  final void Function(int setIndex, int value)? onRepsChanged;
  final void Function(int setIndex)? onToggle;
  final void Function(int setIndex)? onRemoveSet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SetHeaderRow(showCheckbox: showCheckbox, showDelete: isEditable),
        const SizedBox(height: 4),
        for (int i = 0; i < sets.length; i++)
          _SetRow(
            set: sets[i],
            setIndex: i,
            workIndex: _workIndexFor(i),
            isEditable: isEditable,
            showCheckbox: showCheckbox,
            onWeightChanged: (v) => onWeightChanged?.call(i, v),
            onRepsChanged: (v) => onRepsChanged?.call(i, v),
            onToggle: () => onToggle?.call(i),
            onRemove: onRemoveSet == null ? null : () => onRemoveSet!(i),
          ),
      ],
    );
  }

  int _workIndexFor(int index) {
    var count = 0;
    for (var i = 0; i <= index; i++) {
      if (sets[i].type == SetType.work) count++;
    }
    return count == 0 ? 1 : count;
  }
}

class _SetHeaderRow extends StatelessWidget {
  const _SetHeaderRow({
    required this.showCheckbox,
    required this.showDelete,
  });

  final bool showCheckbox;
  final bool showDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        _FlexCell(1, Text(l10n.workoutsSet)),
        _FlexCell(3, Text(l10n.workoutsPrevious)),
        _FlexCell(2, Text(l10n.workoutsKg)),
        _FlexCell(2, Text(l10n.workoutsReps)),
        if (showCheckbox) const _FlexCell(1, Icon(Icons.check, size: 18)),
        if (showDelete) const _FlexCell(1, SizedBox.shrink()),
      ],
    );
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    required this.set,
    required this.setIndex,
    required this.workIndex,
    required this.isEditable,
    required this.showCheckbox,
    this.onWeightChanged,
    this.onRepsChanged,
    this.onToggle,
    this.onRemove,
  });

  final WorkoutSet set;
  final int setIndex;
  final int workIndex;
  final bool isEditable;
  final bool showCheckbox;

  final ValueChanged<int>? onWeightChanged;
  final ValueChanged<int>? onRepsChanged;
  final VoidCallback? onToggle;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final color =
        setIndex.isEven ? Colors.transparent : AppColors.component(context);

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _FlexCell(
            1,
            SetTypeBadge(
              type: set.type,
              workIndex: workIndex,
              compact: true,
            ),
          ),
          const _FlexCell(
            3,
            Text(
              '—',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          _FlexCell(
            2,
            isEditable
                ? _EditableNumberField(
                    initialValue: set.weight.round(),
                    onChanged: onWeightChanged!,
                  )
                : Text('${set.weight.round()}'),
          ),
          _FlexCell(
            2,
            isEditable
                ? _EditableNumberField(
                    initialValue: set.reps,
                    onChanged: onRepsChanged!,
                  )
                : Text('${set.reps}'),
          ),
          if (showCheckbox)
            _FlexCell(
              1,
              Checkbox(
                value: set.completed,
                onChanged: (_) => onToggle?.call(),
                activeColor: AppColors.accentOf(context),
              ),
            ),
          if (isEditable && onRemove != null)
            _FlexCell(
              1,
              IconButton(
                icon: const Icon(Icons.close, size: AppSpacing.iconSm),
                onPressed: onRemove,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: AppSpacing.minTouch,
                  minHeight: AppSpacing.minTouch,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FlexCell extends StatelessWidget {
  const _FlexCell(this.flex, this.child);

  final int flex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(child: child),
    );
  }
}

class _EditableNumberField extends StatefulWidget {
  const _EditableNumberField({
    required this.initialValue,
    required this.onChanged,
  });

  final int initialValue;
  final ValueChanged<int> onChanged;

  @override
  State<_EditableNumberField> createState() => _EditableNumberFieldState();
}

class _EditableNumberFieldState extends State<_EditableNumberField> {
  late final TextEditingController controller = TextEditingController(
    text: widget.initialValue.toString(),
  );

  @override
  void didUpdateWidget(covariant _EditableNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      controller.text = widget.initialValue.toString();
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.component(context),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: const OutlineInputBorder(
            borderRadius: AppRadii.pill,
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: AppRadii.pill,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadii.pill,
            borderSide: BorderSide(
              color: AppColors.accentOf(context),
              width: 1.5,
            ),
          ),
        ),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: AppColors.textPrimary(context),
        ),
        onChanged: (value) {
          final n = int.tryParse(value);
          if (n != null) widget.onChanged(n);
        },
      ),
    );
  }
}

import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_set.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/set_intensity_mode.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/set_type.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/set_type_badge.dart';
import 'package:atlas_mobile_pi1/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RoutineSetList extends StatelessWidget {
  const RoutineSetList({
    super.key,
    required this.sets,
    required this.onTypeChanged,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onRemoveSet,
    required this.onAddSet,
    this.onIntensityChanged,
    this.onReorder,
    this.detailStyle = false,
  });

  final List<WorkoutSet> sets;
  final Future<void> Function(int setIndex, SetType type) onTypeChanged;
  final void Function(int setIndex, double value) onWeightChanged;
  final void Function(int setIndex, int value) onRepsChanged;
  final void Function(int setIndex, int? value)? onIntensityChanged;
  final void Function(int setIndex) onRemoveSet;
  final VoidCallback onAddSet;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final bool detailStyle;

  int _workIndexFor(int index) {
    var count = 0;
    for (var i = 0; i <= index; i++) {
      if (sets[i].type == SetType.work) count++;
    }
    return count == 0 ? 1 : count;
  }

  String _setTypeTitle(BuildContext context, SetType type) {
    final l10n = context.l10n;
    return switch (type) {
      SetType.warmUp => l10n.setTypeWarmUp,
      SetType.work => l10n.setTypeWork,
      SetType.failure => l10n.setTypeFailure,
      SetType.drop => l10n.setTypeDrop,
      SetType.backoff => l10n.setTypeBackoff,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (detailStyle) {
      return _DetailSetList(
        sets: sets,
        onTypeChanged: onTypeChanged,
        onWeightChanged: onWeightChanged,
        onRepsChanged: onRepsChanged,
        onIntensityChanged: onIntensityChanged,
        onRemoveSet: onRemoveSet,
        onAddSet: onAddSet,
        onReorder: onReorder,
        workIndexFor: _workIndexFor,
        setTypeTitle: (type) => _setTypeTitle(context, type),
      );
    }

    final secondary = AppColors.textSecondary(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  context.l10n.workoutsSet,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  context.l10n.workoutsKg,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  context.l10n.workoutsReps,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
        for (var i = 0; i < sets.length; i++)
          _SetRow(
            set: sets[i],
            workIndex: _workIndexFor(i),
            onTypeTap: () async {
              final type = await showSetTypePicker(
                context,
                current: sets[i].type,
                titleOf: (t) => _setTypeTitle(context, t),
                sheetTitle: context.l10n.setTypeTitle,
              );
              if (type != null) await onTypeChanged(i, type);
            },
            onWeightChanged: (v) => onWeightChanged(i, v),
            onRepsChanged: (v) => onRepsChanged(i, v),
            onRemove: () => onRemoveSet(i),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onAddSet,
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.l10n.workoutsAddSet),
          ),
        ),
      ],
    );
  }
}

class _DetailSetList extends StatelessWidget {
  const _DetailSetList({
    required this.sets,
    required this.onTypeChanged,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onIntensityChanged,
    required this.onRemoveSet,
    required this.onAddSet,
    required this.onReorder,
    required this.workIndexFor,
    required this.setTypeTitle,
  });

  final List<WorkoutSet> sets;
  final Future<void> Function(int setIndex, SetType type) onTypeChanged;
  final void Function(int setIndex, double value) onWeightChanged;
  final void Function(int setIndex, int value) onRepsChanged;
  final void Function(int setIndex, int? value)? onIntensityChanged;
  final void Function(int setIndex) onRemoveSet;
  final VoidCallback onAddSet;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final int Function(int index) workIndexFor;
  final String Function(SetType type) setTypeTitle;

  static const double _controlSize = 48;
  static const double _dropIndent = 28;
  static const double _rowGap = 12;
  static const double _setColWidth = 48;
  static const double _menuColWidth = 36;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final l10n = context.l10n;
    final prefs = context.watch<PreferencesService>();
    final intensityMode = prefs.setIntensityMode;
    final showIntensity = intensityMode != SetIntensityMode.none;
    final weightLabel =
        prefs.isImperialSystem ? l10n.workoutsLb : l10n.workoutsKg;
    final intensityLabel = switch (intensityMode) {
      SetIntensityMode.rpe => l10n.workoutsRpe,
      SetIntensityMode.rir => l10n.workoutsRir,
      SetIntensityMode.none => '',
    };

    final headerStyle = TextStyle(
      color: secondary,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              SizedBox(
                width: _setColWidth,
                child: Text(
                  l10n.workoutsSet,
                  textAlign: TextAlign.center,
                  style: headerStyle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(weightLabel, textAlign: TextAlign.center, style: headerStyle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.workoutsReps,
                  textAlign: TextAlign.center,
                  style: headerStyle,
                ),
              ),
              if (showIntensity) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    intensityLabel,
                    textAlign: TextAlign.center,
                    style: headerStyle,
                  ),
                ),
              ],
              SizedBox(width: _menuColWidth),
            ],
          ),
        ),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: sets.length,
          proxyDecorator: (child, index, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final t = Curves.easeOut.transform(animation.value);
                return Material(
                  color: Colors.transparent,
                  elevation: 6 * t,
                  shadowColor: Colors.black54,
                  borderRadius: BorderRadius.circular(14),
                  child: child,
                );
              },
            );
          },
          onReorder: (oldIndex, newIndex) {
            onReorder?.call(oldIndex, newIndex);
          },
          itemBuilder: (context, i) {
            final set = sets[i];
            return Padding(
              key: ValueKey(set.id),
              padding: EdgeInsets.only(
                bottom: i < sets.length - 1 ? _rowGap : 0,
              ),
              child: ReorderableDelayedDragStartListener(
                index: i,
                child: _DetailSetRow(
                  set: set,
                  workIndex: workIndexFor(i),
                  indented: set.type == SetType.drop,
                  indent: _dropIndent,
                  showIntensity: showIntensity,
                  onTypeTap: () async {
                    final type = await showSetTypePicker(
                      context,
                      current: set.type,
                      titleOf: setTypeTitle,
                      sheetTitle: l10n.setTypeTitle,
                    );
                    if (type != null) await onTypeChanged(i, type);
                  },
                  onWeightChanged: (v) => onWeightChanged(i, v),
                  onRepsChanged: (v) => onRepsChanged(i, v),
                  onIntensityChanged: onIntensityChanged == null
                      ? null
                      : (v) => onIntensityChanged!(i, v),
                  onMenuSelected: (value) async {
                    if (value == 'type') {
                      final type = await showSetTypePicker(
                        context,
                        current: set.type,
                        titleOf: setTypeTitle,
                        sheetTitle: l10n.setTypeTitle,
                      );
                      if (type != null) await onTypeChanged(i, type);
                    } else if (value == 'remove' && sets.length > 1) {
                      onRemoveSet(i);
                    }
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: onAddSet,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: _controlSize,
                  height: _controlSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border(context),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(Icons.add, color: primary, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  l10n.workoutsAddSet,
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailSetRow extends StatelessWidget {
  const _DetailSetRow({
    required this.set,
    required this.workIndex,
    required this.indented,
    required this.indent,
    required this.showIntensity,
    required this.onTypeTap,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onIntensityChanged,
    required this.onMenuSelected,
  });

  final WorkoutSet set;
  final int workIndex;
  final bool indented;
  final double indent;
  final bool showIntensity;
  final VoidCallback onTypeTap;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<int> onRepsChanged;
  final ValueChanged<int?>? onIntensityChanged;
  final Future<void> Function(String value) onMenuSelected;

  static const double _controlSize = 48;
  static const double _setColWidth = 48;
  static const double _menuColWidth = 36;

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.textSecondary(context);
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(left: indented ? indent : 0),
      child: SizedBox(
        height: _controlSize,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: _setColWidth,
              child: Center(
                child: SetTypeBadge(
                  type: set.type,
                  workIndex: workIndex,
                  size: _controlSize,
                  outlined: true,
                  onTap: onTypeTap,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _NumberPillField(
                height: _controlSize,
                value: _formatWeightDisplay(set.weight),
                allowDecimal: true,
                maxLength: 6,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (raw) {
                  onWeightChanged(_parseWeight(raw).clamp(0, 999.99));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _NumberPillField(
                height: _controlSize,
                value: set.reps == 0 ? '' : '${set.reps}',
                allowDecimal: false,
                maxLength: 2,
                keyboardType: TextInputType.number,
                onChanged: (raw) {
                  final parsed = int.tryParse(raw) ?? 0;
                  onRepsChanged(parsed.clamp(0, 99));
                },
              ),
            ),
            if (showIntensity) ...[
              const SizedBox(width: 8),
              Expanded(
                child: _NumberPillField(
                  height: _controlSize,
                  value: set.intensity == null ? '' : '${set.intensity}',
                  allowDecimal: false,
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  onChanged: (raw) {
                    if (raw.isEmpty) {
                      onIntensityChanged?.call(null);
                      return;
                    }
                    final parsed = int.tryParse(raw);
                    if (parsed == null) return;
                    onIntensityChanged?.call(parsed.clamp(0, 10));
                  },
                ),
              ),
            ],
            SizedBox(
              width: _menuColWidth,
              height: _controlSize,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: secondary,
                  size: 24,
                ),
                onSelected: (value) => onMenuSelected(value),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'type', child: Text(l10n.setTypeTitle)),
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(
                      l10n.remove,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pill só com número — ocupa a largura da coluna da tabela.
class _NumberPillField extends StatefulWidget {
  const _NumberPillField({
    required this.value,
    required this.onChanged,
    required this.keyboardType,
    required this.maxLength,
    this.height = 48,
    this.allowDecimal = false,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final int maxLength;
  final double height;
  final bool allowDecimal;

  @override
  State<_NumberPillField> createState() => _NumberPillFieldState();
}

class _NumberPillFieldState extends State<_NumberPillField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _NumberPillField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text != widget.value && !_focusNode.hasFocus) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimary(context);
    final border = AppColors.border(context);

    return Container(
      height: widget.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.height / 2),
        border: Border.all(color: border.withValues(alpha: 0.85)),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        inputFormatters: [
          if (widget.allowDecimal)
            const _WeightInputFormatter()
          else
            FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(widget.maxLength),
        ],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        cursorColor: primary,
        decoration: InputDecoration(
          isDense: true,
          isCollapsed: true,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          hintText: '0',
          hintStyle: TextStyle(
            color: primary.withValues(alpha: 0.35),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

/// Aceita dígitos e no máximo uma vírgula/ponto, com até 2 casas.
class _WeightInputFormatter extends TextInputFormatter {
  const _WeightInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.replaceAll('.', ',');
    if (raw.isEmpty) return newValue.copyWith(text: '');

    if (!RegExp(r'^\d{0,3}(,\d{0,2})?$').hasMatch(raw)) {
      return oldValue;
    }

    if (raw.startsWith(',')) return oldValue;

    return TextEditingValue(
      text: raw,
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}

String _formatWeightDisplay(double weight) {
  if (weight <= 0) return '';
  if (weight == weight.roundToDouble()) return '${weight.round()}';
  var text = weight.toStringAsFixed(2);
  text = text.replaceFirst(RegExp(r'0+$'), '');
  text = text.replaceFirst(RegExp(r'\.$'), '');
  return text.replaceAll('.', ',');
}

double _parseWeight(String raw) {
  final normalized = raw.trim().replaceAll(',', '.');
  if (normalized.isEmpty || normalized == '.') return 0;
  return double.tryParse(normalized) ?? 0;
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    required this.set,
    required this.workIndex,
    required this.onTypeTap,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onRemove,
  });

  final WorkoutSet set;
  final int workIndex;
  final VoidCallback onTypeTap;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<int> onRepsChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SetTypeBadge(type: set.type, workIndex: workIndex, onTap: onTypeTap),
          const SizedBox(width: 8),
          Expanded(
            child: _NumberField(
              value: set.weight == 0 ? 0 : set.weight.round(),
              onChanged: (v) => onWeightChanged(v.toDouble()),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _NumberField(value: set.reps, onChanged: onRepsChanged),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.textSecondary(context),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberField extends StatefulWidget {
  const _NumberField({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value == 0 ? '' : '${widget.value}',
    );
  }

  @override
  void didUpdateWidget(covariant _NumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.value == 0 ? '' : '${widget.value}';
    if (_controller.text != next && !_controller.selection.isValid) {
      _controller.text = next;
    }
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
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.component(context),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) => widget.onChanged(int.tryParse(value) ?? 0),
    );
  }
}

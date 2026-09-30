import 'dart:async';

import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/exercises_catalog_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/catalog_exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/exercise_catalog_info_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<List<CatalogExercise>?> showExercisePicker(BuildContext context) {
  return showAtlasSheet<List<CatalogExercise>>(
    context: context,
    builder: (_) => const _ExercisePickerSheet(),
  );
}

class _ExercisePickerSheet extends StatefulWidget {
  const _ExercisePickerSheet();

  @override
  State<_ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<_ExercisePickerSheet> {
  final _selected = <String, CatalogExercise>{};
  final _searchController = TextEditingController();

  List<String> _bodyParts = const [];
  List<String> _equipments = const [];
  String? _selectedBodyPart;
  String? _selectedEquipment;
  List<CatalogExercise> _items = const [];
  bool _loading = true;
  bool _syncing = false;
  String? _error;
  String _query = '';
  Timer? _debounce;

  ExercisesCatalogRepository get _repo =>
      context.read<ExercisesCatalogRepository>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final parts = await _repo.bodyParts();
      final equipments = await _repo.equipments();
      final items = await _repo.filter();
      if (!mounted) return;
      setState(() {
        _bodyParts = parts;
        _equipments = equipments;
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _repo.filter(
        bodyPart: _selectedBodyPart,
        equipment: _selectedEquipment,
        query: _query,
      );
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        _syncing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _syncing = false;
        _error = e.toString();
      });
    }
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      setState(() {
        _query = value.trim();
        _syncing = true;
      });
      _reload();
    });
  }

  Future<void> _pickEquipment() async {
    final chosen = await _showOptionSheet(
      title: 'Equipment',
      options: _equipments,
      selected: _selectedEquipment,
      allLabel: 'All Equipment',
    );
    if (!mounted || chosen == null) return;
    setState(() {
      _selectedEquipment = chosen.isEmpty ? null : chosen;
    });
    await _reload();
  }

  Future<void> _pickMuscle() async {
    final chosen = await _showOptionSheet(
      title: 'Muscles',
      options: _bodyParts,
      selected: _selectedBodyPart,
      allLabel: 'All Muscles',
    );
    if (!mounted || chosen == null) return;
    setState(() {
      _selectedBodyPart = chosen.isEmpty ? null : chosen;
    });
    await _reload();
  }

  Future<String?> _showOptionSheet({
    required String title,
    required List<String> options,
    required String? selected,
    required String allLabel,
  }) {
    return showAtlasSheet<String>(
      context: context,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: AppSpacing.sheetMin,
          maxChildSize: AppSpacing.sheetMax,
          shouldCloseOnMinExtent: true,
          builder: (_, scrollController) {
            return Column(
              children: [
                AtlasSheetChrome(
                  title: title,
                  onNav: () => Navigator.pop(sheetContext),
                  isDismiss: true,
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.sheetPaddingH,
                      AppSpacing.sm,
                      AppSpacing.sheetPaddingH,
                      AppSpacing.sheetPaddingB,
                    ),
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(allLabel),
                        trailing: selected == null
                            ? Icon(
                                Icons.check,
                                color: AppColors.accentOf(sheetContext),
                              )
                            : null,
                        onTap: () => Navigator.pop(sheetContext, ''),
                      ),
                      const Divider(height: 1),
                      for (final option in options)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(option),
                          trailing: selected == option
                              ? Icon(
                                  Icons.check,
                                  color: AppColors.accentOf(sheetContext),
                                )
                              : null,
                          onTap: () => Navigator.pop(sheetContext, option),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggle(CatalogExercise item) {
    setState(() {
      if (_selected.containsKey(item.id)) {
        _selected.remove(item.id);
      } else {
        _selected[item.id] = item;
      }
    });
  }

  void _confirm() {
    Navigator.of(context).pop(_selected.values.toList());
  }

  String get _sectionLabel {
    if (_query.isNotEmpty) return 'Search results';
    if (_selectedBodyPart != null || _selectedEquipment != null) {
      return 'Filtered exercises';
    }
    return 'Exercises';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final equipmentLabel = _selectedEquipment ?? 'All Equipment';
    final muscleLabel = _selectedBodyPart ?? 'All Muscles';

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: AppSpacing.sheetInitial,
      minChildSize: AppSpacing.sheetMinContent,
      maxChildSize: AppSpacing.sheetMax,
      shouldCloseOnMinExtent: true,
      builder: (context, scrollController) {
        return Column(
          children: [
            AtlasSheetChrome(
              title: l10n.routineAddExercises,
              onNav: () => Navigator.of(context).maybePop(),
              isDismiss: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sheetPaddingH,
                AppSpacing.md,
                AppSpacing.sheetPaddingH,
                AppSpacing.sm,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onQueryChanged,
                decoration: InputDecoration(
                  hintText: l10n.workoutsSearchExercise,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _syncing
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.component(context),
                  border: const OutlineInputBorder(
                    borderRadius: AppRadii.button,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sheetPaddingH,
                0,
                AppSpacing.sheetPaddingH,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _FilterButton(
                      label: equipmentLabel,
                      active: _selectedEquipment != null,
                      onTap: _pickEquipment,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _FilterButton(
                      label: muscleLabel,
                      active: _selectedBodyPart != null,
                      onTap: _pickMuscle,
                    ),
                  ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sheetPaddingH,
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sheetPaddingH,
                AppSpacing.sm,
                AppSpacing.sheetPaddingH,
                AppSpacing.xs,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _sectionLabel,
                  style: AppTypography.meta(context),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.sheetPaddingH,
                        0,
                        AppSpacing.sheetPaddingH,
                        AppSpacing.sm,
                      ),
                      itemCount: _items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        final selected = _selected.containsKey(item.id);
                        return _ExercisePickTile(
                          exercise: item,
                          selected: selected,
                          onToggle: () => _toggle(item),
                          onInfo: () => showExerciseCatalogInfoSheet(
                            context,
                            exercise: item,
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.sheetPaddingH,
                AppSpacing.sm,
                AppSpacing.sheetPaddingH,
                AppSpacing.sheetPaddingB,
              ),
              child: AppActionButton.sheet(
                label: l10n.save,
                onTap: _selected.isEmpty ? null : _confirm,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentOf(context);
    return Material(
      color: AppColors.component(context),
      borderRadius: AppRadii.button,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.button,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: AppRadii.button,
            border: active
                ? Border.all(color: accent.withValues(alpha: 0.7))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? accent : AppColors.textPrimary(context),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: active ? accent : AppColors.textSecondary(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExercisePickTile extends StatelessWidget {
  const _ExercisePickTile({
    required this.exercise,
    required this.selected,
    required this.onToggle,
    required this.onInfo,
  });

  final CatalogExercise exercise;
  final bool selected;
  final VoidCallback onToggle;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentOf(context);
    final subtitle = exercise.primaryTarget.isNotEmpty
        ? exercise.primaryTarget
        : exercise.primaryBodyPart;

    return Material(
      color: selected
          ? accent.withValues(alpha: 0.18)
          : AppColors.component(context).withValues(alpha: 0.35),
      borderRadius: AppRadii.button,
      child: InkWell(
        onTap: onToggle,
        borderRadius: AppRadii.button,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _ExerciseThumb(url: exercise.imageUrl),
                  if (selected)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface(context),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onInfo,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseThumb extends StatelessWidget {
  const _ExerciseThumb({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 56,
        height: 56,
        child: url.isEmpty
            ? ColoredBox(
                color: AppColors.component(context),
                child: const Icon(Icons.fitness_center),
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: AppColors.component(context),
                  child: const Icon(Icons.fitness_center),
                ),
              ),
      ),
    );
  }
}

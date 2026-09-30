import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/exercises_catalog_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/catalog_exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/exercise_media_preview.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showExerciseCatalogInfoSheet(
  BuildContext context, {
  required CatalogExercise exercise,
}) {
  return showAtlasSheet<void>(
    context: context,
    builder: (_) => _ExerciseCatalogInfoSheet(initial: exercise),
  );
}

class _ExerciseCatalogInfoSheet extends StatefulWidget {
  const _ExerciseCatalogInfoSheet({required this.initial});

  final CatalogExercise initial;

  @override
  State<_ExerciseCatalogInfoSheet> createState() =>
      _ExerciseCatalogInfoSheetState();
}

class _ExerciseCatalogInfoSheetState extends State<_ExerciseCatalogInfoSheet> {
  late CatalogExercise _exercise;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _exercise = widget.initial;
    WidgetsBinding.instance.addPostFrameCallback((_) => _enrich());
  }

  Future<void> _enrich() async {
    if (_exercise.videoUrl.isNotEmpty && _exercise.instructions.isNotEmpty) {
      return;
    }
    setState(() => _loading = true);
    try {
      final detail = await context
          .read<ExercisesCatalogRepository>()
          .getById(_exercise.id);
      if (!mounted || detail == null) return;
      setState(() {
        _exercise = detail;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final targets = _exercise.targetMuscles;
    final secondary = _exercise.secondaryMuscles;
    final instructions = _exercise.instructions;

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
              title: _exercise.name,
              onNav: () => Navigator.of(context).maybePop(),
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
                  ExerciseMediaPreview(
                    videoUrl: _exercise.videoUrl,
                    imageUrl: _exercise.imageUrl,
                    loading: _loading,
                  ),
                  if (targets.isNotEmpty || secondary.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Muscles',
                      style: AppTypography.meta(context).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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
                            backgroundColor: AppColors.component(context),
                          ),
                        for (final m in secondary)
                          Chip(
                            label: Text(m),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ],
                  if (_exercise.equipments.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Equipment',
                      style: AppTypography.meta(context).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(_exercise.equipments.join(', ')),
                  ],
                  if (instructions.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Instructions',
                      style: AppTypography.meta(context).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (var i = 0; i < instructions.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('${i + 1}. ${instructions[i]}'),
                      ),
                  ],
                  if (_loading &&
                      targets.isEmpty &&
                      instructions.isEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

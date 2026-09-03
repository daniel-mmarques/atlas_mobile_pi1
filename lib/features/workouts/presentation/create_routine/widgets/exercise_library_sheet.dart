import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/seed_exercises.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';

Future<List<({String id, String name})>?> showSeedExercisePicker(
  BuildContext context,
) {
  return showAtlasSheet<List<({String id, String name})>>(
    context: context,
    builder: (_) => const _SeedExercisePickerSheet(),
  );
}

class _SeedExercisePickerSheet extends StatefulWidget {
  const _SeedExercisePickerSheet();

  @override
  State<_SeedExercisePickerSheet> createState() =>
      _SeedExercisePickerSheetState();
}

class _SeedExercisePickerSheetState extends State<_SeedExercisePickerSheet> {
  final _selected = <String>{};
  String _query = '';

  void _confirm() {
    final items = seedExercises
        .where((e) => _selected.contains(e['id']))
        .map((e) => (id: e['id']!, name: e['name']!))
        .toList();
    Navigator.of(context).pop(items);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filtered = seedExercises.where((e) {
      if (_query.trim().isEmpty) return true;
      return (e['name'] ?? '')
          .toLowerCase()
          .contains(_query.trim().toLowerCase());
    }).toList();

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
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: l10n.workoutsSearchExercise,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.component(context),
                  border: const OutlineInputBorder(
                    borderRadius: AppRadii.button,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sheetPaddingH,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  final id = item['id']!;
                  final selected = _selected.contains(id);
                  return CheckboxListTile(
                    value: selected,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) {
                      setState(() {
                        if (v == true) {
                          _selected.add(id);
                        } else {
                          _selected.remove(id);
                        }
                      });
                    },
                    title: Text(item['name']!),
                    controlAffinity: ListTileControlAffinity.leading,
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

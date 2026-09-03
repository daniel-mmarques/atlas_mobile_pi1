import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/templates_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/create_routine_controller.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/steps/edit_name_step.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/steps/preset_name_step.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/steps/routine_builder_step.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/steps/routine_exercise_page.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/steps/schedule_step.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/create_routine_chrome.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showCreateRoutineSheet(BuildContext context) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.routineSignInRequired)),
    );
    return Future.value();
  }

  final templatesRepo = context.read<TemplatesRepository>();

  return showAtlasSheet<void>(
    context: context,
    builder: (_) {
      return ChangeNotifierProvider(
        create: (_) => CreateRoutineController(
          templatesRepository: templatesRepo,
          userId: userId,
        ),
        child: const CreateRoutineSheet(),
      );
    },
  );
}

/// Abre a tela de detalhamento de uma rotina já salva (com Start no topo).
Future<void> showRoutineDetailSheet(
  BuildContext context,
  WorkoutTemplate template,
) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.routineSignInRequired)),
    );
    return Future.value();
  }

  final templatesRepo = context.read<TemplatesRepository>();

  return showAtlasSheet<void>(
    context: context,
    builder: (_) {
      return ChangeNotifierProvider(
        create: (_) => CreateRoutineController(
          templatesRepository: templatesRepo,
          userId: userId,
          existing: template,
        ),
        child: const CreateRoutineSheet(),
      );
    },
  );
}

class CreateRoutineSheet extends StatelessWidget {
  const CreateRoutineSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final step = context.select<CreateRoutineController, CreateRoutineStep>(
      (c) => c.step,
    );
    final editingIndex =
        context.select<CreateRoutineController, int?>((c) => c.editingExerciseIndex);
    final progress =
        context.select<CreateRoutineController, double>((c) => c.progress);
    final controller = context.read<CreateRoutineController>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: AppSpacing.sheetInitial,
      minChildSize: AppSpacing.sheetMinContent,
      maxChildSize: AppSpacing.sheetMax,
      shouldCloseOnMinExtent: true,
      builder: (context, scrollController) {
        return Column(
          children: [
            const AtlasSheetHandle(),
            if (step != CreateRoutineStep.builder && editingIndex == null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sheetPaddingH,
                ),
                child: CreateRoutineHeader(
                  progress: progress,
                  onNav: step == CreateRoutineStep.preset
                      ? () => Navigator.of(context).maybePop()
                      : controller.goBack,
                  isDismiss: step == CreateRoutineStep.preset,
                ),
              ),
              Expanded(
                child: AtlasSheetContentTransition(
                  child: editingIndex != null
                      ? KeyedSubtree(
                          key: ValueKey('exercise_$editingIndex'),
                          child: RoutineExercisePage(
                            exerciseIndex: editingIndex,
                          ),
                        )
                      : KeyedSubtree(
                          key: ValueKey(step),
                          child: switch (step) {
                            CreateRoutineStep.preset => const PresetNameStep(),
                            CreateRoutineStep.name => const EditNameStep(),
                            CreateRoutineStep.schedule => const ScheduleStep(),
                            CreateRoutineStep.builder => RoutineBuilderStep(
                                onClosed: () => Navigator.of(context).pop(),
                              ),
                          },
                        ),
                ),
              ),
            ],
        );
      },
    );
  }
}

import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/feed/data/posts_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/seed_exercises.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/controllers/live_workout_controller.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:atlas_mobile_pi1/ui/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WorkoutSessionPage extends StatelessWidget {
  const WorkoutSessionPage({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LiveWorkoutController(
        workout: workout,
        workoutService: context.read<WorkoutService>(),
        postsRepository: context.read<PostsRepository>(),
        authService: context.read<AuthService>(),
      ),
      child: const _LiveWorkoutView(),
    );
  }
}

class _LiveWorkoutView extends StatelessWidget {
  const _LiveWorkoutView();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom + 120;

    return Scaffold(
      appBar: AppBar(
        title: Text('Treino', style: AppTypography.pageTitle(context)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: AppIconButton(
              icon: Icons.tune_rounded,
              onPressed: () {},
              size: 40,
              iconSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.pageHorizontal),
            child: SizedBox(
              width: 96,
              child: AppActionButton(
                label: 'Finalizar',
                height: 40,
                borderRadius: AppRadii.pill,
                emphasized: true,
                onTap: () => _finish(context),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
          ),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: _LiveWorkoutPageHeader()),
              const _LiveWorkoutExerciseList(),
              SliverPadding(
                padding: EdgeInsets.only(bottom: bottomInset),
                sliver: const SliverToBoxAdapter(child: _FooterSection()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _finish(BuildContext context) async {
    final controller = context.read<LiveWorkoutController>();
    await controller.finishWorkout();
    if (context.mounted) context.pop();
  }
}

class _LiveWorkoutPageHeader extends StatelessWidget {
  const _LiveWorkoutPageHeader();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LiveWorkoutController>();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: controller.elapsed,
            builder: (_, duration, _) => Text(
              controller.formatDuration(duration),
              style: AppTypography.metric(context, size: 36),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Em andamento', style: AppTypography.meta(context)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Selector<LiveWorkoutController, String>(
                  selector: (_, c) => c.totalVolume,
                  builder: (_, value, _) =>
                      _StatChip(label: 'Volume', value: value),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Selector<LiveWorkoutController, String>(
                  selector: (_, c) => c.totalSets,
                  builder: (_, value, _) =>
                      _StatChip(label: 'Séries', value: value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadii.cardSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.meta(context)),
          const SizedBox(height: 2),
          Text(value, style: AppTypography.metric(context, size: 20)),
        ],
      ),
    );
  }
}

class _LiveWorkoutExerciseList extends StatelessWidget {
  const _LiveWorkoutExerciseList();

  @override
  Widget build(BuildContext context) {
    return Selector<LiveWorkoutController, int>(
      selector: (_, controller) => controller.workout.exercises.length,
      builder: (_, length, _) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Selector<LiveWorkoutController, Exercise>(
              selector: (_, controller) =>
                  controller.workout.exercises[index],
              builder: (_, exercise, _) {
                final controller = context.read<LiveWorkoutController>();
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ExerciseCard(
                    exercise: exercise,
                    index: index,
                    isEditable: true,
                    showCheckbox: true,
                    showAddSet: true,
                    onWeightChanged: (set, v) =>
                        controller.updateWeight(index, set, v),
                    onRepsChanged: (set, v) =>
                        controller.updateReps(index, set, v),
                    onToggleSet: (set) => controller.toggleSet(index, set),
                    onAddSet: () => controller.addSet(index),
                    onRemoveSet: (set) => controller.removeSet(index, set),
                  ),
                );
              },
            );
          }, childCount: length),
        );
      },
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 20),
        _AddExerciseButton(),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _DiscardWorkoutButton()),
            SizedBox(width: 16),
            Expanded(child: _FinishWorkoutButton()),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class _AddExerciseButton extends StatelessWidget {
  const _AddExerciseButton();

  @override
  Widget build(BuildContext context) {
    return AppActionButton(
      label: 'Adicionar exercício',
      icon: Icons.add,
      color: AppColors.component(context),
      onTap: () async {
        final selected = await showModalBottomSheet<Map<String, String>>(
          context: context,
          showDragHandle: true,
          builder: (context) {
            return ListView(
              children: seedExercises
                  .map(
                    (e) => ListTile(
                      title: Text(e['name']!),
                      onTap: () => Navigator.pop(context, e),
                    ),
                  )
                  .toList(),
            );
          },
        );
        if (selected == null || !context.mounted) return;
        context.read<LiveWorkoutController>().addExercise(
              exerciseId: selected['id'] ?? const Uuid().v4(),
              name: selected['name']!,
            );
      },
    );
  }
}

class _DiscardWorkoutButton extends StatelessWidget {
  const _DiscardWorkoutButton();

  @override
  Widget build(BuildContext context) {
    return AppActionButton(
      label: 'Descartar',
      icon: Icons.delete_forever_rounded,
      color: AppColors.error,
      onTap: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Descartar treino?'),
            content: const Text('Esta ação não pode ser desfeita.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Descartar'),
              ),
            ],
          ),
        );
        if (confirm == true && context.mounted) {
          await context.read<LiveWorkoutController>().discardWorkout();
          if (context.mounted) context.pop();
        }
      },
    );
  }
}

class _FinishWorkoutButton extends StatelessWidget {
  const _FinishWorkoutButton();

  @override
  Widget build(BuildContext context) {
    return AppActionButton(
      label: 'Finalizar',
      icon: Icons.check,
      emphasized: true,
      bold: true,
      borderRadius: AppRadii.pill,
      onTap: () async {
        await context.read<LiveWorkoutController>().finishWorkout();
        if (context.mounted) context.pop();
      },
    );
  }
}

import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/templates_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/loading_empty_list.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:atlas_mobile_pi1/ui/widgets/shell_page_header.dart';
import 'package:atlas_mobile_pi1/ui/widgets/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthService>().user?.uid;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShellPageHeader(
              title: 'Workouts',
              actions: [
                AppIconButton(
                  icon: Icons.search_rounded,
                  onPressed: () => context.push(AppRoutes.exerciseSearch),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const _WorkoutActions(),
                      const SizedBox(height: AppSpacing.sectionGap),
                      _TemplatesSection(userId: userId),
                      const SizedBox(height: AppSpacing.sectionGap),
                      const _WorkoutsVisualizer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutActions extends StatelessWidget {
  const _WorkoutActions();

  Future<void> _startEmptyWorkout(BuildContext context) async {
    final userId = context.read<AuthService>().user?.uid;
    if (userId == null) return;

    final workout = await context.read<WorkoutService>().createEmptyWorkout(
          userId,
          name: 'Empty Workout',
        );

    if (!context.mounted) return;
    context.push(AppRoutes.workoutSession(workout.id), extra: workout);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _WorkoutPageButton(
          icon: Icons.add,
          label: 'Start Empty Workout',
          fullWidth: true,
          onPressed: () => _startEmptyWorkout(context),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  elevation: 0,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => context.push(AppRoutes.routineNew),
                child: const Row(
                  children: [
                    Icon(Icons.assignment_outlined),
                    SizedBox(width: 8),
                    Text(
                      'New routine',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  elevation: 0,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => context.push(AppRoutes.exerciseSearch),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded),
                    SizedBox(width: 8),
                    Text(
                      'Explore',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkoutPageButton extends StatelessWidget {
  const _WorkoutPageButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        padding: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class _WorkoutsVisualizer extends StatelessWidget {
  const _WorkoutsVisualizer();

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthService>().user?.uid;
    if (userId == null) {
      return const SizedBox.shrink();
    }

    final workoutService = context.read<WorkoutService>();

    return LoadingEmptyList<Workout>(
      stream: workoutService.watchUserWorkouts(userId),
      emptyMessage: 'Nenhum treino salvo ainda. Comece um treino vazio!',
      emptyPadding: const EdgeInsets.only(bottom: 110, top: 24),
      separator: (context, workouts) => Padding(
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
          spacing: 14,
          children: workouts
              .map((workout) => WorkoutCard(workout: workout))
              .toList(),
        ),
      ),
      itemBuilder: (_, workout) => WorkoutCard(workout: workout),
    );
  }
}

class _TemplatesSection extends StatelessWidget {
  const _TemplatesSection({this.userId});

  final String? userId;

  Future<void> _startFromTemplate(
    BuildContext context,
    WorkoutTemplate template,
  ) async {
    final uid = userId;
    if (uid == null) return;

    final service = context.read<WorkoutService>();
    var workout = await service.createEmptyWorkout(uid, name: template.name);
    workout = workout.copyWith(
      exercises: template.exercises,
      templateId: template.id,
    );
    await service.saveWorkout(workout);

    if (!context.mounted) return;
    context.push(AppRoutes.workoutSession(workout.id), extra: workout);
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) return const SizedBox.shrink();

    final templatesRepo = context.read<TemplatesRepository>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rotinas salvas', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        StreamBuilder<List<WorkoutTemplate>>(
          stream: templatesRepo.watchUserTemplates(userId!),
          builder: (context, snapshot) {
            final templates = snapshot.data ?? [];
            if (templates.isEmpty) {
              return const Text('Nenhuma rotina salva ainda.');
            }
            return Column(
              children: templates
                  .map(
                    (t) => ListTile(
                      tileColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(t.name),
                      subtitle: Text('${t.exercises.length} exercícios'),
                      trailing: const Icon(Icons.play_arrow_rounded),
                      onTap: () => _startFromTemplate(context, t),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

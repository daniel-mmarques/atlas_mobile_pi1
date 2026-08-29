import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/ui/components/slide_to_start_action.dart';
import 'package:atlas_mobile_pi1/ui/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkoutDetailsPage extends StatelessWidget {
  const WorkoutDetailsPage({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final canStart = workout.finishedAt == null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(workout.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => context.pop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
              canStart ? 110 : AppSpacing.lg,
            ),
            children: [
              const SizedBox(height: 10),
              if (workout.exercises.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Text('Nenhum exercício neste treino ainda.'),
                )
              else
                ...List.generate(
                  workout.exercises.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: ExerciseCard(
                      index: index,
                      exercise: workout.exercises[index],
                      isEditable: false,
                    ),
                  ),
                ),
            ],
          ),
          if (canStart)
            Positioned(
              left: 18,
              right: 18,
              bottom: 0,
              child: SafeArea(
                child: SlideToStartAction(
                  text: 'Começar',
                  borderRadius: 50,
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  sliderButtonIcon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onSubmit: () => context.push(
                    AppRoutes.workoutTransition(workout.id),
                    extra: workout,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

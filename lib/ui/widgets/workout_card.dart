import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/workout_source.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_card.dart';
import 'package:atlas_mobile_pi1/ui/widgets/workout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.workout,
  });

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      onTap: () => context.push(
        AppRoutes.workoutDetails(workout.id),
        extra: workout,
      ),
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => WorkoutBottomSheet(
            workoutName: workout.name,
            onDelete: () async {
              Navigator.pop(context);
              await context.read<WorkoutService>().deleteWorkout(workout.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Treino excluído')),
                );
              }
            },
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  splitTitleTwoLines(workout.name),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 15),
                _WorkoutInfoRow(
                  count: workout.exerciseCount,
                  duration: workout.formattedDuration,
                ),
                if (workout.source == WorkoutSource.coachAssigned) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Atribuído pelo coach',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedTeal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutInfoRow extends StatelessWidget {
  const _WorkoutInfoRow({required this.count, required this.duration});

  final int count;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ExerciseBadge(count: count),
        const SizedBox(width: 6),
        const Text(
          'Exercises',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          duration,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ExerciseBadge extends StatelessWidget {
  const _ExerciseBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.mutedTeal,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

String splitTitleTwoLines(String title) {
  final words = title.trim().split(' ');
  if (words.length <= 1) return title;
  final middle = (words.length / 2).ceil();
  final firstLine = words.take(middle).join(' ');
  final secondLine = words.skip(middle).join(' ');
  return '$firstLine\n$secondLine';
}

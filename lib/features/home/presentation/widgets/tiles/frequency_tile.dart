import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/home_widget_tile.dart';
import 'package:atlas_mobile_pi1/features/metrics/workout_metrics.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FrequencyTile extends StatelessWidget {
  const FrequencyTile({
    super.key,
    required this.userId,
    required this.style,
    required this.name,
  });

  final String userId;
  final HomeWidgetStyle style;
  final String name;

  int _workoutsThisMonth(List<Workout> workouts) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return workouts
        .where(
          (w) =>
              w.finishedAt != null &&
              w.startedAt != null &&
              !w.startedAt!.isBefore(start),
        )
        .length;
  }

  double _averagePerWeek(List<Workout> workouts) {
    final finished = workouts
        .where((w) => w.finishedAt != null && w.startedAt != null)
        .toList();
    if (finished.isEmpty) return 0;
    final dates = finished.map((w) => w.startedAt!).toList()..sort();
    final spanDays =
        DateTime.now().difference(dates.first).inDays.clamp(1, 3650);
    final weeks = spanDays / 7.0;
    return finished.length / (weeks < 1 ? 1 : weeks);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Workout>>(
      stream: context.read<WorkoutService>().watchUserWorkouts(userId),
      builder: (context, snapshot) {
        final workouts = snapshot.data ?? const <Workout>[];
        final week = WorkoutMetrics.weeklyFrequency(workouts);
        final month = _workoutsThisMonth(workouts);
        final avg = _averagePerWeek(workouts);
        final hasData = week > 0 || month > 0;

        if (style == HomeWidgetStyle.list) {
          return Padding(
            padding: const EdgeInsets.only(right: 28, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  hasData ? 'Training frequency' : 'Not logged',
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    children: [
                      _FreqRow(
                        label: 'Esta semana',
                        value: '$week',
                      ),
                      const SizedBox(height: 6),
                      _FreqRow(
                        label: 'Este mês',
                        value: '$month',
                      ),
                      const SizedBox(height: 6),
                      _FreqRow(
                        label: 'Média/sem',
                        value: avg.toStringAsFixed(1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return HomeTileNumber(
          value: '$week',
          title: name,
          subtitle: hasData ? 'This week' : 'Not logged',
        );
      },
    );
  }
}

class _FreqRow extends StatelessWidget {
  const _FreqRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/home_widget_tile.dart';
import 'package:atlas_mobile_pi1/features/metrics/workout_metrics.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VolumeTile extends StatelessWidget {
  const VolumeTile({
    super.key,
    required this.userId,
    required this.style,
    required this.name,
  });

  final String userId;
  final HomeWidgetStyle style;
  final String name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Workout>>(
      stream: context.read<WorkoutService>().watchUserWorkouts(userId),
      builder: (context, snapshot) {
        final workouts = snapshot.data ?? const <Workout>[];
        final weekdayVolumes = WorkoutMetrics.volumeByWeekday(workouts);
        final current = WorkoutMetrics.weeklyVolume(workouts);
        final hasData = current > 0 || weekdayVolumes.any((v) => v > 0);

        if (style == HomeWidgetStyle.chart) {
          return _VolumeChart(
            values: weekdayVolumes,
            name: name,
            hasData: hasData,
          );
        }

        return HomeTileNumber(
          value: _formatVolume(current),
          unit: 'kg',
          title: name,
          subtitle: hasData ? 'This week' : 'Not logged',
        );
      },
    );
  }

  String _formatVolume(int value) {
    if (value >= 1000) {
      final k = value / 1000;
      return k >= 10 ? k.toStringAsFixed(0) : k.toStringAsFixed(1);
    }
    return '$value';
  }
}

class _VolumeChart extends StatelessWidget {
  const _VolumeChart({
    required this.values,
    required this.name,
    required this.hasData,
  });

  final List<int> values;
  final String name;
  final bool hasData;

  @override
  Widget build(BuildContext context) {
    final max = values.fold<int>(0, (a, b) => a > b ? a : b);
    final labels = const ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

    return Padding(
      padding: const EdgeInsets.only(right: 28, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          Text(
            hasData ? 'Weekly volume' : 'Not logged',
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (index) {
                final value = values[index];
                final factor = max == 0 ? 0.0 : value / max;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: factor.clamp(0.08, 1.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

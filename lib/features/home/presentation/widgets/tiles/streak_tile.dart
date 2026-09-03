import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/home_widget_tile.dart';
import 'package:atlas_mobile_pi1/features/metrics/workout_metrics.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreakTile extends StatelessWidget {
  const StreakTile({
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
      stream: context.read<WorkoutService>().watchUserWorkoutsMetrics(userId),
      builder: (context, snapshot) {
        final workouts = snapshot.data ?? const <Workout>[];
        final streak = WorkoutMetrics.streak(workouts);
        final hasData = streak.currentStreak > 0 || streak.longestStreak > 0;

        if (style == HomeWidgetStyle.calendar) {
          return _StreakCalendar(streak: streak, name: name);
        }

        return HomeTileNumber(
          value: '${streak.currentStreak}',
          title: name,
          subtitle: hasData
              ? (streak.currentStreak == 1 ? '1 day streak' : 'days streak')
              : context.l10n.widgetNotLogged,
        );
      },
    );
  }
}

class _StreakCalendar extends StatelessWidget {
  const _StreakCalendar({required this.streak, required this.name});

  final TrainingStreak streak;
  final String name;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final active = streak.recentActiveDays
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();
    final hasData = streak.currentStreak > 0;

    return Padding(
      padding: const EdgeInsets.only(right: 28, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${streak.currentStreak}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          Text(
            hasData ? 'days streak' : context.l10n.widgetNotLogged,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const cols = 7;
                const rows = 2;
                const gap = 4.0;
                final cellW = (constraints.maxWidth - gap * (cols - 1)) / cols;
                final cellH = (constraints.maxHeight - gap * (rows - 1)) / rows;
                final size = cellW < cellH ? cellW : cellH;

                return Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: List.generate(14, (index) {
                      final day =
                          todayDate.subtract(Duration(days: 13 - index));
                      final isActive = active.contains(day);
                      final isToday = day == todayDate;
                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.accentOf(context)
                              : AppColors.component(context),
                          borderRadius: BorderRadius.circular(5),
                          border: isToday
                              ? Border.all(
                                  color: AppColors.textPrimary(context),
                                  width: 1.2,
                                )
                              : null,
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

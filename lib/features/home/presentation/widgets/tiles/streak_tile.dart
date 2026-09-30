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
    final l10n = context.l10n;

    return StreamBuilder<List<Workout>>(
      stream: context.read<WorkoutService>().watchUserWorkoutsMetrics(userId),
      builder: (context, snapshot) {
        final workouts = snapshot.data ?? const <Workout>[];
        final streak = WorkoutMetrics.streak(workouts);
        final hasData = streak.currentStreak > 0 || streak.longestStreak > 0;
        final streakLabel = streak.currentStreak == 1
            ? l10n.widgetDayStreak
            : l10n.widgetDaysStreak;

        if (style == HomeWidgetStyle.calendar) {
          return _StreakCalendar(
            streak: streak,
            name: name,
            hasData: hasData,
            streakLabel: streakLabel,
            bestLabel: streak.longestStreak > streak.currentStreak
                ? l10n.widgetBestStreak(streak.longestStreak)
                : null,
          );
        }

        return HomeTileNumber(
          value: '${streak.currentStreak}',
          title: name,
          subtitle: hasData ? streakLabel : l10n.widgetNotLogged,
          footer: hasData && streak.longestStreak > streak.currentStreak
              ? l10n.widgetBestStreak(streak.longestStreak)
              : null,
        );
      },
    );
  }
}

class _StreakCalendar extends StatelessWidget {
  const _StreakCalendar({
    required this.streak,
    required this.name,
    required this.hasData,
    required this.streakLabel,
    this.bestLabel,
  });

  final TrainingStreak streak;
  final String name;
  final bool hasData;
  final String streakLabel;
  final String? bestLabel;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final active = streak.recentActiveDays
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();
    final accent = AppColors.accentOf(context);
    final track = AppColors.component(context).withValues(alpha: 0.55);
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);

    return Padding(
      padding: const EdgeInsets.only(right: 28, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${streak.currentStreak}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1,
                ),
          ),
          const SizedBox(height: 4),
          HomeWidgetChrome(
            title: name,
            subtitle: hasData ? streakLabel : context.l10n.widgetNotLogged,
          ),
          if (bestLabel != null) ...[
            const SizedBox(height: 2),
            Text(
              bestLabel!,
              style: TextStyle(
                color: secondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
                          color: isActive ? accent : track,
                          borderRadius: BorderRadius.circular(5),
                          border: isToday
                              ? Border.all(
                                  color: primary,
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

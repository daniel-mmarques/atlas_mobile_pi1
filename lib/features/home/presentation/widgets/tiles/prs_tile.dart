import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/home_widget_tile.dart';
import 'package:atlas_mobile_pi1/features/metrics/workout_metrics.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _PrEntry {
  const _PrEntry({
    required this.exerciseName,
    required this.weight,
    required this.reps,
  });

  final String exerciseName;
  final double weight;
  final int reps;
}

class PrsTile extends StatelessWidget {
  const PrsTile({
    super.key,
    required this.userId,
    required this.style,
    required this.name,
  });

  final String userId;
  final HomeWidgetStyle style;
  final String name;

  List<_PrEntry> _topPrs(List<Workout> workouts) {
    final best = <String, _PrEntry>{};
    for (final w in workouts) {
      for (final e in w.exercises) {
        for (final set in e.sets) {
          if (!set.completed || set.weight <= 0) continue;
          final prev = best[e.name];
          if (prev == null || set.weight > prev.weight) {
            best[e.name] = _PrEntry(
              exerciseName: e.name,
              weight: set.weight,
              reps: set.reps,
            );
          }
        }
      }
    }
    final list = best.values.toList()
      ..sort((a, b) => b.weight.compareTo(a.weight));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StreamBuilder<List<Workout>>(
      stream: context.read<WorkoutService>().watchUserWorkoutsMetrics(userId),
      builder: (context, snapshot) {
        final workouts = snapshot.data ?? const <Workout>[];
        final count = WorkoutMetrics.personalRecordsCount(workouts);
        final prs = _topPrs(workouts);
        final hasData = count > 0 || prs.isNotEmpty;

        if (style == HomeWidgetStyle.list) {
          final items = prs.take(4).toList();
          return Padding(
            padding: const EdgeInsets.only(right: 28, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeWidgetChrome(
                  title: name,
                  subtitle: hasData
                      ? l10n.widgetPersonalRecords
                      : l10n.widgetNotLogged,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: items.isEmpty
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            l10n.widgetNoPrsYet,
                            style: TextStyle(
                              color: AppColors.textSecondary(context),
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            for (final pr in items)
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        pr.exerciseName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color:
                                              AppColors.textPrimary(context),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${pr.weight.round()}${l10n.commonKg} × ${pr.reps}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: AppColors.accentOf(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
          );
        }

        return HomeTileNumber(
          value: '$count',
          title: name,
          subtitle:
              hasData ? l10n.widgetPersonalRecords : l10n.widgetNotLogged,
        );
      },
    );
  }
}

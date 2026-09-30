import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/home_widget_tile.dart';
import 'package:atlas_mobile_pi1/features/metrics/workout_metrics.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DurationTile extends StatelessWidget {
  const DurationTile({
    super.key,
    required this.userId,
    required this.style,
    required this.name,
  });

  final String userId;
  final HomeWidgetStyle style;
  final String name;

  String _format(int minutes) {
    if (minutes <= 0) return '0';
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return m == 0 ? '${h}h' : '${h}h ${m}m';
    }
    return '$minutes';
  }

  String? _unit(int minutes) {
    if (minutes >= 60) return null;
    return 'min';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StreamBuilder<List<Workout>>(
      stream: context.read<WorkoutService>().watchUserWorkoutsMetrics(userId),
      builder: (context, snapshot) {
        final workouts = snapshot.data ?? const <Workout>[];
        final minutes = WorkoutMetrics.avgDurationMinutes(workouts);
        final hasData = minutes > 0;
        return HomeTileNumber(
          value: _format(minutes),
          unit: _unit(minutes),
          title: name,
          subtitle: hasData ? l10n.widgetAvgSession : l10n.widgetNotLogged,
        );
      },
    );
  }
}

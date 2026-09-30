import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
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
    final l10n = context.l10n;

    return StreamBuilder<List<Workout>>(
      stream: context.read<WorkoutService>().watchUserWorkoutsMetrics(userId),
      builder: (context, snapshot) {
        final workouts = snapshot.data ?? const <Workout>[];
        final weekdayVolumes = WorkoutMetrics.volumeByWeekday(workouts);
        final current = WorkoutMetrics.weeklyVolume(workouts);
        final hasData = current > 0 || weekdayVolumes.any((v) => v > 0);

        if (style == HomeWidgetStyle.chart) {
          return _VolumeChart(
            values: weekdayVolumes,
            total: current,
            name: name,
            hasData: hasData,
          );
        }

        return HomeTileNumber(
          value: _formatVolume(current),
          unit: l10n.commonKg,
          title: name,
          subtitle: hasData ? l10n.calendarThisWeek : l10n.widgetNotLogged,
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
    required this.total,
    required this.name,
    required this.hasData,
  });

  final List<int> values;
  final int total;
  final String name;
  final bool hasData;

  String _formatVolume(int value) {
    if (value >= 1000) {
      final k = value / 1000;
      return k >= 10 ? k.toStringAsFixed(0) : k.toStringAsFixed(1);
    }
    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final max = values.fold<int>(0, (a, b) => a > b ? a : b);
    final labels = const ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
    final todayIndex = DateTime.now().weekday - 1;
    final accent = AppColors.accentOf(context);
    final track = AppColors.component(context);
    final secondary = AppColors.textSecondary(context);
    final primary = AppColors.textPrimary(context);

    return Padding(
      padding: const EdgeInsets.only(right: 28, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HomeWidgetChrome(
                  title: name,
                  subtitle: hasData
                      ? l10n.widgetWeeklyVolume
                      : l10n.widgetNotLogged,
                ),
              ),
              if (hasData)
                Text(
                  '${_formatVolume(total)} ${l10n.commonKg}',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: -0.3,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (index) {
                final value = values[index];
                final isToday = index == todayIndex;
                final factor = max == 0 || value == 0 ? 0.0 : value / max;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final barH = value == 0
                                    ? 0.0
                                    : (constraints.maxHeight * factor)
                                        .clamp(6.0, constraints.maxHeight);
                                return Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: constraints.maxHeight,
                                      decoration: BoxDecoration(
                                        color: track.withValues(alpha: 0.45),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    if (barH > 0)
                                      Container(
                                        width: double.infinity,
                                        height: barH,
                                        decoration: BoxDecoration(
                                          color: accent,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: isToday
                                              ? Border.all(
                                                  color: primary,
                                                  width: 1.2,
                                                )
                                              : null,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                isToday ? FontWeight.w700 : FontWeight.w400,
                            color: isToday ? primary : secondary,
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

import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';

class TrainingStreak {
  const TrainingStreak({
    required this.currentStreak,
    required this.longestStreak,
    this.recentActiveDays = const [],
  });

  final int currentStreak;
  final int longestStreak;
  final List<DateTime> recentActiveDays;
}

class WorkoutMetrics {
  static Set<DateTime> activeDays(List<Workout> workouts) {
    return workouts
        .where((w) => w.finishedAt != null && w.startedAt != null)
        .map((w) {
          final d = w.startedAt!;
          return DateTime(d.year, d.month, d.day);
        })
        .toSet();
  }

  static TrainingStreak streak(List<Workout> workouts) {
    final days = activeDays(workouts).toList()..sort();
    if (days.isEmpty) {
      return const TrainingStreak(currentStreak: 0, longestStreak: 0);
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final daySet = days.toSet();

    var current = 0;
    var cursor = daySet.contains(todayDate)
        ? todayDate
        : todayDate.subtract(const Duration(days: 1));
    while (daySet.contains(cursor)) {
      current++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    var longest = 1;
    var run = 1;
    for (var i = 1; i < days.length; i++) {
      if (days[i].difference(days[i - 1]).inDays == 1) {
        run++;
        if (run > longest) longest = run;
      } else {
        run = 1;
      }
    }

    final recent = <DateTime>[];
    for (var i = 0; i < 14; i++) {
      final d = todayDate.subtract(Duration(days: i));
      if (daySet.contains(d)) recent.add(d);
    }

    return TrainingStreak(
      currentStreak: current,
      longestStreak: longest,
      recentActiveDays: recent,
    );
  }

  static int weeklyVolume(List<Workout> workouts) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return workouts
        .where(
          (w) =>
              w.finishedAt != null &&
              w.startedAt != null &&
              !w.startedAt!.isBefore(start),
        )
        .fold(0, (sum, w) => sum + w.volume);
  }

  static List<int> volumeByWeekday(List<Workout> workouts) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final volumes = List<int>.filled(7, 0);
    for (final w in workouts) {
      if (w.finishedAt == null || w.startedAt == null) continue;
      if (w.startedAt!.isBefore(start)) continue;
      final idx = w.startedAt!.weekday - 1;
      volumes[idx] += w.volume;
    }
    return volumes;
  }

  static int weeklyFrequency(List<Workout> workouts) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return workouts
        .where(
          (w) =>
              w.finishedAt != null &&
              w.startedAt != null &&
              !w.startedAt!.isBefore(start),
        )
        .length;
  }

  static int personalRecordsCount(List<Workout> workouts) {
    // Simplificado: número de exercícios distintos com volume > 0.
    final names = <String>{};
    for (final w in workouts) {
      for (final e in w.exercises) {
        final vol = e.sets.fold<double>(
          0,
          (s, set) => s + (set.completed ? set.reps * set.weight : 0),
        );
        if (vol > 0) names.add(e.name);
      }
    }
    return names.length;
  }

  static int avgDurationMinutes(List<Workout> workouts) {
    final finished = workouts.where((w) => w.duration != null).toList();
    if (finished.isEmpty) return 0;
    final total = finished.fold<int>(
      0,
      (sum, w) => sum + w.duration!.inMinutes,
    );
    return (total / finished.length).round();
  }
}

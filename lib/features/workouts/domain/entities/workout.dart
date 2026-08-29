import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/workout_source.dart';

class Workout {
  const Workout({
    required this.id,
    this.userId = '',
    required this.name,
    this.startedAt,
    this.finishedAt,
    this.exercises = const [],
    this.volume = 0,
    this.isPublic = true,
    this.assignedByCoachId,
    this.source = WorkoutSource.self,
    this.templateId,
  });

  final String id;
  final String userId;
  final String name;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final List<Exercise> exercises;
  final int volume;
  final bool isPublic;
  final String? assignedByCoachId;
  final WorkoutSource source;
  final String? templateId;

  int get exerciseCount => exercises.length;

  Duration? get duration {
    if (startedAt == null || finishedAt == null) return null;
    return finishedAt!.difference(startedAt!);
  }

  String get formattedDuration {
    final d = duration;
    if (d == null) return '--';
    final minutes = d.inMinutes;
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    return '$hours h ${remaining > 0 ? '$remaining min' : ''}'.trim();
  }

  Workout copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? startedAt,
    DateTime? finishedAt,
    List<Exercise>? exercises,
    int? volume,
    bool? isPublic,
    String? assignedByCoachId,
    WorkoutSource? source,
    String? templateId,
  }) {
    return Workout(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      exercises: exercises ?? this.exercises,
      volume: volume ?? this.volume,
      isPublic: isPublic ?? this.isPublic,
      assignedByCoachId: assignedByCoachId ?? this.assignedByCoachId,
      source: source ?? this.source,
      templateId: templateId ?? this.templateId,
    );
  }
}

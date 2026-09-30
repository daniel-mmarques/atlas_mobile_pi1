import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/template_schedule_mode.dart';

class WorkoutTemplate {
  const WorkoutTemplate({
    required this.id,
    required this.userId,
    required this.name,
    this.exercises = const [],
    this.notes = '',
    this.defaultRestSeconds = 90,
    this.scheduleMode = TemplateScheduleMode.none,
    this.weekdays,
    this.restDaysBetween,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final List<Exercise> exercises;
  final String notes;
  final int defaultRestSeconds;
  final TemplateScheduleMode scheduleMode;
  final List<int>? weekdays;
  final int? restDaysBetween;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Duration get defaultRest => Duration(seconds: defaultRestSeconds);

  WorkoutTemplate copyWith({
    String? id,
    String? userId,
    String? name,
    List<Exercise>? exercises,
    String? notes,
    int? defaultRestSeconds,
    TemplateScheduleMode? scheduleMode,
    List<int>? weekdays,
    int? restDaysBetween,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutTemplate(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      weekdays: weekdays ?? this.weekdays,
      restDaysBetween: restDaysBetween ?? this.restDaysBetween,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

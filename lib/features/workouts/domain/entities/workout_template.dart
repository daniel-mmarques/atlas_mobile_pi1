import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/template_schedule_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  /// Descanso padrão do treino (aplicado a novos exercícios).
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

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'name': name,
        'exercises': exercises.map((e) => e.toMap()).toList(),
        'notes': notes,
        'defaultRestSeconds': defaultRestSeconds,
        'scheduleMode': scheduleMode.toJson(),
        'weekdays': scheduleMode == TemplateScheduleMode.weekdays
            ? weekdays
            : null,
        'restDaysBetween': scheduleMode == TemplateScheduleMode.frequency
            ? restDaysBetween
            : null,
        if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
        if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      };

  factory WorkoutTemplate.fromMap(String id, Map<String, dynamic> map) {
    return WorkoutTemplate(
      id: id,
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      exercises: (map['exercises'] as List<dynamic>? ?? [])
          .map((e) => Exercise.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      notes: map['notes'] as String? ?? '',
      defaultRestSeconds: (map['defaultRestSeconds'] as num?)?.toInt() ?? 90,
      scheduleMode: TemplateScheduleMode.fromJson(map['scheduleMode'] as String?),
      weekdays: (map['weekdays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      restDaysBetween: (map['restDaysBetween'] as num?)?.toInt(),
      createdAt: _readDate(map['createdAt']),
      updatedAt: _readDate(map['updatedAt']),
    );
  }

  static DateTime? _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

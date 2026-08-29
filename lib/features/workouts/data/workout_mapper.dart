import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/workout_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutMapper {
  static Map<String, dynamic> toMap(Workout workout) {
    return {
      'userId': workout.userId,
      'name': workout.name,
      'startedAt': workout.startedAt != null
          ? Timestamp.fromDate(workout.startedAt!)
          : null,
      'finishedAt': workout.finishedAt != null
          ? Timestamp.fromDate(workout.finishedAt!)
          : null,
      'exercises': workout.exercises.map((e) => e.toMap()).toList(),
      'volume': workout.volume,
      'isPublic': workout.isPublic,
      'assignedByCoachId': workout.assignedByCoachId,
      'source': workout.source.dbIndex,
      'templateId': workout.templateId,
    };
  }

  static Workout fromMap(String id, Map<String, dynamic> map) {
    return Workout(
      id: id,
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      startedAt: _parseTimestamp(map['startedAt']),
      finishedAt: _parseTimestamp(map['finishedAt']),
      exercises: (map['exercises'] as List<dynamic>? ?? [])
          .map((e) => Exercise.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      volume: (map['volume'] as num?)?.toInt() ?? 0,
      isPublic: map['isPublic'] as bool? ?? true,
      assignedByCoachId: map['assignedByCoachId'] as String?,
      source: WorkoutSourceIndex.fromDbIndex(
        (map['source'] as num?)?.toInt() ?? 0,
      ),
      templateId: map['templateId'] as String?,
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

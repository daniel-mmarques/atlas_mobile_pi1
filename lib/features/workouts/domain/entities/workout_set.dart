import 'package:atlas_mobile_pi1/features/workouts/domain/enums/set_type.dart';
import 'package:uuid/uuid.dart';

class WorkoutSet {
  WorkoutSet({
    String? id,
    this.type = SetType.work,
    this.reps = 0,
    this.weight = 0,
    this.intensity,
    this.completed = false,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final SetType type;
  final int reps;
  final double weight;

  /// Valor de RPE/RIR (0–10), conforme preferência da conta.
  final int? intensity;
  final bool completed;

  WorkoutSet copyWith({
    String? id,
    SetType? type,
    int? reps,
    double? weight,
    int? intensity,
    bool clearIntensity = false,
    bool? completed,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      type: type ?? this.type,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      intensity: clearIntensity ? null : (intensity ?? this.intensity),
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type.toJson(),
        'reps': reps,
        'weight': weight,
        if (intensity != null) 'intensity': intensity,
        'completed': completed,
      };

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      id: map['id'] as String?,
      type: SetType.fromJson(map['type'] as String?),
      reps: (map['reps'] as num?)?.toInt() ?? 0,
      weight: (map['weight'] as num?)?.toDouble() ?? 0,
      intensity: (map['intensity'] as num?)?.toInt() ??
          (map['rpe'] as num?)?.toInt() ??
          (map['rir'] as num?)?.toInt(),
      completed: map['completed'] as bool? ?? false,
    );
  }
}

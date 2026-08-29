class WorkoutSet {
  const WorkoutSet({
    this.reps = 0,
    this.weight = 0,
    this.completed = false,
  });

  final int reps;
  final double weight;
  final bool completed;

  WorkoutSet copyWith({int? reps, double? weight, bool? completed}) {
    return WorkoutSet(
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() => {
        'reps': reps,
        'weight': weight,
        'completed': completed,
      };

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      reps: (map['reps'] as num?)?.toInt() ?? 0,
      weight: (map['weight'] as num?)?.toDouble() ?? 0,
      completed: map['completed'] as bool? ?? false,
    );
  }
}

import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_set.dart';

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    this.imageUrl = '',
    this.rest = const Duration(seconds: 90),
    this.note = '',
    this.sets = const [],
  });

  final String id;
  final String name;
  final String imageUrl;
  final Duration rest;
  final String note;
  final List<WorkoutSet> sets;

  Exercise copyWith({
    String? id,
    String? name,
    String? imageUrl,
    Duration? rest,
    String? note,
    List<WorkoutSet>? sets,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      rest: rest ?? this.rest,
      note: note ?? this.note,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'restSeconds': rest.inSeconds,
        'note': note,
        'sets': sets.map((s) => s.toMap()).toList(),
      };

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      rest: Duration(seconds: (map['restSeconds'] as num?)?.toInt() ?? 90),
      note: map['note'] as String? ?? '',
      sets: (map['sets'] as List<dynamic>? ?? [])
          .map((e) => WorkoutSet.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

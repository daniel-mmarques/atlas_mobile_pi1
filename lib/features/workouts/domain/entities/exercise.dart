import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_set.dart';

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    this.imageUrl = '',
    this.videoUrl = '',
    this.bodyPart = '',
    this.target = '',
    this.equipment = '',
    this.rest = const Duration(seconds: 90),
    this.note = '',
    this.sets = const [],
  });

  final String id;
  final String name;
  final String imageUrl;
  final String videoUrl;
  final String bodyPart;
  final String target;
  final String equipment;
  final Duration rest;
  final String note;
  final List<WorkoutSet> sets;

  Exercise copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? videoUrl,
    String? bodyPart,
    String? target,
    String? equipment,
    Duration? rest,
    String? note,
    List<WorkoutSet>? sets,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      bodyPart: bodyPart ?? this.bodyPart,
      target: target ?? this.target,
      equipment: equipment ?? this.equipment,
      rest: rest ?? this.rest,
      note: note ?? this.note,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'bodyPart': bodyPart,
        'target': target,
        'equipment': equipment,
        'restSeconds': rest.inSeconds,
        'note': note,
        'sets': sets.map((s) => s.toMap()).toList(),
      };

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      videoUrl: map['videoUrl'] as String? ?? '',
      bodyPart: map['bodyPart'] as String? ?? '',
      target: map['target'] as String? ?? '',
      equipment: map['equipment'] as String? ?? '',
      rest: Duration(seconds: (map['restSeconds'] as num?)?.toInt() ?? 90),
      note: map['note'] as String? ?? '',
      sets: (map['sets'] as List<dynamic>? ?? [])
          .map((e) => WorkoutSet.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

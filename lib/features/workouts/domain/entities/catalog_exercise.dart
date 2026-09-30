class CatalogExercise {
  const CatalogExercise({
    required this.id,
    required this.name,
    this.imageUrl = '',
    this.videoUrl = '',
    this.bodyParts = const [],
    this.targetMuscles = const [],
    this.secondaryMuscles = const [],
    this.equipments = const [],
    this.instructions = const [],
    this.overview = '',
  });

  final String id;
  final String name;
  final String imageUrl;
  final String videoUrl;
  final List<String> bodyParts;
  final List<String> targetMuscles;
  final List<String> secondaryMuscles;
  final List<String> equipments;
  final List<String> instructions;
  final String overview;

  String get primaryBodyPart =>
      bodyParts.isEmpty ? '' : bodyParts.first;

  String get primaryTarget =>
      targetMuscles.isEmpty ? '' : targetMuscles.first;

  String get primaryEquipment =>
      equipments.isEmpty ? '' : equipments.first;

  String get subtitle {
    final parts = <String>[
      if (primaryTarget.isNotEmpty) primaryTarget,
      if (primaryEquipment.isNotEmpty) primaryEquipment,
    ];
    return parts.join(' · ');
  }

  CatalogExercise copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? videoUrl,
    List<String>? bodyParts,
    List<String>? targetMuscles,
    List<String>? secondaryMuscles,
    List<String>? equipments,
    List<String>? instructions,
    String? overview,
  }) {
    return CatalogExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      bodyParts: bodyParts ?? this.bodyParts,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      equipments: equipments ?? this.equipments,
      instructions: instructions ?? this.instructions,
      overview: overview ?? this.overview,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'bodyParts': bodyParts,
        'targetMuscles': targetMuscles,
        'secondaryMuscles': secondaryMuscles,
        'equipments': equipments,
        'instructions': instructions,
        'overview': overview,
      };

  factory CatalogExercise.fromJson(Map<String, dynamic> json) {
    List<String> stringList(dynamic value) {
      if (value is! List) return const [];
      return value.map((e) => e.toString()).toList();
    }

    final imageUrls = json['imageUrls'];
    var imageUrl = json['imageUrl'] as String? ?? '';
    if (imageUrl.isEmpty && imageUrls is Map) {
      imageUrl = (imageUrls['360p'] ?? imageUrls['480p'] ?? '').toString();
    }

    return CatalogExercise(
      id: (json['exerciseId'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      imageUrl: imageUrl,
      videoUrl: (json['videoUrl'] ?? '').toString(),
      bodyParts: stringList(json['bodyParts']),
      targetMuscles: stringList(json['targetMuscles']),
      secondaryMuscles: stringList(json['secondaryMuscles']),
      equipments: stringList(json['equipments']),
      instructions: stringList(json['instructions']),
      overview: (json['overview'] ?? '').toString(),
    );
  }
}

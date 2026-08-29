import 'package:atlas_mobile_pi1/core/firestore/firestore_paths.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class WorkoutTemplate {
  const WorkoutTemplate({
    required this.id,
    required this.userId,
    required this.name,
    this.exercises = const [],
  });

  final String id;
  final String userId;
  final String name;
  final List<Exercise> exercises;

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'name': name,
        'exercises': exercises.map((e) => e.toMap()).toList(),
      };

  factory WorkoutTemplate.fromMap(String id, Map<String, dynamic> map) {
    return WorkoutTemplate(
      id: id,
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      exercises: (map['exercises'] as List<dynamic>? ?? [])
          .map((e) => Exercise.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

abstract class TemplatesRepository {
  Stream<List<WorkoutTemplate>> watchUserTemplates(String userId);
  Future<String> save(WorkoutTemplate template);
  Future<void> delete(String id);
}

class TemplatesRepositoryImpl implements TemplatesRepository {
  TemplatesRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  static const _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> get _templates =>
      _db.collection(FirestorePaths.templates);

  @override
  Stream<List<WorkoutTemplate>> watchUserTemplates(String userId) {
    return _templates
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WorkoutTemplate.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  @override
  Future<String> save(WorkoutTemplate template) async {
    final id = template.id.isEmpty ? _uuid.v4() : template.id;
    await _templates.doc(id).set({
      ...template.toMap(),
      'userId': template.userId,
      'name': template.name,
      'exercises': template.exercises.map((e) => e.toMap()).toList(),
    }, SetOptions(merge: true));
    return id;
  }

  @override
  Future<void> delete(String id) async {
    await _templates.doc(id).delete();
  }
}

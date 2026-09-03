import 'package:atlas_mobile_pi1/core/firestore/firestore_paths.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

export 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_template.dart';

abstract class TemplatesRepository {
  Stream<List<WorkoutTemplate>> watchUserTemplates(String userId);
  Future<WorkoutTemplate?> getById(String id);
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
  Future<WorkoutTemplate?> getById(String id) async {
    final doc = await _templates.doc(id).get();
    final data = doc.data();
    if (!doc.exists || data == null) return null;
    return WorkoutTemplate.fromMap(doc.id, data);
  }

  @override
  Future<String> save(WorkoutTemplate template) async {
    final id = template.id.isEmpty ? _uuid.v4() : template.id;
    final now = DateTime.now();
    final createdAt = template.createdAt ?? now;
    final toSave = template.copyWith(
      id: id,
      createdAt: createdAt,
      updatedAt: now,
    );
    await _templates.doc(id).set(toSave.toMap(), SetOptions(merge: true));
    return id;
  }

  @override
  Future<void> delete(String id) async {
    await _templates.doc(id).delete();
  }
}

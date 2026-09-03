import 'package:atlas_mobile_pi1/core/firestore/firestore_paths.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/workout_mapper.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract class WorkoutsRepository {
  Future<String> createWorkout(String userId, String name);
  Future<void> saveWorkout(Workout workout);
  Future<void> deleteWorkout(String id);
  Future<Workout?> getWorkout(String id);
  /// When [limit] is set, only the newest workouts are streamed.
  Stream<List<Workout>> watchUserWorkouts(String userId, {int? limit});
}

class WorkoutsRepositoryImpl implements WorkoutsRepository {
  WorkoutsRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  static const _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> get _workouts =>
      _db.collection(FirestorePaths.workouts);

  @override
  Future<String> createWorkout(String userId, String name) async {
    final id = _uuid.v4();
    final workout = Workout(
      id: id,
      userId: userId,
      name: name,
      startedAt: DateTime.now(),
      exercises: const [],
    );
    await _workouts.doc(id).set(WorkoutMapper.toMap(workout));
    return id;
  }

  @override
  Future<void> saveWorkout(Workout workout) async {
    await _workouts
        .doc(workout.id)
        .set(WorkoutMapper.toMap(workout), SetOptions(merge: true));
  }

  @override
  Future<void> deleteWorkout(String id) async {
    await _workouts.doc(id).delete();
  }

  @override
  Future<Workout?> getWorkout(String id) async {
    final doc = await _workouts.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return WorkoutMapper.fromMap(doc.id, doc.data()!);
  }

  @override
  Stream<List<Workout>> watchUserWorkouts(String userId, {int? limit}) {
    Query<Map<String, dynamic>> query = _workouts
        .where('userId', isEqualTo: userId)
        .orderBy('startedAt', descending: true);
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => WorkoutMapper.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}

import 'package:atlas_mobile_pi1/core/dataconnect/dc_helpers.dart';
import 'package:atlas_mobile_pi1/dataconnect_generated/atlas.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/workout_source.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:uuid/uuid.dart';

abstract class WorkoutsRepository {
  Future<String> createWorkout(String userId, String name);
  Future<void> saveWorkout(Workout workout);
  Future<void> deleteWorkout(String id);
  Future<Workout?> getWorkout(String id);
  Stream<List<Workout>> watchUserWorkouts(String userId, {int? limit});
}

class WorkoutsRepositoryImpl implements WorkoutsRepository {
  WorkoutsRepositoryImpl({AtlasConnector? connector})
      : _dc = connector ?? AtlasConnector.instance;

  final AtlasConnector _dc;
  static const _uuid = Uuid();

  Workout _mapRow({
    required String id,
    required String userId,
    required String name,
    Timestamp? startedAt,
    Timestamp? finishedAt,
    AnyValue? exercisesJson,
    required int volume,
    required bool isPublic,
    String? assignedByCoachId,
    required int source,
    String? templateId,
  }) {
    return Workout(
      id: id,
      userId: userId,
      name: name,
      startedAt: fromDcTimestamp(startedAt),
      finishedAt: fromDcTimestamp(finishedAt),
      exercises: exercisesFromAny(exercisesJson),
      volume: volume,
      isPublic: isPublic,
      assignedByCoachId: assignedByCoachId,
      source: WorkoutSourceIndex.fromDbIndex(source),
      templateId: templateId,
    );
  }

  @override
  Future<String> createWorkout(String userId, String name) async {
    final id = _uuid.v4();
    await _dc
        .createWorkout(id: id, userId: userId, name: name)
        .startedAt(toDcTimestamp(DateTime.now()))
        .exercisesJson(AnyValue(const []))
        .volume(0)
        .isPublic(true)
        .source(WorkoutSource.self.dbIndex)
        .execute();
    return id;
  }

  @override
  Future<void> saveWorkout(Workout workout) async {
    await _dc
        .upsertWorkout(
          id: workout.id,
          userId: workout.userId,
          name: workout.name,
          volume: workout.volume,
          isPublic: workout.isPublic,
          source: workout.source.dbIndex,
        )
        .startedAt(
          workout.startedAt != null
              ? toDcTimestamp(workout.startedAt!)
              : null,
        )
        .finishedAt(
          workout.finishedAt != null
              ? toDcTimestamp(workout.finishedAt!)
              : null,
        )
        .exercisesJson(exercisesToAny(workout.exercises))
        .assignedByCoachId(workout.assignedByCoachId)
        .templateId(workout.templateId)
        .execute();
  }

  @override
  Future<void> deleteWorkout(String id) async {
    await _dc.deleteWorkout(id: id).execute();
  }

  @override
  Future<Workout?> getWorkout(String id) async {
    final result = await _dc.getWorkout(id: id).execute();
    final w = result.data.workout;
    if (w == null) return null;
    return _mapRow(
      id: w.id,
      userId: w.user.id,
      name: w.name,
      startedAt: w.startedAt,
      finishedAt: w.finishedAt,
      exercisesJson: w.exercisesJson,
      volume: w.volume,
      isPublic: w.isPublic,
      assignedByCoachId: w.assignedByCoachId,
      source: w.source,
      templateId: w.templateId,
    );
  }

  @override
  Stream<List<Workout>> watchUserWorkouts(String userId, {int? limit}) {
    return subscribeMapped(
      () {
        final builder = _dc.listUserWorkouts(userId: userId);
        if (limit != null) builder.limit(limit);
        return builder.ref();
      },
      (ListUserWorkoutsData data) => data.workouts
          .map(
            (w) => _mapRow(
              id: w.id,
              userId: w.user.id,
              name: w.name,
              startedAt: w.startedAt,
              finishedAt: w.finishedAt,
              exercisesJson: w.exercisesJson,
              volume: w.volume,
              isPublic: w.isPublic,
              assignedByCoachId: w.assignedByCoachId,
              source: w.source,
              templateId: w.templateId,
            ),
          )
          .toList(),
    );
  }
}

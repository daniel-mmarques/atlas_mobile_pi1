import 'package:atlas_mobile_pi1/features/workouts/data/workouts_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_set.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_template.dart';

/// Facade over [WorkoutsRepository] with broadcast stream caching so multiple
/// widgets share one Firestore listener per (userId, limit) pair.
class WorkoutService {
  WorkoutService(this._repository);

  final WorkoutsRepository _repository;

  /// Shared streams keyed by `userId:limit|all`.
  final Map<String, Stream<List<Workout>>> _watchCache = {};

  static const int defaultListLimit = 40;
  static const int metricsLimit = 120;
  static const int profileLimit = 40;

  Stream<List<Workout>> watchUserWorkouts(String userId, {int? limit}) {
    final key = '$userId:${limit ?? 'all'}';
    return _watchCache.putIfAbsent(
      key,
      () => _repository
          .watchUserWorkouts(userId, limit: limit)
          .asBroadcastStream(),
    );
  }

  /// Recent workouts for list UIs (history, cards).
  Stream<List<Workout>> watchUserWorkoutsList(String userId) =>
      watchUserWorkouts(userId, limit: defaultListLimit);

  /// Bounded history for home tiles / calendar metrics.
  Stream<List<Workout>> watchUserWorkoutsMetrics(String userId) =>
      watchUserWorkouts(userId, limit: metricsLimit);

  Future<Workout> createEmptyWorkout(
    String userId, {
    String name = 'Treino',
  }) async {
    final id = await _repository.createWorkout(userId, name);
    final workout = await _repository.getWorkout(id);
    return workout!;
  }

  Future<Workout> createWorkoutFromTemplate(
    WorkoutTemplate template, {
    String? userId,
  }) async {
    final uid = userId ?? template.userId;
    var workout = await createEmptyWorkout(uid, name: template.name);
    final exercises = template.exercises
        .map(
          (e) => Exercise(
            id: e.id,
            name: e.name,
            imageUrl: e.imageUrl,
            rest: e.rest,
            note: e.note,
            sets: e.sets
                .map(
                  (s) => WorkoutSet(
                    type: s.type,
                    reps: s.reps,
                    weight: s.weight,
                    completed: false,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
    workout = workout.copyWith(
      exercises: exercises,
      templateId: template.id,
    );
    await saveWorkout(workout);
    return workout;
  }

  Future<void> saveWorkout(Workout workout) => _repository.saveWorkout(workout);

  Future<void> deleteWorkout(String id) => _repository.deleteWorkout(id);

  Future<Workout> finishWorkout(Workout workout) async {
    final finished = workout.copyWith(
      finishedAt: DateTime.now(),
      volume: _calcVolume(workout),
    );
    await _repository.saveWorkout(finished);
    return finished;
  }

  int _calcVolume(Workout workout) {
    var total = 0;
    for (final exercise in workout.exercises) {
      for (final set in exercise.sets) {
        if (set.completed) {
          total += (set.reps * set.weight).round();
        }
      }
    }
    return total;
  }
}

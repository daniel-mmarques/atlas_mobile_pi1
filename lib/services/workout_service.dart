import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/workouts_repository.dart';
import 'package:flutter/foundation.dart';

class WorkoutService extends ChangeNotifier {
  WorkoutService(this._repository);

  final WorkoutsRepository _repository;

  Stream<List<Workout>> watchUserWorkouts(String userId) =>
      _repository.watchUserWorkouts(userId);

  Future<Workout> createEmptyWorkout(String userId, {String name = 'Treino'}) async {
    final id = await _repository.createWorkout(userId, name);
    final workout = await _repository.getWorkout(id);
    return workout!;
  }

  Future<void> saveWorkout(Workout workout) => _repository.saveWorkout(workout);

  Future<void> deleteWorkout(String id) => _repository.deleteWorkout(id);

  Future<Workout?> getWorkout(String id) => _repository.getWorkout(id);

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

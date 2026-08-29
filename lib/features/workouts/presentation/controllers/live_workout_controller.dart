import 'dart:async';

import 'package:atlas_mobile_pi1/features/feed/data/posts_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_set.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:flutter/foundation.dart';

class LiveWorkoutController extends ChangeNotifier {
  LiveWorkoutController({
    required Workout workout,
    required this.workoutService,
    required this.postsRepository,
    required this.authService,
  }) : workout = workout.copyWith(
          startedAt: workout.startedAt ?? DateTime.now(),
        ) {
    startTimer();
    unawaited(_persist());
  }

  Workout workout;
  final WorkoutService workoutService;
  final PostsRepository postsRepository;
  final AuthService authService;

  late DateTime _startTime;
  final ValueNotifier<Duration> elapsed = ValueNotifier(Duration.zero);
  Timer? _timer;
  bool _isSaving = false;

  bool get isSaving => _isSaving;

  void startTimer() {
    _startTime = workout.startedAt ?? DateTime.now();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsed.value = DateTime.now().difference(_startTime);
    });
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> _persist() async {
    try {
      await workoutService.saveWorkout(workout);
    } catch (e) {
      debugPrint('Error persisting workout: $e');
    }
  }

  void _updateSets(
    int exerciseIndex,
    List<WorkoutSet> Function(List<WorkoutSet>) updater,
  ) {
    final exercises = [...workout.exercises];
    final exercise = exercises[exerciseIndex];
    exercises[exerciseIndex] = exercise.copyWith(
      sets: updater([...exercise.sets]),
    );
    workout = workout.copyWith(exercises: exercises);
    notifyListeners();
    unawaited(_persist());
  }

  void updateWeight(int exerciseIndex, int setIndex, int weight) {
    _updateSets(exerciseIndex, (sets) {
      sets[setIndex] = sets[setIndex].copyWith(weight: weight.toDouble());
      return sets;
    });
  }

  void updateReps(int exerciseIndex, int setIndex, int reps) {
    _updateSets(exerciseIndex, (sets) {
      sets[setIndex] = sets[setIndex].copyWith(reps: reps);
      return sets;
    });
  }

  void toggleSet(int exerciseIndex, int setIndex) {
    _updateSets(exerciseIndex, (sets) {
      final set = sets[setIndex];
      sets[setIndex] = set.copyWith(completed: !set.completed);
      return sets;
    });
  }

  void addSet(int exerciseIndex) {
    _updateSets(exerciseIndex, (sets) {
      final last = sets.isNotEmpty ? sets.last : null;
      sets.add(
        WorkoutSet(
          reps: last?.reps ?? 10,
          weight: last?.weight ?? 20,
        ),
      );
      return sets;
    });
  }

  void removeSet(int exerciseIndex, int setIndex) {
    _updateSets(exerciseIndex, (sets) {
      if (setIndex < 0 || setIndex >= sets.length) return sets;
      sets.removeAt(setIndex);
      return sets;
    });
  }

  void addExercise({required String exerciseId, required String name}) {
    final exercises = [
      ...workout.exercises,
      Exercise(
        id: exerciseId,
        name: name,
        sets: const [
          WorkoutSet(reps: 10, weight: 20),
          WorkoutSet(reps: 10, weight: 20),
          WorkoutSet(reps: 10, weight: 20),
        ],
      ),
    ];
    workout = workout.copyWith(exercises: exercises);
    notifyListeners();
    unawaited(_persist());
  }

  String get totalVolume {
    var volume = 0;
    for (final e in workout.exercises) {
      for (final s in e.sets) {
        if (s.completed) volume += (s.weight * s.reps).round();
      }
    }
    return volume.toString();
  }

  String get totalSets {
    var count = 0;
    for (final exercise in workout.exercises) {
      for (final set in exercise.sets) {
        if (set.completed) count++;
      }
    }
    return count.toString();
  }

  Future<void> finishWorkout() async {
    if (_isSaving) return;
    _isSaving = true;
    _timer?.cancel();
    notifyListeners();

    try {
      final finished = await workoutService.finishWorkout(workout);
      workout = finished;

      final uid = authService.user?.uid;
      if (uid != null && finished.isPublic) {
        await postsRepository.createPostFromWorkout(
          userId: uid,
          userName: authService.appUser?.name ?? 'Atleta',
          workoutName: finished.name,
          volume: finished.volume,
          isPublic: true,
        );
      }
    } catch (e) {
      debugPrint('Error finishing workout: $e');
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> discardWorkout() async {
    _timer?.cancel();
    try {
      await workoutService.deleteWorkout(workout.id);
    } catch (e) {
      debugPrint('Error discarding workout: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    elapsed.dispose();
    super.dispose();
  }
}

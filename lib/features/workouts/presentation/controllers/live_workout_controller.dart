import 'dart:async';

import 'package:atlas_mobile_pi1/features/feed/data/posts_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_set.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/set_type.dart';
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
  Timer? _persistDebounce;
  bool _isSaving = false;
  bool _persistDirty = false;

  static const _persistDebounceDuration = Duration(milliseconds: 1200);

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
      _persistDirty = false;
    } catch (e) {
      debugPrint('Error persisting workout: $e');
    }
  }

  void _schedulePersist() {
    _persistDirty = true;
    _persistDebounce?.cancel();
    _persistDebounce = Timer(_persistDebounceDuration, () {
      unawaited(_persist());
    });
  }

  Future<void> _flushPersist() async {
    _persistDebounce?.cancel();
    if (_persistDirty) {
      await _persist();
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
    _schedulePersist();
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
    final sets = workout.exercises[exerciseIndex].sets;
    final wasCompleted = sets[setIndex].completed;
    _updateSets(exerciseIndex, (mutable) {
      final set = mutable[setIndex];
      mutable[setIndex] = set.copyWith(completed: !set.completed);
      return mutable;
    });
    final nowCompleted = !wasCompleted;
    if (nowCompleted) {
      final rest = workout.exercises[exerciseIndex].rest;
      if (rest.inSeconds > 0) {
        startRestTimer(rest, exerciseIndex: exerciseIndex);
      }
    }
  }

  final ValueNotifier<Duration?> restRemaining = ValueNotifier(null);
  final ValueNotifier<int?> restExerciseIndex = ValueNotifier(null);
  Timer? _restTimer;

  void startRestTimer(Duration rest, {required int exerciseIndex}) {
    _restTimer?.cancel();
    restExerciseIndex.value = exerciseIndex;
    restRemaining.value = rest;
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = restRemaining.value;
      if (current == null || current.inSeconds <= 1) {
        timer.cancel();
        restRemaining.value = null;
        restExerciseIndex.value = null;
        return;
      }
      restRemaining.value = Duration(seconds: current.inSeconds - 1);
    });
  }

  void clearRestTimer() {
    _restTimer?.cancel();
    restRemaining.value = null;
    restExerciseIndex.value = null;
  }

  void addSet(int exerciseIndex) {
    _updateSets(exerciseIndex, (sets) {
      final last = sets.isNotEmpty ? sets.last : null;
      sets.add(
        WorkoutSet(
          type: last?.type ?? SetType.work,
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
        sets: [
          WorkoutSet(reps: 10, weight: 20),
          WorkoutSet(reps: 10, weight: 20),
          WorkoutSet(reps: 10, weight: 20),
        ],
      ),
    ];
    workout = workout.copyWith(exercises: exercises);
    notifyListeners();
    _schedulePersist();
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
    clearRestTimer();
    notifyListeners();

    try {
      await _flushPersist();
      final finished = await workoutService.finishWorkout(workout);
      workout = finished;

      final uid = authService.user?.uid;
      if (uid != null && finished.isPublic) {
        await postsRepository.createPostFromWorkout(
          userId: uid,
          userName: authService.appUser?.name ?? 'Atleta',
          username: authService.appUser?.username ?? '',
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
    _persistDebounce?.cancel();
    _persistDirty = false;
    clearRestTimer();
    try {
      await workoutService.deleteWorkout(workout.id);
    } catch (e) {
      debugPrint('Error discarding workout: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    _persistDebounce?.cancel();
    if (_persistDirty) {
      unawaited(_persist());
    }
    elapsed.dispose();
    restRemaining.dispose();
    restExerciseIndex.dispose();
    super.dispose();
  }
}

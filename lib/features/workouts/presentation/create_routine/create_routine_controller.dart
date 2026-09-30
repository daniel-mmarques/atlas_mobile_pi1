import 'package:atlas_mobile_pi1/features/workouts/data/templates_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/catalog_exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_set.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/set_type.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/template_schedule_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum CreateRoutineStep { preset, name, schedule, builder }

class CreateRoutineController extends ChangeNotifier {
  CreateRoutineController({
    required TemplatesRepository templatesRepository,
    required this.userId,
    WorkoutTemplate? existing,
  }) : _templatesRepository = templatesRepository {
    if (existing != null) {
      _loadExisting(existing);
    } else {
      templateId = const Uuid().v4();
    }
  }

  final TemplatesRepository _templatesRepository;
  final String userId;
  late final String templateId;

  /// Aberto a partir de uma rotina salva (pula direto para o detalhamento).
  bool openedAsDetail = false;
  DateTime? _createdAt;

  CreateRoutineStep step = CreateRoutineStep.preset;
  String? selectedPreset;
  String name = '';
  /// Item na faixa de evidência no passo preset (controla a barra de progresso).
  bool presetInEvidence = false;
  TemplateScheduleMode scheduleMode = TemplateScheduleMode.none;
  final Set<int> weekdays = {};
  int restDaysBetween = 3;
  List<Exercise> exercises = [];
  String notes = '';
  Duration defaultRest = const Duration(seconds: 90);
  int? editingExerciseIndex;
  bool saving = false;

  static const presets = <String>[
    'Push',
    'Pull',
    'Full body',
    'Upper body',
    'Legs',
    'Glutes',
    'Back',
    'Chest',
    'Shoulders',
    'Bicep',
    'Tricep',
    'Core',
    'Abs',
    'Cardio',
    'Lower body',
  ];

  /// Descrições do footer no picker (EN, como no design de referência).
  static const presetDescriptions = <String, String>{
    'Push': 'Pushing weight away from the body',
    'Pull': 'Pulling weight toward the body',
    'Full body': 'Exercises for all major muscles',
    'Upper body': 'Chest, back, shoulders and arms',
    'Legs': 'Quads, hamstrings and calves',
    'Glutes': 'Focus on the hump 🍑',
    'Back': 'Lats, traps and rear delts',
    'Chest': 'Pressing and fly variations',
    'Shoulders': 'Delts and upper traps',
    'Bicep': 'Arm curls and elbow flexors',
    'Tricep': 'Pressdowns and extensions',
    'Core': 'Stability and trunk strength',
    'Abs': 'Core and midsection',
    'Cardio': 'Conditioning and endurance',
    'Lower body': 'Legs, glutes and hips',
  };

  double get progress {
    switch (step) {
      case CreateRoutineStep.preset:
        return presetInEvidence ? 0.2 : 0.0;
      case CreateRoutineStep.name:
        return 0.4;
      case CreateRoutineStep.schedule:
        return 0.6;
      case CreateRoutineStep.builder:
        return 1.0;
    }
  }

  String get filterHint =>
      selectedPreset ?? (name.trim().isEmpty ? 'all' : name.trim());

  bool get canContinueFromName => name.trim().isNotEmpty;

  bool get canContinueFromSchedule {
    switch (scheduleMode) {
      case TemplateScheduleMode.none:
        return true;
      case TemplateScheduleMode.weekdays:
        return weekdays.isNotEmpty;
      case TemplateScheduleMode.frequency:
        return restDaysBetween >= 0;
    }
  }

  bool get canStart => name.trim().isNotEmpty;

  void _loadExisting(WorkoutTemplate template) {
    templateId = template.id;
    openedAsDetail = true;
    _createdAt = template.createdAt;
    name = template.name;
    selectedPreset = null;
    scheduleMode = template.scheduleMode;
    weekdays
      ..clear()
      ..addAll(template.weekdays ?? const []);
    restDaysBetween = template.restDaysBetween ?? 3;
    notes = template.notes;
    defaultRest = template.defaultRest;
    exercises = template.exercises
        .map(
          (e) => e.copyWith(
            sets: e.sets.map((s) => s.copyWith()).toList(),
          ),
        )
        .toList();
    step = CreateRoutineStep.builder;
  }

  void setPresetInEvidence(bool value) {
    if (presetInEvidence == value) return;
    presetInEvidence = value;
    notifyListeners();
  }

  void selectPreset(String? preset) {
    selectedPreset = preset;
    name = preset ?? '';
    presetInEvidence = true;
    step = CreateRoutineStep.name;
    notifyListeners();
  }

  void updateName(String value) {
    final wasReady = canContinueFromName;
    name = value;
    if (wasReady != canContinueFromName) {
      notifyListeners();
    }
  }

  void goToSchedule() {
    if (!canContinueFromName) return;
    step = CreateRoutineStep.schedule;
    notifyListeners();
  }

  void setScheduleMode(TemplateScheduleMode mode) {
    scheduleMode = mode;
    notifyListeners();
  }

  void toggleWeekday(int day) {
    if (weekdays.contains(day)) {
      weekdays.remove(day);
    } else {
      weekdays.add(day);
    }
    notifyListeners();
  }

  void setRestDaysBetween(int days) {
    restDaysBetween = days.clamp(0, 14);
    notifyListeners();
  }

  void goToBuilder() {
    if (!canContinueFromSchedule) return;
    step = CreateRoutineStep.builder;
    notifyListeners();
  }

  void goToNameEdit() {
    step = CreateRoutineStep.name;
    notifyListeners();
  }

  void goToScheduleEdit() {
    step = CreateRoutineStep.schedule;
    notifyListeners();
  }

  void goBack() {
    if (step == CreateRoutineStep.name) {
      if (openedAsDetail) {
        step = CreateRoutineStep.builder;
      } else {
        step = CreateRoutineStep.preset;
        presetInEvidence = false;
      }
    } else if (step == CreateRoutineStep.schedule) {
      step = openedAsDetail
          ? CreateRoutineStep.builder
          : CreateRoutineStep.name;
    } else if (step == CreateRoutineStep.builder) {
      step = CreateRoutineStep.schedule;
    }
    notifyListeners();
  }

  Future<void> deleteRoutine() => _templatesRepository.delete(templateId);

  void openExercise(int index) {
    if (index < 0 || index >= exercises.length) return;
    editingExerciseIndex = index;
    notifyListeners();
  }

  void closeExercise() {
    if (editingExerciseIndex == null) return;
    editingExerciseIndex = null;
    notifyListeners();
  }

  void updateNotes(String value) {
    notes = value;
    notifyListeners();
  }

  void setDefaultRest(Duration rest, {bool applyToAll = true}) {
    defaultRest = rest;
    if (applyToAll) {
      exercises = [
        for (final e in exercises) e.copyWith(rest: rest),
      ];
    }
    notifyListeners();
  }

  void updateExerciseNote(int exerciseIndex, String note) {
    final next = [...exercises];
    next[exerciseIndex] = next[exerciseIndex].copyWith(note: note);
    exercises = next;
    notifyListeners();
  }

  void addExercises(List<CatalogExercise> items) {
    final next = [...exercises];
    for (final item in items) {
      if (next.any((e) => e.id == item.id)) continue;
      next.add(
        Exercise(
          id: item.id,
          name: item.name,
          imageUrl: item.imageUrl,
          videoUrl: item.videoUrl,
          bodyPart: item.primaryBodyPart,
          target: item.primaryTarget,
          equipment: item.primaryEquipment,
          rest: defaultRest,
          note: '',
          sets: [
            WorkoutSet(type: SetType.work, weight: 0, reps: 0),
          ],
        ),
      );
    }
    exercises = next;
    notifyListeners();
  }

  void removeExercise(int index) {
    final next = [...exercises]..removeAt(index);
    exercises = next;
    if (editingExerciseIndex != null) {
      if (editingExerciseIndex == index) {
        editingExerciseIndex = null;
      } else if (editingExerciseIndex! > index) {
        editingExerciseIndex = editingExerciseIndex! - 1;
      }
    }
    notifyListeners();
  }

  void reorderExercises(int oldIndex, int newIndex) {
    var to = newIndex;
    if (to > oldIndex) to -= 1;
    if (oldIndex == to) return;
    final next = [...exercises];
    final item = next.removeAt(oldIndex);
    next.insert(to, item);
    exercises = next;
    if (editingExerciseIndex != null) {
      final editing = editingExerciseIndex!;
      if (editing == oldIndex) {
        editingExerciseIndex = to;
      } else if (oldIndex < editing && editing <= to) {
        editingExerciseIndex = editing - 1;
      } else if (to <= editing && editing < oldIndex) {
        editingExerciseIndex = editing + 1;
      }
    }
    notifyListeners();
  }

  void addSet(int exerciseIndex) {
    _updateSets(exerciseIndex, (sets) {
      sets.add(WorkoutSet(type: SetType.work, weight: 0, reps: 0));
      return sets;
    });
  }

  void removeSet(int exerciseIndex, int setIndex) {
    _updateSets(exerciseIndex, (sets) {
      if (sets.length <= 1) return sets;
      sets.removeAt(setIndex);
      return sets;
    });
  }

  void reorderSets(int exerciseIndex, int oldIndex, int newIndex) {
    _updateSets(exerciseIndex, (sets) {
      var to = newIndex;
      if (to > oldIndex) to -= 1;
      final item = sets.removeAt(oldIndex);
      sets.insert(to, item);
      return sets;
    });
  }

  void updateSetType(int exerciseIndex, int setIndex, SetType type) {
    _updateSets(exerciseIndex, (sets) {
      sets[setIndex] = sets[setIndex].copyWith(type: type);
      return sets;
    });
  }

  void updateWeight(int exerciseIndex, int setIndex, double weight) {
    _updateSets(exerciseIndex, (sets) {
      sets[setIndex] = sets[setIndex].copyWith(weight: weight);
      return sets;
    });
  }

  void updateReps(int exerciseIndex, int setIndex, int reps) {
    _updateSets(exerciseIndex, (sets) {
      sets[setIndex] = sets[setIndex].copyWith(reps: reps);
      return sets;
    });
  }

  void updateIntensity(int exerciseIndex, int setIndex, int? intensity) {
    _updateSets(exerciseIndex, (sets) {
      sets[setIndex] = intensity == null
          ? sets[setIndex].copyWith(clearIntensity: true)
          : sets[setIndex].copyWith(intensity: intensity);
      return sets;
    });
  }

  void updateRest(int exerciseIndex, Duration rest) {
    final next = [...exercises];
    next[exerciseIndex] = next[exerciseIndex].copyWith(rest: rest);
    exercises = next;
    notifyListeners();
  }

  void _updateSets(
    int exerciseIndex,
    List<WorkoutSet> Function(List<WorkoutSet>) updater,
  ) {
    final next = [...exercises];
    final exercise = next[exerciseIndex];
    next[exerciseIndex] = exercise.copyWith(sets: updater([...exercise.sets]));
    exercises = next;
    notifyListeners();
  }

  WorkoutTemplate buildTemplate() {
    final now = DateTime.now();
    final trimmed = name.trim();
    return WorkoutTemplate(
      id: templateId,
      userId: userId,
      name: trimmed,
      exercises: exercises,
      notes: notes,
      defaultRestSeconds: defaultRest.inSeconds,
      createdAt: _createdAt ?? now,
      updatedAt: now,
      scheduleMode: scheduleMode,
      weekdays: scheduleMode == TemplateScheduleMode.weekdays
          ? (weekdays.toList()..sort())
          : null,
      restDaysBetween: scheduleMode == TemplateScheduleMode.frequency
          ? restDaysBetween
          : null,
    );
  }

  Future<WorkoutTemplate?> save() async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;
    saving = true;
    notifyListeners();
    try {
      final template = buildTemplate();
      await _templatesRepository.save(template);
      return template;
    } finally {
      saving = false;
      notifyListeners();
    }
  }
}

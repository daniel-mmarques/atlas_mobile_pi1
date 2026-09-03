import 'package:atlas_mobile_pi1/features/workouts/data/templates_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/template_schedule_mode.dart';
import 'package:uuid/uuid.dart';

/// Cria ou atualiza uma rotina a partir dos exercícios de um treino finalizado.
Future<WorkoutTemplate?> upsertRoutineFromWorkout({
  required Workout workout,
  required TemplatesRepository templates,
  bool createIfMissing = false,
}) async {
  if (workout.exercises.isEmpty) return null;

  final cleanExercises = workout.exercises
      .map(
        (e) => e.copyWith(
          sets: e.sets.map((s) => s.copyWith(completed: false)).toList(),
        ),
      )
      .toList();

  final templateId = workout.templateId;
  if (templateId != null && templateId.isNotEmpty) {
    final existing = await templates.getById(templateId);
    final now = DateTime.now();
    final template = (existing ??
            WorkoutTemplate(
              id: templateId,
              userId: workout.userId,
              name: workout.name,
              scheduleMode: TemplateScheduleMode.none,
              createdAt: now,
            ))
        .copyWith(
          name: workout.name.trim().isEmpty
              ? (existing?.name ?? workout.name)
              : workout.name,
          exercises: cleanExercises,
          updatedAt: now,
        );
    await templates.save(template);
    return template;
  }

  if (!createIfMissing) return null;

  final now = DateTime.now();
  final template = WorkoutTemplate(
    id: const Uuid().v4(),
    userId: workout.userId,
    name: workout.name.trim().isEmpty ? 'Routine' : workout.name.trim(),
    exercises: cleanExercises,
    scheduleMode: TemplateScheduleMode.none,
    createdAt: now,
    updatedAt: now,
  );
  await templates.save(template);
  return template;
}

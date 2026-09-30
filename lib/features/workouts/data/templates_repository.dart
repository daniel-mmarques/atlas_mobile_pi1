import 'package:atlas_mobile_pi1/core/dataconnect/dc_helpers.dart';
import 'package:atlas_mobile_pi1/dataconnect_generated/atlas.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_template.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/template_schedule_mode.dart';
import 'package:uuid/uuid.dart';

export 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_template.dart';

abstract class TemplatesRepository {
  Stream<List<WorkoutTemplate>> watchUserTemplates(String userId);
  Future<WorkoutTemplate?> getById(String id);
  Future<String> save(WorkoutTemplate template);
  Future<void> delete(String id);
}

class TemplatesRepositoryImpl implements TemplatesRepository {
  TemplatesRepositoryImpl({AtlasConnector? connector})
      : _dc = connector ?? AtlasConnector.instance;

  final AtlasConnector _dc;
  static const _uuid = Uuid();

  WorkoutTemplate _map({
    required String id,
    required String userId,
    required String name,
    required dynamic exercisesJson,
    required String notes,
    required int defaultRestSeconds,
    required String scheduleMode,
    required dynamic weekdaysJson,
    int? restDaysBetween,
    required dynamic createdAt,
    required dynamic updatedAt,
  }) {
    return WorkoutTemplate(
      id: id,
      userId: userId,
      name: name,
      exercises: exercisesFromAny(exercisesJson),
      notes: notes,
      defaultRestSeconds: defaultRestSeconds,
      scheduleMode: TemplateScheduleMode.fromJson(scheduleMode),
      weekdays: weekdaysFromAny(weekdaysJson),
      restDaysBetween: restDaysBetween,
      createdAt: fromDcTimestamp(createdAt),
      updatedAt: fromDcTimestamp(updatedAt),
    );
  }

  @override
  Stream<List<WorkoutTemplate>> watchUserTemplates(String userId) {
    return subscribeMapped(
      () => _dc.listUserTemplates(userId: userId).ref(),
      (ListUserTemplatesData data) => data.templates
          .map(
            (t) => _map(
              id: t.id,
              userId: t.user.id,
              name: t.name,
              exercisesJson: t.exercisesJson,
              notes: t.notes,
              defaultRestSeconds: t.defaultRestSeconds,
              scheduleMode: t.scheduleMode,
              weekdaysJson: t.weekdaysJson,
              restDaysBetween: t.restDaysBetween,
              createdAt: t.createdAt,
              updatedAt: t.updatedAt,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<WorkoutTemplate?> getById(String id) async {
    final result = await _dc.getTemplate(id: id).execute();
    final t = result.data.template;
    if (t == null) return null;
    return _map(
      id: t.id,
      userId: t.user.id,
      name: t.name,
      exercisesJson: t.exercisesJson,
      notes: t.notes,
      defaultRestSeconds: t.defaultRestSeconds,
      scheduleMode: t.scheduleMode,
      weekdaysJson: t.weekdaysJson,
      restDaysBetween: t.restDaysBetween,
      createdAt: t.createdAt,
      updatedAt: t.updatedAt,
    );
  }

  @override
  Future<String> save(WorkoutTemplate template) async {
    final id = template.id.isEmpty ? _uuid.v4() : template.id;
    final now = DateTime.now();
    final createdAt = template.createdAt ?? now;
    await _dc
        .upsertTemplate(
          id: id,
          userId: template.userId,
          name: template.name,
          notes: template.notes,
          defaultRestSeconds: template.defaultRestSeconds,
          scheduleMode: template.scheduleMode.toJson(),
          createdAt: toDcTimestamp(createdAt),
          updatedAt: toDcTimestamp(now),
        )
        .exercisesJson(exercisesToAny(template.exercises))
        .weekdaysJson(
          template.scheduleMode == TemplateScheduleMode.weekdays
              ? weekdaysToAny(template.weekdays)
              : null,
        )
        .restDaysBetween(
          template.scheduleMode == TemplateScheduleMode.frequency
              ? template.restDaysBetween
              : null,
        )
        .execute();
    return id;
  }

  @override
  Future<void> delete(String id) async {
    await _dc.deleteTemplate(id: id).execute();
  }
}

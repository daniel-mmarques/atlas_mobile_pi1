import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_template.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/template_schedule_mode.dart';

/// Projeta dias de treino a partir da periodicidade do template (sem criar docs).
class TemplateSchedule {
  TemplateSchedule._();

  /// Índice 0=Domingo … 6=Sábado (alinhado ao UI / `DateTime.weekday % 7`).
  static bool occursOn(WorkoutTemplate template, DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    switch (template.scheduleMode) {
      case TemplateScheduleMode.none:
        return false;
      case TemplateScheduleMode.weekdays:
        final days = template.weekdays ?? const [];
        if (days.isEmpty) return false;
        return days.contains(date.weekday % 7);
      case TemplateScheduleMode.frequency:
        final rest = template.restDaysBetween ?? 0;
        final created = template.createdAt;
        if (created == null) return false;
        final anchor = DateTime(created.year, created.month, created.day);
        if (date.isBefore(anchor)) return false;
        final period = rest + 1;
        if (period <= 0) return false;
        return date.difference(anchor).inDays % period == 0;
    }
  }

  static Set<DateTime> plannedDaysInRange({
    required List<WorkoutTemplate> templates,
    required DateTime rangeStart,
    required DateTime rangeEnd,
    Set<String> excludeTemplateDays = const {},
  }) {
    final start = DateTime(rangeStart.year, rangeStart.month, rangeStart.day);
    final end = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);
    final result = <DateTime>{};

    for (final template in templates) {
      if (template.scheduleMode == TemplateScheduleMode.none) continue;
      var cursor = start;
      while (!cursor.isAfter(end)) {
        if (occursOn(template, cursor)) {
          final key = '${template.id}|${cursor.toIso8601String()}';
          if (!excludeTemplateDays.contains(key)) {
            result.add(cursor);
          }
        }
        cursor = cursor.add(const Duration(days: 1));
      }
    }
    return result;
  }

  static List<WorkoutTemplate> templatesOnDay(
    List<WorkoutTemplate> templates,
    DateTime day,
  ) {
    return templates
        .where((t) => occursOn(t, day))
        .toList(growable: false);
  }

  static String dayKey(String templateId, DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return '$templateId|${d.toIso8601String()}';
  }
}

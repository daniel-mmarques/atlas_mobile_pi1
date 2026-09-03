import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/templates_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/template_schedule.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/widgets/shell_page_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarHistoryPage extends StatefulWidget {
  const CalendarHistoryPage({super.key});

  @override
  State<CalendarHistoryPage> createState() => _CalendarHistoryPageState();
}

class _CalendarHistoryPageState extends State<CalendarHistoryPage> {
  static const _weekHeight = 52.0;
  static const _monthsBack = 24;
  static const _monthsForward = 24;

  late final List<_CalendarWeek> _weeks;
  late final ScrollController _scrollController;
  late DateTime _selectedDay;
  late DateTime _titleMonth;
  late int _initialWeekIndex;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _titleMonth = DateTime(now.year, now.month);
    _weeks = _buildWeeks(now);
    // First week that contains day 1 of the current month → month starts at top.
    _initialWeekIndex = _weeks.indexWhere(
      (week) => week.days.any(
        (d) => d.year == now.year && d.month == now.month && d.day == 1,
      ),
    );
    if (_initialWeekIndex < 0) {
      _initialWeekIndex = _weeks.indexWhere(
        (week) => week.days.any((d) => _isSameDay(d, _selectedDay)),
      );
    }
    if (_initialWeekIndex < 0) _initialWeekIndex = 0;

    _scrollController = ScrollController(
      initialScrollOffset: _initialWeekIndex * _weekHeight,
    );
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTitleMonthFromViewport();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  List<_CalendarWeek> _buildWeeks(DateTime now) {
    final rangeStart = DateTime(now.year, now.month - _monthsBack, 1);
    final rangeEnd = DateTime(now.year, now.month + _monthsForward + 1, 0);

    var cursor = rangeStart.subtract(Duration(days: rangeStart.weekday % 7));
    final lastSunday = rangeEnd.subtract(Duration(days: rangeEnd.weekday % 7));

    final weeks = <_CalendarWeek>[];
    while (!cursor.isAfter(lastSunday)) {
      final days = List.generate(7, (i) => cursor.add(Duration(days: i)));
      weeks.add(_CalendarWeek(days: days));
      cursor = cursor.add(const Duration(days: 7));
    }
    return weeks;
  }

  void _onScroll() => _updateTitleMonthFromViewport();

  /// Mês em evidência = o que tem mais dias visíveis na viewport (peso pela
  /// fração da semana que está na tela).
  void _updateTitleMonthFromViewport() {
    if (!_scrollController.hasClients || _weeks.isEmpty) return;

    final position = _scrollController.position;
    final offset = position.pixels;
    final viewport = position.viewportDimension;
    if (viewport <= 0) return;

    final scores = <String, double>{};

    final firstIndex =
        (offset / _weekHeight).floor().clamp(0, _weeks.length - 1);
    final lastIndex = ((offset + viewport) / _weekHeight)
        .ceil()
        .clamp(1, _weeks.length);

    for (var i = firstIndex; i < lastIndex; i++) {
      final weekTop = i * _weekHeight;
      final weekBottom = weekTop + _weekHeight;
      final visibleTop = offset > weekTop ? offset : weekTop;
      final visibleBottom =
          (offset + viewport) < weekBottom ? (offset + viewport) : weekBottom;
      final visibleHeight = visibleBottom - visibleTop;
      if (visibleHeight <= 0) continue;

      final fraction = (visibleHeight / _weekHeight).clamp(0.0, 1.0);
      for (final day in _weeks[i].days) {
        final key = '${day.year}-${day.month}';
        scores[key] = (scores[key] ?? 0) + fraction;
      }
    }

    if (scores.isEmpty) return;

    var bestKey = scores.keys.first;
    var bestScore = scores[bestKey]!;
    for (final entry in scores.entries) {
      if (entry.value > bestScore) {
        bestKey = entry.key;
        bestScore = entry.value;
      }
    }

    final parts = bestKey.split('-');
    final month = DateTime(int.parse(parts[0]), int.parse(parts[1]));
    if (month.year != _titleMonth.year || month.month != _titleMonth.month) {
      setState(() => _titleMonth = month);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime? _workoutDay(Workout workout) {
    final date = workout.finishedAt ?? workout.startedAt;
    if (date == null) return null;
    return DateTime(date.year, date.month, date.day);
  }

  /// Dias com treino concluído (bolinha viva).
  Set<DateTime> _doneDays(List<Workout> workouts) {
    return workouts
        .where((w) => w.finishedAt != null)
        .map(_workoutDay)
        .whereType<DateTime>()
        .toSet();
  }

  /// Dias com treino previsto / não concluído (bolinha translúcida).
  Set<DateTime> _openWorkoutDays(List<Workout> workouts) {
    return workouts
        .where((w) => w.finishedAt == null && w.startedAt != null)
        .map(_workoutDay)
        .whereType<DateTime>()
        .toSet();
  }

  Set<String> _doneTemplateDayKeys(List<Workout> workouts) {
    final keys = <String>{};
    for (final w in workouts) {
      if (w.finishedAt == null || w.templateId == null) continue;
      final day = _workoutDay(w);
      if (day == null) continue;
      keys.add(TemplateSchedule.dayKey(w.templateId!, day));
    }
    return keys;
  }

  Set<DateTime> _projectedTemplateDays(
    List<WorkoutTemplate> templates,
    Set<String> excludeKeys,
  ) {
    if (_weeks.isEmpty) return {};
    final rangeStart = _weeks.first.days.first;
    final rangeEnd = _weeks.last.days.last;
    return TemplateSchedule.plannedDaysInRange(
      templates: templates,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      excludeTemplateDays: excludeKeys,
    );
  }

  List<Workout> _workoutsOnDay(List<Workout> workouts, DateTime day) {
    return workouts.where((w) {
      final d = _workoutDay(w);
      return d != null && _isSameDay(d, day);
    }).toList();
  }

  List<WorkoutTemplate> _scheduledTemplatesOnDay(
    List<WorkoutTemplate> templates,
    List<Workout> workouts,
    DateTime day,
  ) {
    final exclude = _doneTemplateDayKeys(workouts);
    return TemplateSchedule.templatesOnDay(templates, day).where((t) {
      return !exclude.contains(TemplateSchedule.dayKey(t.id, day));
    }).toList();
  }

  String _monthTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final raw = DateFormat('MMMM', locale).format(_titleMonth);
    if (raw.isEmpty) return raw;
    return raw[0].toUpperCase() + raw.substring(1);
  }

  String _selectedDayLabel(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final raw = DateFormat('EEEE, d MMM', locale).format(_selectedDay);
    if (raw.isEmpty) return raw;
    return raw[0].toUpperCase() + raw.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthService>().user?.uid;
    final workoutService = context.read<WorkoutService>();
    final selectedBg = AppColors.textPrimary(context);
    final selectedFg = AppColors.surface(context);
    final bottomLimit =
        AppSpacing.shellBottomInset + MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShellPageHeader(title: _monthTitle(context)),
            Expanded(
              child: userId == null
                  ? Center(child: Text(context.l10n.calendarLoginRequired))
                  : Padding(
                      padding: EdgeInsets.only(bottom: bottomLimit),
                      child: StreamBuilder<List<Workout>>(
                        stream: workoutService.watchUserWorkoutsMetrics(userId),
                        builder: (context, workoutSnap) {
                          final workouts = workoutSnap.data ?? [];
                          return StreamBuilder<List<WorkoutTemplate>>(
                            stream: context
                                .read<TemplatesRepository>()
                                .watchUserTemplates(userId),
                            builder: (context, templateSnap) {
                              final templates = templateSnap.data ?? [];
                              final doneDays = _doneDays(workouts);
                              final excludeKeys =
                                  _doneTemplateDayKeys(workouts);
                              final plannedDays = {
                                ..._openWorkoutDays(workouts),
                                ..._projectedTemplateDays(
                                  templates,
                                  excludeKeys,
                                ),
                              };
                              final dayItems =
                                  _workoutsOnDay(workouts, _selectedDay);
                              final scheduledTemplates =
                                  _scheduledTemplatesOnDay(
                                templates,
                                workouts,
                                _selectedDay,
                              );

                              return Column(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      children: [
                                        const _WeekdayHeader(),
                                        Expanded(
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            itemExtent: _weekHeight,
                                            padding: EdgeInsets.zero,
                                            itemCount: _weeks.length,
                                            itemBuilder: (context, index) {
                                              final week = _weeks[index];
                                              return _WeekRow(
                                                week: week,
                                                selectedDay: _selectedDay,
                                                titleMonth: _titleMonth,
                                                doneDays: doneDays,
                                                plannedDays: plannedDays,
                                                selectedBg: selectedBg,
                                                selectedFg: selectedFg,
                                                onSelect: (day) {
                                                  setState(
                                                    () => _selectedDay = day,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: AppColors.border(context)
                                        .withValues(alpha: 0.4),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: _DayWorkoutsPanel(
                                      dayLabel: _selectedDayLabel(context),
                                      workouts: dayItems,
                                      scheduledTemplates: scheduledTemplates,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarWeek {
  const _CalendarWeek({required this.days});

  final List<DateTime> days;
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    // 2023-01-01 was a Sunday.
    final labels = List.generate(7, (i) {
      final day = DateTime(2023, 1, 1 + i);
      return DateFormat.E(locale).format(day);
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        4,
        AppSpacing.pageHorizontal,
        8,
      ),
      child: Row(
        children: labels
            .map(
              (label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow({
    required this.week,
    required this.selectedDay,
    required this.titleMonth,
    required this.doneDays,
    required this.plannedDays,
    required this.selectedBg,
    required this.selectedFg,
    required this.onSelect,
  });

  final _CalendarWeek week;
  final DateTime selectedDay;
  final DateTime titleMonth;
  final Set<DateTime> doneDays;
  final Set<DateTime> plannedDays;
  final Color selectedBg;
  final Color selectedFg;
  final ValueChanged<DateTime> onSelect;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _hasDone(DateTime day) => doneDays.any((d) => _isSameDay(d, day));

  bool _hasPlanned(DateTime day) =>
      plannedDays.any((d) => _isSameDay(d, day));

  bool _isInTitleMonth(DateTime day) =>
      day.year == titleMonth.year && day.month == titleMonth.month;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal,
            ),
            child: Row(
              children: week.days.map((day) {
                final selected = _isSameDay(day, selectedDay);
                final inMonth = _isInTitleMonth(day);
                final isMonthStart = day.day == 1;
                final locale = Localizations.localeOf(context).toString();
                final label = isMonthStart
                    ? DateFormat('MMM d', locale).format(day)
                    : '${day.day}';
                final done = _hasDone(day);
                final planned = _hasPlanned(day);
                final outOfMonthOpacity = inMonth ? 1.0 : 0.32;

                final numberColor = selected
                    ? selectedFg
                    : AppColors.textPrimary(context)
                        .withValues(alpha: outOfMonthOpacity);

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelect(day),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            constraints: const BoxConstraints(minWidth: 36),
                            padding: EdgeInsets.symmetric(
                              horizontal: isMonthStart ? 8 : 0,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  selected ? selectedBg : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMonthStart ? 14 : 18,
                                fontWeight: FontWeight.w600,
                                color: numberColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          SizedBox(
                            height: 6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (done)
                                  _DayDot(
                                    color: selected
                                        ? selectedFg
                                        : AppColors.accentOf(context),
                                    opacity: selected
                                        ? 1
                                        : outOfMonthOpacity,
                                  ),
                                if (done && planned)
                                  const SizedBox(width: 3),
                                if (planned)
                                  _DayDot(
                                    color: selected
                                        ? selectedFg
                                        : AppColors.accentOf(context),
                                    opacity: selected
                                        ? 0.45
                                        : 0.35 * outOfMonthOpacity,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppColors.border(context).withValues(alpha: 0.35),
        ),
      ],
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.color, required this.opacity});

  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _DayWorkoutsPanel extends StatelessWidget {
  const _DayWorkoutsPanel({
    required this.dayLabel,
    required this.workouts,
    required this.scheduledTemplates,
  });

  final String dayLabel;
  final List<Workout> workouts;
  final List<WorkoutTemplate> scheduledTemplates;

  @override
  Widget build(BuildContext context) {
    final isEmpty = workouts.isEmpty && scheduledTemplates.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.md,
            AppSpacing.pageHorizontal,
            AppSpacing.sm,
          ),
          child: Text(
            dayLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      context.l10n.calendarEmptyDay,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    0,
                    AppSpacing.pageHorizontal,
                    AppSpacing.lg,
                  ),
                  children: [
                    for (final workout in workouts) ...[
                      _DayWorkoutTile(workout: workout),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    for (final template in scheduledTemplates) ...[
                      _DayScheduledTemplateTile(template: template),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _DayScheduledTemplateTile extends StatelessWidget {
  const _DayScheduledTemplateTile({required this.template});

  final WorkoutTemplate template;

  Future<void> _start(BuildContext context) async {
    final workout = await context
        .read<WorkoutService>()
        .createWorkoutFromTemplate(template);
    if (!context.mounted) return;
    context.push(AppRoutes.workoutSession(workout.id), extra: workout);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _start(context),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(
                Icons.event_available_rounded,
                color: AppColors.accentOf(context),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        l10n.calendarScheduledRoutine,
                        l10n.workoutsExerciseCount(template.exercises.length),
                      ].join(' · '),
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_arrow_rounded,
                color: AppColors.textSecondary(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayWorkoutTile extends StatelessWidget {
  const _DayWorkoutTile({required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final time = workout.finishedAt ?? workout.startedAt;
    final locale = Localizations.localeOf(context).toString();
    final timeLabel =
        time == null ? '' : DateFormat('HH:mm', locale).format(time);
    final isDone = workout.finishedAt != null;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () =>
            context.push(AppRoutes.workoutDetails(workout.id), extra: workout),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(
                isDone
                    ? Icons.check_circle_rounded
                    : Icons.event_available_rounded,
                color: AppColors.accentOf(context),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (timeLabel.isNotEmpty) timeLabel,
                        isDone ? l10n.calendarDone : l10n.calendarPlanned,
                        l10n.workoutsExerciseCount(workout.exerciseCount),
                      ].join(' · '),
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
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
  static const _weekHeight = 64.0;
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
    _initialWeekIndex = _weeks.indexWhere(
      (week) => week.days.any((d) => _isSameDay(d, _selectedDay)),
    );
    if (_initialWeekIndex < 0) _initialWeekIndex = 0;

    _scrollController = ScrollController(
      initialScrollOffset: _initialWeekIndex * _weekHeight,
    );
    _scrollController.addListener(_onScroll);
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

  void _onScroll() {
    if (!_scrollController.hasClients || _weeks.isEmpty) return;

    final index = (_scrollController.offset / _weekHeight).floor().clamp(
      0,
      _weeks.length - 1,
    );
    final anchor = _weeks[index].days.first;
    final month = DateTime(anchor.year, anchor.month);
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

  Set<DateTime> _markedDays(List<Workout> workouts) {
    return workouts.map(_workoutDay).whereType<DateTime>().toSet();
  }

  List<Workout> _workoutsOnDay(List<Workout> workouts, DateTime day) {
    return workouts.where((w) {
      final d = _workoutDay(w);
      return d != null && _isSameDay(d, day);
    }).toList();
  }

  String get _monthTitle {
    final raw = DateFormat('MMMM').format(_titleMonth);
    if (raw.isEmpty) return raw;
    return raw[0].toUpperCase() + raw.substring(1);
  }

  void _showDaySheet(
    BuildContext context,
    DateTime day,
    List<Workout> workouts,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isFuture = day.isAfter(today);

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border(context),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  DateFormat('EEEE, d MMM').format(day),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                if (workouts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      isFuture
                          ? 'Nenhum treino agendado para este dia.'
                          : 'Nenhum treino registrado neste dia.',
                      style: TextStyle(color: AppColors.textSecondary(context)),
                    ),
                  )
                else
                  ...workouts.map(
                    (workout) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _DayWorkoutTile(workout: workout),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthService>().user?.uid;
    final workoutService = context.read<WorkoutService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedBg = isDark ? Colors.white : AppColors.lightTextPrimary;
    final selectedFg = isDark ? Colors.black : Colors.white;
    final bottomLimit =
        AppSpacing.navHeight +
        AppSpacing.sm +
        MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShellPageHeader(title: _monthTitle),
            Expanded(
              child: userId == null
                  ? const Center(child: Text('Faça login para ver o histórico.'))
                  : Padding(
                      padding: EdgeInsets.only(bottom: bottomLimit),
                      child: StreamBuilder<List<Workout>>(
                        stream: workoutService.watchUserWorkouts(userId),
                        builder: (context, snapshot) {
                          final workouts = snapshot.data ?? [];
                          final marked = _markedDays(workouts);

                          return Column(
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
                                      markedDays: marked,
                                      selectedBg: selectedBg,
                                      selectedFg: selectedFg,
                                      onSelect: (day) {
                                        setState(() => _selectedDay = day);
                                        final dayItems = _workoutsOnDay(
                                          workouts,
                                          day,
                                        );
                                        if (dayItems.isNotEmpty) {
                                          _showDaySheet(
                                            context,
                                            day,
                                            dayItems,
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
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

  static const _labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        4,
        AppSpacing.pageHorizontal,
        8,
      ),
      child: Row(
        children: _labels
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
    required this.markedDays,
    required this.selectedBg,
    required this.selectedFg,
    required this.onSelect,
  });

  final _CalendarWeek week;
  final DateTime selectedDay;
  final Set<DateTime> markedDays;
  final Color selectedBg;
  final Color selectedFg;
  final ValueChanged<DateTime> onSelect;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isMarked(DateTime day) => markedDays.any((d) => _isSameDay(d, day));

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
                final isMonthStart = day.day == 1;
                final label = isMonthStart
                    ? DateFormat('MMM d').format(day)
                    : '${day.day}';

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
                              color: selected ? selectedBg : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMonthStart ? 13 : 16,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? selectedFg
                                    : AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          SizedBox(
                            height: 5,
                            child: _isMarked(day)
                                ? Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? selectedFg
                                          : AppColors.accent,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
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

class _DayWorkoutTile extends StatelessWidget {
  const _DayWorkoutTile({required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final time = workout.finishedAt ?? workout.startedAt;
    final timeLabel = time == null ? '' : DateFormat('HH:mm').format(time);
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
                isDone ? Icons.check_rounded : Icons.fitness_center_rounded,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  [
                    workout.name,
                    if (timeLabel.isNotEmpty) timeLabel,
                  ].join(' · '),
                  style: const TextStyle(fontWeight: FontWeight.w600),
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

import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/template_schedule_mode.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/create_routine_controller.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/create_routine_chrome.dart';
import 'package:atlas_mobile_pi1/ui/widgets/magnet_snap_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScheduleStep extends StatelessWidget {
  const ScheduleStep({super.key});

  static const double _topInsetFraction = 0.30;
  static const double _topInsetMax = 180;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateRoutineController>();
    final l10n = context.l10n;
    final name = controller.name.trim().isEmpty
        ? l10n.routineScheduleThis
        : controller.name.trim().toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topInset = (constraints.maxHeight * _topInsetFraction)
                  .clamp(AppSpacing.sectionGap, _topInsetMax);
              return Padding(
                padding: EdgeInsets.only(top: topInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sheetPaddingH),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TabLabel(
                              label: l10n.routineScheduleNone,
                              selected: controller.scheduleMode ==
                                  TemplateScheduleMode.none,
                              onTap: () => controller.setScheduleMode(
                                TemplateScheduleMode.none,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _TabLabel(
                              label: l10n.routineScheduleWeekdays,
                              selected: controller.scheduleMode ==
                                  TemplateScheduleMode.weekdays,
                              onTap: () => controller.setScheduleMode(
                                TemplateScheduleMode.weekdays,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _TabLabel(
                              label: l10n.routineScheduleFrequency,
                              selected: controller.scheduleMode ==
                                  TemplateScheduleMode.frequency,
                              onTap: () => controller.setScheduleMode(
                                TemplateScheduleMode.frequency,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: switch (controller.scheduleMode) {
                            TemplateScheduleMode.none => const _NoneBody(),
                            TemplateScheduleMode.weekdays => _WeekdaysBody(
                                name: name,
                                selected: controller.weekdays,
                                onToggle: controller.toggleWeekday,
                              ),
                            TemplateScheduleMode.frequency => _FrequencyBody(
                                name: name,
                                restDays: controller.restDaysBetween,
                                onChanged: controller.setRestDaysBetween,
                              ),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.sm,
            AppSpacing.sheetPaddingH,
            AppSpacing.sheetPaddingB,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.38,
              child: CreateRoutineContinueButton(
                enabled: controller.canContinueFromSchedule,
                label: l10n.continueAction,
                onPressed: controller.goToBuilder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final border = AppColors.border(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? primary : secondary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: selected ? primary : border.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoneBody extends StatelessWidget {
  const _NoneBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sheetPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.routineScheduleNoneTitle,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 18,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.routineScheduleNoneBody,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdaysBody extends StatelessWidget {
  const _WeekdaysBody({
    required this.name,
    required this.selected,
    required this.onToggle,
  });

  final String name;
  final Set<int> selected;
  final ValueChanged<int> onToggle;

  static const _dayOrder = [0, 1, 2, 3, 4, 5, 6];

  String _shortDay(BuildContext context, int index) {
    // 2024-01-07 was a Sunday.
    final date = DateTime(2024, 1, 7).add(Duration(days: index));
    return DateFormat.E(Localizations.localeOf(context).toLanguageTag())
        .format(date);
  }

  String _summaryDays(BuildContext context) {
    final ordered = _dayOrder.where(selected.contains).map(
          (i) => _shortDay(context, i),
        );
    return ordered.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dayLabels = [
      l10n.weekdaySunday,
      l10n.weekdayMonday,
      l10n.weekdayTuesday,
      l10n.weekdayWednesday,
      l10n.weekdayThursday,
      l10n.weekdayFriday,
      l10n.weekdaySaturday,
    ];
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final surface = AppColors.surface(context);
    final component = AppColors.component(context);
    final daysText = _summaryDays(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sheetPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: TextStyle(color: primary, fontSize: 18, height: 1.35),
              children: [
                TextSpan(text: l10n.routineScheduleWeekdaysPromptPrefix),
                TextSpan(
                  text: l10n.routineScheduleWeekdaysPromptBold,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: l10n.routineScheduleWeekdaysPromptSuffix(name),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < dayLabels.length; i++)
                _DayChip(
                  label: dayLabels[i],
                  selected: selected.contains(i),
                  primary: primary,
                  surface: surface,
                  component: component,
                  onTap: () => onToggle(i),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: Text(
              selected.isEmpty
                  ? l10n.routineScheduleWeekdaysHint
                  : l10n.routineScheduleWorkOnDays(daysText),
              key: ValueKey(selected.isEmpty ? 'hint' : daysText),
              style: TextStyle(
                color: secondary,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.primary,
    required this.surface,
    required this.component,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color primary;
  final Color surface;
  final Color component;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? primary : component,
      borderRadius: AppRadii.sheetButton,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.sheetButton,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? surface : primary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _FrequencyBody extends StatefulWidget {
  const _FrequencyBody({
    required this.name,
    required this.restDays,
    required this.onChanged,
  });

  final String name;
  final int restDays;
  final ValueChanged<int> onChanged;

  @override
  State<_FrequencyBody> createState() => _FrequencyBodyState();
}

class _FrequencyBodyState extends State<_FrequencyBody> {
  static const double _itemExtent = 88;
  /// Viewport = evidência + metade anterior + metade seguinte.
  static const double _viewportHeight = _itemExtent * 2;
  static const double _edgePad = _itemExtent / 2;
  static const int _maxDays = 14;

  late final ScrollController _scrollController;
  late int _focused;

  @override
  void initState() {
    super.initState();
    _focused = widget.restDays.clamp(0, _maxDays);
    _scrollController = ScrollController(
      initialScrollOffset: _focused * _itemExtent,
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final index = (_scrollController.offset / _itemExtent)
        .round()
        .clamp(0, _maxDays);
    if (index != _focused) {
      setState(() => _focused = index);
      HapticFeedback.selectionClick();
      widget.onChanged(index);
    }
  }

  double _opacityFor(int index) {
    final distance = (index - _focused).abs();
    if (distance == 0) return 1;
    if (distance == 1) return 0.45;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final border = AppColors.border(context);
    final emphasis = _focused == 0
        ? l10n.routineScheduleEveryDay
        : l10n.routineScheduleEveryNDays(_focused);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sheetPaddingH),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: TextStyle(color: primary, fontSize: 18, height: 1.35),
              children: [
                TextSpan(text: l10n.routineScheduleFrequencyPromptPrefix),
                TextSpan(
                  text: l10n.routineScheduleFrequencyPromptBold,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: l10n.routineScheduleFrequencyPromptSuffix(widget.name),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: _viewportHeight,
            child: Stack(
              children: [
                ClipRect(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const MagnetSnapScrollPhysics(
                      itemExtent: _itemExtent,
                      parent: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: _edgePad),
                    itemExtent: _itemExtent,
                    itemCount: _maxDays + 1,
                    itemBuilder: (context, index) {
                      final isFocused = index == _focused;
                      final opacity = _opacityFor(index);
                      if (opacity <= 0 && !isFocused) {
                        return const SizedBox.shrink();
                      }
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$index',
                          style: TextStyle(
                            color: isFocused
                                ? primary
                                : secondary.withValues(alpha: opacity),
                            fontSize: isFocused ? 64 : 44,
                            fontWeight: FontWeight.w700,
                            height: 1.05,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: _edgePad,
                  left: 0,
                  right: 0,
                  height: _itemExtent,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: border.withValues(alpha: 0.55),
                          ),
                          bottom: BorderSide(
                            color: border.withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: Text.rich(
              key: ValueKey(emphasis),
              TextSpan(
                style: TextStyle(
                  color: secondary,
                  fontSize: 14,
                  height: 1.35,
                ),
                children: [
                  TextSpan(text: l10n.routineScheduleWorkPrefix),
                  TextSpan(
                    text: emphasis,
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

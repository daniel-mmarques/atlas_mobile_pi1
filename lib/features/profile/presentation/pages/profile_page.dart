import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/metrics/workout_metrics.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> showProfileSheet(BuildContext context) {
  return showAtlasSheet<void>(
    context: context,
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: AppSpacing.sheetInitial,
        minChildSize: AppSpacing.sheetMin,
        maxChildSize: AppSpacing.sheetMax,
        shouldCloseOnMinExtent: true,
        builder: (_, scrollController) {
          return ProfileContent(
            scrollController: scrollController,
            showHandle: true,
          );
        },
      );
    },
  );
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
    this.scrollController,
    this.showHandle = false,
  });

  final ScrollController? scrollController;
  final bool showHandle;

  void _openRoute(BuildContext context, String route) {
    final router = GoRouter.of(context);
    Navigator.pop(context);
    router.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.appUser;
    final uid = auth.user?.uid;
    final l10n = context.l10n;
    final title = user?.username?.isNotEmpty == true
        ? user!.handle
        : (user?.name?.isNotEmpty == true ? user!.name! : 'user');

    return Column(
      children: [
        if (showHandle) const AtlasSheetHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.sectionGap,
            AppSpacing.sheetPaddingH,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(title, style: AppTypography.sheetTitle(context)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AtlasSheetNavIcon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    isDismiss: true,
                  ),
                ],
              ),
              if (user?.username?.isNotEmpty == true &&
                  user?.name?.isNotEmpty == true) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(user!.name!, style: AppTypography.meta(context)),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (auth.isCoach) ...[
                    AppIconButton(
                      icon: Icons.people_rounded,
                      onPressed: () => _openRoute(context, AppRoutes.coach),
                      iconSize: AppSpacing.iconMd,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  AppIconButton(
                    icon: Icons.qr_code_rounded,
                    onPressed: () =>
                        _openRoute(context, AppRoutes.profileShare),
                    iconSize: AppSpacing.iconMd,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: uid == null
              ? Center(child: Text(l10n.notAuthenticated))
              : StreamBuilder<List<Workout>>(
                  stream:
                      context
                          .read<WorkoutService>()
                          .watchUserWorkouts(uid, limit: WorkoutService.profileLimit),
                  builder: (context, snapshot) {
                    final workouts = snapshot.data ?? [];
                    final finished =
                        workouts.where((w) => w.finishedAt != null).toList();
                    final weekVolumes =
                        WorkoutMetrics.volumeByWeekday(workouts);
                    final freq = WorkoutMetrics.weeklyFrequency(workouts);
                    final maxVol = weekVolumes.fold<int>(
                      0,
                      (a, b) => a > b ? a : b,
                    );

                    return ListView(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.sheetPaddingH,
                        AppSpacing.md,
                        AppSpacing.sheetPaddingH,
                        AppSpacing.sheetPaddingB,
                      ),
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: AppColors.accentOf(context),
                              child: Text(
                                title.replaceFirst('@', '').isNotEmpty
                                    ? title.replaceFirst('@', '')[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: AppColors.onAccentOf(context),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _Stat(
                                    value: '${finished.length}',
                                    label: l10n.profileWorkouts,
                                  ),
                                  _Stat(value: '0', label: l10n.profileFollowers),
                                  _Stat(value: '0', label: l10n.profileFollowing),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          l10n.widgetVolumeSubtitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: 120,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(7, (i) {
                              final v = weekVolumes[i];
                              final h = maxVol == 0
                                  ? 8.0
                                  : 16 + (v / maxVol) * 90;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: Container(
                                    height: h,
                                    decoration: BoxDecoration(
                                      color: v > 0
                                          ? AppColors.accentOf(context)
                                          : AppColors.component(context),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D']
                              .map(
                                (e) => Expanded(
                                  child: Text(
                                    e,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textSecondary(context),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$freq',
                                      style: AppTypography.metric(
                                        context,
                                        size: 32,
                                      ),
                                    ),
                                    Text(
                                      l10n.calendarThisWeek,
                                      style: TextStyle(
                                        color: AppColors.textSecondary(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.calendar_today_rounded,
                                color: AppColors.textSecondary(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          l10n.profileRecent,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (finished.isEmpty)
                          Text(
                            l10n.workoutsNoRoutines,
                            style: TextStyle(
                              color: AppColors.textSecondary(context),
                            ),
                          )
                        else
                          ...finished.take(8).map(
                                (w) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(w.name),
                                  subtitle: Text(
                                    '${w.volume} ${l10n.commonKg} · ${w.formattedDuration}',
                                  ),
                                  trailing:
                                      const Icon(Icons.chevron_right_rounded),
                                  onTap: () {
                                    Navigator.pop(context);
                                    context.push(
                                      AppRoutes.workoutDetails(w.id),
                                      extra: w,
                                    );
                                  },
                                ),
                              ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

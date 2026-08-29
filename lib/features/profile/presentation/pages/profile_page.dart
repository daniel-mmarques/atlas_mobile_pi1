import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/metrics/workout_metrics.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> showProfileSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        minChildSize: 0.95,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return ProfileContent(
            scrollController: scrollController,
            showHandle: true,
            asSheet: true,
          );
        },
      );
    },
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: ProfileContent(asSheet: false)),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
    this.scrollController,
    this.showHandle = false,
    this.asSheet = false,
  });

  final ScrollController? scrollController;
  final bool showHandle;
  final bool asSheet;

  void _openRoute(BuildContext context, String route) {
    final router = GoRouter.of(context);
    if (asSheet) Navigator.pop(context);
    router.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.appUser;
    final uid = auth.user?.uid;
    final name = user?.name?.isNotEmpty == true ? user!.name! : 'user';

    return Column(
      children: [
        if (showHandle) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: AppRadii.pill,
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.md,
            AppSpacing.pageHorizontal,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(name, style: AppTypography.pageTitle(context)),
              ),
              if (auth.isCoach)
                AppIconButton(
                  icon: Icons.people_rounded,
                  onPressed: () => _openRoute(context, AppRoutes.coach),
                  size: 40,
                  iconSize: 20,
                ),
              if (auth.isCoach) const SizedBox(width: AppSpacing.sm),
              AppIconButton(
                icon: Icons.qr_code_rounded,
                onPressed: () => _openRoute(context, AppRoutes.profileShare),
                size: 40,
                iconSize: 20,
              ),
            ],
          ),
        ),
        Expanded(
          child: uid == null
              ? const Center(child: Text('Não autenticado'))
              : StreamBuilder<List<Workout>>(
                  stream:
                      context.read<WorkoutService>().watchUserWorkouts(uid),
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
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageHorizontal,
                        AppSpacing.md,
                        AppSpacing.pageHorizontal,
                        AppSpacing.xxxl,
                      ),
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: AppColors.accent,
                              child: Text(
                                name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
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
                                    label: 'Workouts',
                                  ),
                                  const _Stat(value: '0', label: 'Followers'),
                                  const _Stat(value: '0', label: 'Following'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          'Weekly volume',
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
                                          ? AppColors.accent
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
                                      'Workouts this week',
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
                          'Recent',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (finished.isEmpty)
                          Text(
                            'Nenhum treino finalizado.',
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
                                    '${w.volume} kg · ${w.formattedDuration}',
                                  ),
                                  trailing:
                                      const Icon(Icons.chevron_right_rounded),
                                  onTap: () {
                                    if (asSheet) Navigator.pop(context);
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

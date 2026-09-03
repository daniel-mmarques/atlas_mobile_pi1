import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/templates_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/show_create_routine_sheet.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/widgets/routine_card.dart';
import 'package:atlas_mobile_pi1/ui/widgets/shell_page_header.dart';
import 'package:atlas_mobile_pi1/ui/widgets/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.select<AuthService, String?>((a) => a.user?.uid);
    final l10n = context.l10n;
    final bottomClearance =
        AppSpacing.shellBottomInset + MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShellPageHeader(
              title: l10n.workoutsTitle,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
              ),
              child: _WorkoutActions(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.xl,
                AppSpacing.pageHorizontal,
                0,
              ),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomClearance),
                child: ClipRect(
                  child: userId == null
                      ? const SizedBox.shrink()
                      : _RoutinesScroll(userId: userId),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Scrollable region between the fixed action buttons and the nav bar.
class _RoutinesScroll extends StatelessWidget {
  const _RoutinesScroll({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final templatesRepo = context.read<TemplatesRepository>();
    final workoutService = context.read<WorkoutService>();
    final l10n = context.l10n;

    return StreamBuilder<List<WorkoutTemplate>>(
      stream: templatesRepo.watchUserTemplates(userId),
      builder: (context, templatesSnap) {
        final templates = templatesSnap.data ?? const <WorkoutTemplate>[];
        final templatesLoading = templatesSnap.connectionState ==
                ConnectionState.waiting &&
            !templatesSnap.hasData;

        return StreamBuilder<List<Workout>>(
          stream: workoutService.watchUserWorkoutsList(userId),
          builder: (context, workoutsSnap) {
            final workouts = workoutsSnap.data ?? const <Workout>[];
            final workoutsLoading = workoutsSnap.connectionState ==
                    ConnectionState.waiting &&
                !workoutsSnap.hasData;

            if (templatesLoading && workoutsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                if (templates.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      AppSpacing.xl,
                      AppSpacing.pageHorizontal,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Text(l10n.workoutsNoRoutines),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      AppSpacing.xl,
                      AppSpacing.pageHorizontal,
                      0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final template = templates[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == templates.length - 1 ? 0 : 12,
                            ),
                            child: RoutineCard(
                              key: ValueKey(template.id),
                              template: template,
                              onTap: () =>
                                  showRoutineDetailSheet(context, template),
                            ),
                          );
                        },
                        childCount: templates.length,
                      ),
                    ),
                  ),
                if (workouts.isNotEmpty) ...[
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.sectionGap),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      0,
                      AppSpacing.pageHorizontal,
                      AppSpacing.xl,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final workout = workouts[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == workouts.length - 1 ? 0 : 14,
                            ),
                            child: WorkoutCard(
                              key: ValueKey(workout.id),
                              workout: workout,
                            ),
                          );
                        },
                        childCount: workouts.length,
                      ),
                    ),
                  ),
                ] else
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xl),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _WorkoutActions extends StatelessWidget {
  const _WorkoutActions();

  Future<void> _startEmptyWorkout(BuildContext context) async {
    final userId = context.read<AuthService>().user?.uid;
    if (userId == null) return;

    final workout = await context.read<WorkoutService>().createEmptyWorkout(
          userId,
          name: context.l10n.emptyWorkoutName,
        );

    if (!context.mounted) return;
    context.push(AppRoutes.workoutSession(workout.id), extra: workout);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: AppActionButton(
            icon: Icons.add_rounded,
            label: l10n.workoutsStartEmpty,
            bold: true,
            alignStart: true,
            onTap: () => _startEmptyWorkout(context),
          ),
        ),
        const SizedBox(width: AppSpacing.sectionGap),
        Expanded(
          child: AppActionButton(
            icon: Icons.assignment_outlined,
            label: l10n.workoutsNewRoutine,
            bold: true,
            alignStart: true,
            onTap: () => showCreateRoutineSheet(context),
          ),
        ),
      ],
    );
  }
}

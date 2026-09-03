import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/coach/data/coach_repository.dart';
import 'package:atlas_mobile_pi1/features/metrics/workout_metrics.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/app_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StudentDetailPage extends StatelessWidget {
  const StudentDetailPage({super.key, required this.student});

  final AppUser student;

  Future<void> _assign(BuildContext context) async {
    final coachId = context.read<AuthService>().user?.uid;
    if (coachId == null) return;
    final l10n = context.l10n;

    final name = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController(text: l10n.coachWorkout);
        return AlertDialog(
          title: Text(l10n.coachAssignWorkout),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: l10n.addSheetWorkout),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: Text(l10n.coachAssign),
            ),
          ],
        );
      },
    );

    if (name == null || name.isEmpty || !context.mounted) return;

    await context.read<CoachRepository>().assignWorkoutToStudent(
          coachId: coachId,
          studentId: student.id,
          name: name,
        );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.coachAssigned)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label =
        student.name?.isNotEmpty == true ? student.name! : student.email;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(label),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.fitness_center_rounded),
            onPressed: () => _assign(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Workout>>(
        stream: context.read<WorkoutService>().watchUserWorkoutsList(student.id),
        builder: (context, snapshot) {
          final workouts = snapshot.data ?? [];
          final finished =
              workouts.where((w) => w.finishedAt != null).toList();
          final weekVolumes = WorkoutMetrics.volumeByWeekday(workouts);
          final maxVol = weekVolumes.fold<int>(0, (a, b) => a > b ? a : b);
          final history = finished.take(10).toList();

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                l10n.coachWorkoutsCount(finished.length),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
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
                    final h = maxVol == 0 ? 8.0 : 16 + (v / maxVol) * 90;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              AppActionButton(
                label: l10n.coachAssignWorkout,
                emphasized: true,
                borderRadius: AppRadii.pill,
                onTap: () => _assign(context),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.coachHistory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              if (history.isEmpty)
                AppCard(
                  child: Text(
                    l10n.workoutsNoRoutines,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                )
              else
                ...history.map(
                  (w) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(w.name),
                                Text(
                                  w.startedAt != null
                                      ? DateFormat('dd/MM/yyyy', locale)
                                          .format(w.startedAt!)
                                      : '--',
                                  style: TextStyle(
                                    color: AppColors.textSecondary(context),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${w.volume} ${l10n.commonKg}'),
                              Text(
                                w.formattedDuration,
                                style: TextStyle(
                                  color: AppColors.textSecondary(context),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

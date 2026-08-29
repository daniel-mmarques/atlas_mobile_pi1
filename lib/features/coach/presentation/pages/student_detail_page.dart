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

    final name = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController(text: 'Treino do coach');
        return AlertDialog(
          title: const Text('Atribuir treino'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Nome do treino'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Atribuir'),
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
      const SnackBar(content: Text('Treino atribuído')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label =
        student.name?.isNotEmpty == true ? student.name! : student.email;

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
        stream: context.read<WorkoutService>().watchUserWorkouts(student.id),
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
                '${finished.length} treinos realizados',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Volume semanal',
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
                label: 'Atribuir treino',
                emphasized: true,
                borderRadius: AppRadii.pill,
                onTap: () => _assign(context),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Histórico',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              if (history.isEmpty)
                AppCard(
                  child: Text(
                    'Nenhum treino finalizado',
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
                                      ? DateFormat('dd/MM/yyyy')
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
                              Text('${w.volume} kg'),
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

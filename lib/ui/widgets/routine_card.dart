import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_template.dart';
import 'package:atlas_mobile_pi1/ui/components/app_card.dart';
import 'package:atlas_mobile_pi1/ui/widgets/workout_card.dart';
import 'package:flutter/material.dart';

/// Card de rotina salva (lista de Workouts).
class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.template,
    required this.onTap,
  });

  final WorkoutTemplate template;
  final VoidCallback onTap;

  static ({int low, int high}) estimateMinutes(WorkoutTemplate template) {
    if (template.exercises.isEmpty) {
      return (low: 15, high: 20);
    }

    var setCount = 0;
    var restSeconds = 0;
    for (final exercise in template.exercises) {
      final sets = exercise.sets.isEmpty ? 1 : exercise.sets.length;
      setCount += sets;
      restSeconds += exercise.rest.inSeconds * sets;
    }

    // ~40s de execução por série + descansos.
    final totalMinutes = ((setCount * 40 + restSeconds) / 60).ceil();
    final mid = totalMinutes.clamp(10, 120);
    final low = (mid * 0.85).round().clamp(5, mid);
    final high = (mid * 1.15).round().clamp(low + 5, 150);
    return (low: low, high: high);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final accent = AppColors.accentOf(context);
    final onAccent = AppColors.onAccentOf(context);
    final estimate = estimateMinutes(template);

    return AppCard(
      color: AppColors.component(context),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg + 2,
        AppSpacing.lg,
        AppSpacing.lg + 2,
      ),
      borderRadius: AppRadii.card,
      onTap: onTap,
      child: SizedBox(
        height: 112,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    splitTitleTwoLines(template.name),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cardTitle(context),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs + 1,
                        ),
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: AppRadii.pill,
                        ),
                        child: Text(
                          '${template.exercises.length}',
                          style: TextStyle(
                            color: onAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.workoutsExercises,
                        style: TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  color: primary,
                  size: 28,
                ),
                const Spacer(),
                Text(
                  l10n.workoutsDurationRange(estimate.low, estimate.high),
                  style: TextStyle(
                    color: secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

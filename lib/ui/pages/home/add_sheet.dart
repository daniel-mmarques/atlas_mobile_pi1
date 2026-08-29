import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> showAddSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.95,
        minChildSize: 0.95,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return AddSheet(scrollController: scrollController);
        },
      );
    },
  );
}

class AddSheet extends StatelessWidget {
  const AddSheet({super.key, this.scrollController});

  final ScrollController? scrollController;

  Future<void> _createWorkout(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final workoutService = context.read<WorkoutService>();
    final workout = await workoutService.createEmptyWorkout(
      userId,
      name: 'Empty Workout',
    );

    if (!context.mounted) return;
    Navigator.of(context).pop();

    context.push(AppRoutes.workoutSession(workout.id), extra: workout);
  }

  void _comingSoon(BuildContext context, String label) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label em breve')));
  }

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.textSecondary(context);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border(context).withValues(alpha: 0.7),
              borderRadius: AppRadii.pill,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: Icon(
              Icons.arrow_downward_rounded,
              size: 30,
              color: AppColors.textPrimary(context),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Add',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create workouts, get a tailored workout routine and add widgets to your dashboard.',
          style: TextStyle(color: secondary, fontSize: 15, height: 1.35),
        ),
        const SizedBox(height: 28),
        _AddOption(
          icon: Icons.add_rounded,
          title: 'A workout',
          subtitle: 'Create a new workout',
          actionLabel: 'Create',
          onAction: () => _createWorkout(context),
        ),
        const SizedBox(height: 22),
        _AddOption(
          icon: Icons.auto_awesome_rounded,
          title: 'Tailored routine',
          subtitle: 'Get a gym routine from us',
          actionLabel: 'Get',
          onAction: () => _comingSoon(context, 'Rotina personalizada'),
        ),
        const SizedBox(height: 22),
        _AddOption(
          icon: Icons.open_in_full_rounded,
          title: 'Body metrics',
          subtitle: 'Track changes over time',
          actionLabel: 'Add',
          onAction: () => _comingSoon(context, 'Body metrics'),
        ),
        const SizedBox(height: 22),
        _AddOption(
          icon: Icons.folder_outlined,
          title: 'Folder',
          subtitle: 'Group things on the dash',
          actionLabel: 'Add',
          onAction: () => _comingSoon(context, 'Folders'),
        ),
        SizedBox(
          height: MediaQuery.paddingOf(context).bottom > 0
              ? AppSpacing.sm
              : AppSpacing.md,
        ),
      ],
    );
  }
}

class _AddOption extends StatelessWidget {
  const _AddOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final chipColor = AppColors.component(context);

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: chipColor, shape: BoxShape.circle),
          child: Icon(icon, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: chipColor,
          borderRadius: AppRadii.pill,
          child: InkWell(
            onTap: onAction,
            borderRadius: AppRadii.pill,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

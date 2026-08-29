import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/seed_exercises.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/templates_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/exercise.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout_set.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateRoutinePage extends StatefulWidget {
  const CreateRoutinePage({super.key});

  @override
  State<CreateRoutinePage> createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends State<CreateRoutinePage> {
  final _nameController = TextEditingController(text: 'Minha rotina');
  final _selected = <Map<String, String>>[];
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final auth = context.read<AuthService>();
    final uid = auth.user?.uid;
    if (uid == null) return;

    final templatesRepo = context.read<TemplatesRepository>();
    final service = context.read<WorkoutService>();

    setState(() => _saving = true);
    try {
      final name = _nameController.text.trim().isEmpty
          ? 'Rotina'
          : _nameController.text.trim();
      final exercises = _selected
          .map(
            (e) => Exercise(
              id: const Uuid().v4(),
              name: e['name']!,
              sets: const [
                WorkoutSet(reps: 10, weight: 20),
                WorkoutSet(reps: 10, weight: 20),
                WorkoutSet(reps: 10, weight: 20),
              ],
            ),
          )
          .toList();

      await templatesRepo.save(
        WorkoutTemplate(
          id: const Uuid().v4(),
          userId: uid,
          name: name,
          exercises: exercises,
        ),
      );

      var workout = await service.createEmptyWorkout(uid, name: name);
      workout = workout.copyWith(exercises: exercises);
      await service.saveWorkout(workout);

      if (!mounted) return;
      context.go(AppRoutes.workoutDetails(workout.id), extra: workout);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova rotina'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nome da rotina'),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Exercícios', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          ...seedExercises.map((e) {
            final selected = _selected.any((s) => s['id'] == e['id']);
            return CheckboxListTile(
              value: selected,
              title: Text(e['name']!),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selected.add(e);
                  } else {
                    _selected.removeWhere((s) => s['id'] == e['id']);
                  }
                });
              },
            );
          }),
          const SizedBox(height: AppSpacing.xl),
          AppActionButton(
            label: _saving ? 'Salvando...' : 'Salvar rotina',
            emphasized: true,
            borderRadius: AppRadii.pill,
            onTap: _saving || _selected.isEmpty ? null : _save,
          ),
        ],
      ),
    );
  }
}

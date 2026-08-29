import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/seed_exercises.dart';
import 'package:flutter/material.dart';

class SearchExercisePage extends StatefulWidget {
  const SearchExercisePage({super.key});

  @override
  State<SearchExercisePage> createState() => _SearchExercisePageState();
}

class _SearchExercisePageState extends State<SearchExercisePage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = seedExercises
        .where(
          (e) => e['name']!.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar exercício'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Nome do exercício',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: results.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final exercise = results[index];
                return ListTile(
                  title: Text(exercise['name']!),
                  subtitle: Text(
                    'Catálogo local',
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, exercise),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseDetailsPage extends StatelessWidget {
  const ExerciseDetailsPage({
    super.key,
    required this.exerciseId,
    this.exerciseName,
  });

  final String exerciseId;
  final String? exerciseName;

  @override
  Widget build(BuildContext context) {
    final seed = seedExercises.where((e) => e['id'] == exerciseId).firstOrNull;
    final name = exerciseName ?? seed?['name'] ?? exerciseId;

    return Scaffold(
      appBar: AppBar(title: Text(name), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Text(
          'Detalhes do exercício (catálogo local).\nID: $exerciseId',
          style: TextStyle(color: AppColors.textSecondary(context)),
        ),
      ),
    );
  }
}

import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/coach/data/coach_repository.dart';
import 'package:atlas_mobile_pi1/features/coach/domain/enums/coach_enums.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CoachDashboardPage extends StatelessWidget {
  const CoachDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final coachId = auth.user?.uid;
    if (coachId == null) {
      return const Scaffold(body: Center(child: Text('Não autenticado')));
    }

    final coachRepository = context.read<CoachRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Alunos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded),
            onPressed: () => context.push(AppRoutes.coachLink),
          ),
        ],
      ),
      body: StreamBuilder<List<AppUser>>(
        stream: coachRepository.watchStudents(coachId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data ?? [];
          if (students.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people_outline, size: 64),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Nenhum aluno vinculado',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Gere um QR Code para que um aluno escaneie e se vincule a você.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FilledButton.icon(
                      onPressed: () => context.push(AppRoutes.coachLink),
                      icon: const Icon(Icons.qr_code_2_rounded),
                      label: const Text('Gerar QR Code'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: students.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final student = students[index];
              final label = student.name?.isNotEmpty == true
                  ? student.name!
                  : student.email;
              return ListTile(
                tileColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.accent,
                  child: Text(
                    label.isNotEmpty ? label[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(label),
                subtitle: StreamBuilder<List<Workout>>(
                  stream: context
                      .read<WorkoutService>()
                      .watchUserWorkouts(student.id),
                  builder: (context, workoutSnap) {
                    final finished = (workoutSnap.data ?? [])
                        .where((w) => w.finishedAt != null)
                        .length;
                    return Text('$finished treinos');
                  },
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(
                  AppRoutes.coachStudent(student.id),
                  extra: student,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.coachLink),
        icon: const Icon(Icons.link_rounded),
        label: const Text('Vincular aluno'),
      ),
    );
  }
}

class CoachLinkPage extends StatefulWidget {
  const CoachLinkPage({super.key});

  @override
  State<CoachLinkPage> createState() => _CoachLinkPageState();
}

class _CoachLinkPageState extends State<CoachLinkPage> {
  String? _token;
  bool _loading = false;

  Future<void> _generate() async {
    final auth = context.read<AuthService>();
    final uid = auth.user?.uid;
    if (uid == null) return;

    setState(() => _loading = true);
    try {
      final invitation =
          await context.read<CoachRepository>().generateInvitation(
                creatorId: uid,
                creatorRole: InvitationRole.coach,
              );
      setState(() => _token = invitation.token);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _generate());
  }

  @override
  Widget build(BuildContext context) {
    final payload = _token == null ? null : 'atlas://link?token=$_token';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular aluno'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Text(
              'Peça ao aluno para escanear este QR no app.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (_loading)
              const CircularProgressIndicator()
            else if (payload != null)
              QrImageView(
                data: payload,
                size: 240,
                backgroundColor: Colors.white,
              ),
            const Spacer(),
            AppActionButton(
              label: 'Abrir scanner',
              emphasized: true,
              onTap: () => context.push(AppRoutes.coachScan),
            ),
            TextButton(
              onPressed: _loading ? null : _generate,
              child: const Text('Gerar novo'),
            ),
          ],
        ),
      ),
    );
  }
}

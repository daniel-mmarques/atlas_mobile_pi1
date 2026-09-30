import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/coach/data/coach_repository.dart';
import 'package:atlas_mobile_pi1/features/coach/domain/enums/coach_enums.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
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
    final l10n = context.l10n;
    if (coachId == null) {
      return Scaffold(body: Center(child: Text(l10n.notAuthenticated)));
    }

    final coachRepository = context.read<CoachRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coachMyStudents),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded),
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
                      l10n.coachNoStudents,
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
                    AppActionButton(
                      label: l10n.coachGenerateQr,
                      icon: Icons.qr_code_rounded,
                      emphasized: true,
                      onTap: () => context.push(AppRoutes.coachLink),
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
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.sm,
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.accentOf(context),
                  child: Text(
                    label.isNotEmpty ? label[0].toUpperCase() : '?',
                    style: TextStyle(color: AppColors.onAccentOf(context)),
                  ),
                ),
                title: Text(label),
                subtitle: FutureBuilder<int>(
                  future: coachRepository.countFinishedWorkouts(student.id),
                  builder: (context, workoutSnap) {
                    final finished = workoutSnap.data ?? 0;
                    if (workoutSnap.connectionState ==
                            ConnectionState.waiting &&
                        !workoutSnap.hasData) {
                      return Text(student.displayLabel);
                    }
                    return Text(l10n.coachWorkoutsCount(finished));
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
        label: Text(l10n.coachLinkStudent),
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coachLinkStudent),
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
              label: l10n.coachOpenScanner,
              emphasized: true,
              onTap: () => context.push(AppRoutes.coachScan),
            ),
            TextButton(
              onPressed: _loading ? null : _generate,
              child: Text(l10n.coachGenerateNew),
            ),
          ],
        ),
      ),
    );
  }
}

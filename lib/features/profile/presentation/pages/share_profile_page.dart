import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/coach/data/coach_repository.dart';
import 'package:atlas_mobile_pi1/features/coach/domain/enums/coach_enums.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareProfilePage extends StatefulWidget {
  const ShareProfilePage({super.key});

  @override
  State<ShareProfilePage> createState() => _ShareProfilePageState();
}

class _ShareProfilePageState extends State<ShareProfilePage> {
  bool _chatMode = true;
  String? _coachToken;
  bool _loading = false;

  Future<void> _generateCoachLink() async {
    final auth = context.read<AuthService>();
    final uid = auth.user?.uid;
    if (uid == null) return;

    setState(() => _loading = true);
    try {
      final invitation =
          await context.read<CoachRepository>().generateInvitation(
                creatorId: uid,
                creatorRole:
                    auth.isCoach ? InvitationRole.coach : InvitationRole.student,
              );
      setState(() => _coachToken = invitation.token);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _generateCoachLink());
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final uid = auth.user?.uid;
    final username = auth.appUser?.name?.isNotEmpty == true
        ? auth.appUser!.name!
        : 'user';

    final payload = _chatMode
        ? (uid == null ? null : 'atlas://user?uid=$uid')
        : (_coachToken == null ? null : 'atlas://link?token=$_coachToken');

    return Scaffold(
      appBar: AppBar(
        title: Text('_$username'),
        centerTitle: true,
        actions: [
          PlatinumIconButton(
            icon: Icons.qr_code_scanner_rounded,
            onPressed: () => context.push(AppRoutes.messagesScan),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Chat')),
                  ButtonSegment(value: false, label: Text('Coach')),
                ],
                selected: {_chatMode},
                onSelectionChanged: (value) {
                  setState(() => _chatMode = value.first);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _chatMode
                    ? 'Escaneie para iniciar uma conversa comigo'
                    : 'Escaneie para vincular coach/aluno',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary(context)),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                height: 320,
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _loading && !_chatMode
                    ? const Center(child: CircularProgressIndicator())
                    : payload != null
                        ? QrImageView(
                            data: payload,
                            backgroundColor: Colors.white,
                          )
                        : Center(
                            child: Text(
                              'Não foi possível gerar o QR',
                              style: TextStyle(
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                          ),
              ),
              const Spacer(),
              AppActionButton(
                label: 'Copy Link',
                emphasized: true,
                onTap: () {
                  if (payload == null) return;
                  Clipboard.setData(ClipboardData(text: payload));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copiado')),
                  );
                },
              ),
              if (!_chatMode) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: _loading ? null : _generateCoachLink,
                  child: const Text('Gerar novo QR coach'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

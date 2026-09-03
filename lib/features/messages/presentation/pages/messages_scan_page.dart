import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/coach/data/coach_repository.dart';
import 'package:atlas_mobile_pi1/features/messages/data/conversations_repository.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

/// Scanner unificado: coach invite, user DM, community join.
class MessagesScanPage extends StatefulWidget {
  const MessagesScanPage({super.key});

  @override
  State<MessagesScanPage> createState() => _MessagesScanPageState();
}

class _MessagesScanPageState extends State<MessagesScanPage> {
  bool _handling = false;
  String? _message;

  Future<void> _handleCode(String raw) async {
    if (_handling) return;
    setState(() {
      _handling = true;
      _message = null;
    });

    try {
      final uri = Uri.tryParse(raw);
      final auth = context.read<AuthService>();
      final userRepo = context.read<UserRepository>();
      final conversations = context.read<ConversationsRepository>();
      final coachRepo = context.read<CoachRepository>();
      final me = auth.appUser;
      final uid = auth.user?.uid;
      if (me == null || uid == null) {
        setState(() => _message = context.l10n.notAuthenticated);
        return;
      }

      if (uri != null && uri.scheme == 'atlas') {
        if (uri.host == 'user' || uri.pathSegments.contains('user')) {
          final otherId = uri.queryParameters['uid'];
          if (otherId == null || otherId.isEmpty) {
            setState(() => _message = 'QR de usuário inválido');
            return;
          }
          final other = await userRepo.getUser(otherId);
          if (other == null) {
            setState(() => _message = 'Usuário não encontrado');
            return;
          }
          final conv = await conversations.getOrCreateDm(
            me: me,
            other: other,
          );
          if (!mounted) return;
          context.pushReplacement(AppRoutes.messagesChat(conv.id));
          return;
        }

        if (uri.host == 'community') {
          final id = uri.queryParameters['id'];
          final token = uri.queryParameters['token'];
          if (id != null && id.isNotEmpty) {
            final conv = await conversations.joinCommunity(
              conversationId: id,
              user: me,
            );
            if (!mounted) return;
            context.pushReplacement(AppRoutes.messagesChat(conv.id));
            return;
          }
          if (token != null && token.isNotEmpty) {
            final conv = await conversations.joinCommunityByToken(
              token: token,
              user: me,
            );
            if (conv == null) {
              setState(() => _message = 'Convite de comunidade inválido');
              return;
            }
            if (!mounted) return;
            context.pushReplacement(AppRoutes.messagesChat(conv.id));
            return;
          }
        }

        if (uri.host == 'link') {
          final token = uri.queryParameters['token'];
          if (token == null) {
            setState(() => _message = 'QR inválido');
            return;
          }
          await coachRepo.acceptInvitation(
            token: token,
            acceptorId: uid,
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.messagesCoachLinkCreated)),
          );
          context.pop();
          return;
        }
      }

      // Fallback: treat as coach invite token or community token
      final token = raw.trim();
      if (token.isNotEmpty && !token.contains(' ')) {
        try {
          await coachRepo.acceptInvitation(
            token: token,
            acceptorId: uid,
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.messagesCoachLinkCreated)),
          );
          context.pop();
          return;
        } catch (_) {
          final conv = await conversations.joinCommunityByToken(
            token: token,
            user: me,
          );
          if (conv != null && mounted) {
            context.pushReplacement(AppRoutes.messagesChat(conv.id));
            return;
          }
        }
      }

      setState(() => _message = 'QR não reconhecido');
    } catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) setState(() => _handling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.messagesScan),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final value = capture.barcodes.firstOrNull?.rawValue;
                if (value != null) _handleCode(value);
              },
            ),
          ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                _message!,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          if (_handling)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

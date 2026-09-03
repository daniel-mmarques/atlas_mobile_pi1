import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/messages/data/conversations_repository.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NewCommunityPage extends StatefulWidget {
  const NewCommunityPage({super.key});

  @override
  State<NewCommunityPage> createState() => _NewCommunityPageState();
}

class _NewCommunityPageState extends State<NewCommunityPage> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _controller.text.trim();
    if (name.isEmpty || _saving) return;
    final me = context.read<AuthService>().appUser;
    if (me == null) return;

    setState(() => _saving = true);
    try {
      final conv = await context.read<ConversationsRepository>().createCommunity(
            name: name,
            creator: me,
          );
      if (!mounted) return;
      context.pushReplacement(AppRoutes.messagesChat(conv.id));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.messagesNewCommunity),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.messagesNewCommunity,
                hintText: l10n.workoutsFolderHint,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _create(),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppActionButton(
              label: _saving ? l10n.saving : l10n.continueAction,
              emphasized: true,
              borderRadius: AppRadii.pill,
              onTap: _saving ? null : _create,
            ),
          ],
        ),
      ),
    );
  }
}

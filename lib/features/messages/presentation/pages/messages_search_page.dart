import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/messages/data/conversations_repository.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/entities/conversation.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MessagesSearchPage extends StatefulWidget {
  const MessagesSearchPage({super.key});

  @override
  State<MessagesSearchPage> createState() => _MessagesSearchPageState();
}

class _MessagesSearchPageState extends State<MessagesSearchPage> {
  final _controller = TextEditingController();
  List<AppUser> _users = [];
  List<Conversation> _communities = [];
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        _users = [];
        _communities = [];
      });
      return;
    }

    setState(() => _loading = true);
    try {
      final auth = context.read<AuthService>();
      final repo = context.read<ConversationsRepository>();
      final users = await repo.searchUsersByName(
        q,
        excludeUid: auth.user?.uid,
      );
      final communities = await repo.searchCommunities(q);
      if (!mounted) return;
      setState(() {
        _users = users;
        _communities = communities;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openDm(AppUser other) async {
    final auth = context.read<AuthService>();
    final me = auth.appUser;
    if (me == null) return;
    final conv = await context.read<ConversationsRepository>().getOrCreateDm(
          me: me,
          other: other,
        );
    if (!mounted) return;
    context.push(AppRoutes.messagesChat(conv.id));
  }

  Future<void> _joinCommunity(Conversation community) async {
    final auth = context.read<AuthService>();
    final me = auth.appUser;
    if (me == null) return;
    final conv = await context.read<ConversationsRepository>().joinCommunity(
          conversationId: community.id,
          user: me,
        );
    if (!mounted) return;
    context.push(AppRoutes.messagesChat(conv.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Nome de pessoa ou comunidade',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: _search,
            ),
          ),
          if (_loading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: ListView(
              children: [
                if (_users.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      'Pessoas',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ..._users.map(
                    (u) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.accent,
                        child: Text(
                          (u.name ?? u.email).isNotEmpty
                              ? (u.name ?? u.email)[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(u.name ?? u.email),
                      subtitle: Text(u.email),
                      onTap: () => _openDm(u),
                    ),
                  ),
                ],
                if (_communities.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Text(
                      'Comunidades',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ..._communities.map(
                    (c) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.component(context),
                        child: const Icon(Icons.groups_rounded),
                      ),
                      title: Text(c.title),
                      subtitle: Text('${c.participantIds.length} membros'),
                      onTap: () => _joinCommunity(c),
                    ),
                  ),
                ],
                if (!_loading &&
                    _controller.text.trim().isNotEmpty &&
                    _users.isEmpty &&
                    _communities.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Nenhum resultado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary(context)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

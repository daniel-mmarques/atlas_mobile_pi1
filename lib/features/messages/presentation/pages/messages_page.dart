import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/coach/data/coach_repository.dart';
import 'package:atlas_mobile_pi1/features/messages/data/conversations_repository.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/entities/conversation.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/enums/conversation_type.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  bool _seededCoach = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_seededCoach) {
      _seededCoach = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _seedCoachChats());
    }
  }

  Future<void> _seedCoachChats() async {
    final auth = context.read<AuthService>();
    final coachRepo = context.read<CoachRepository>();
    final conversations = context.read<ConversationsRepository>();
    final me = auth.appUser;
    final uid = auth.user?.uid;
    if (me == null || uid == null) return;

    await conversations.ensureGeneralConversation();

    try {
      if (me.isCoach) {
        final students = await coachRepo.watchStudents(uid).first;
        for (final student in students) {
          await conversations.getOrCreateCoachChat(coach: me, student: student);
        }
      } else {
        final coaches = await coachRepo.watchCoaches(uid).first;
        for (final coach in coaches) {
          await conversations.getOrCreateCoachChat(coach: coach, student: me);
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final userId = auth.user?.uid;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.messagesTitle),
        centerTitle: false,
        actions: [
          PlatinumIconButton(
            icon: Icons.search_rounded,
            onPressed: () => context.push(AppRoutes.messagesSearch),
          ),
          const SizedBox(width: AppSpacing.sm),
          PlatinumIconButton(
            icon: Icons.qr_code_scanner_rounded,
            onPressed: () => context.push(AppRoutes.messagesScan),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.messagesNewCommunity),
        icon: const Icon(Icons.group_add_rounded),
        label: Text(l10n.messagesCommunity),
      ),
      body: userId == null
          ? Center(
              child: Text(
                l10n.feedLoginRequired,
                style: TextStyle(color: AppColors.textSecondary(context)),
              ),
            )
          : StreamBuilder<List<Conversation>>(
              stream:
                  context.read<ConversationsRepository>().watchInbox(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final conversations = snapshot.data ?? [];
                if (conversations.isEmpty) {
                  return const _EmptyMessages();
                }

                return ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: AppSpacing.shellBottomInset +
                        MediaQuery.paddingOf(context).bottom,
                  ),
                  itemCount: conversations.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    indent: 76,
                    color: AppColors.border(context).withValues(alpha: 0.35),
                  ),
                  itemBuilder: (context, index) {
                    return _ConversationTile(
                      conversation: conversations[index],
                      currentUserId: userId,
                    );
                  },
                );
              },
            ),
    );
  }
}

class _EmptyMessages extends StatelessWidget {
  const _EmptyMessages();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48,
              color: AppColors.textSecondary(context),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.messagesEmpty,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Busque alguém, escaneie um QR ou entre no Geral.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
  });

  final Conversation conversation;
  final String currentUserId;

  String _formatTime(BuildContext context, DateTime dt) {
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    if (day == today) return DateFormat('HH:mm', locale).format(dt);
    if (day == today.subtract(const Duration(days: 1))) {
      return context.l10n.yesterday;
    }
    return DateFormat('dd/MM', locale).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = conversation.isGeneral
        ? l10n.messagesGeneral
        : conversation.displayTitle(currentUserId);
    final preview = conversation.inboxPreview(currentUserId);
    final isGeneral = conversation.isGeneral;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
        vertical: AppSpacing.xs,
      ),
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: isGeneral
            ? AppColors.accentOf(context)
            : AppColors.component(context),
        child: Icon(
          isGeneral
              ? Icons.public_rounded
              : conversation.isCommunity
                  ? Icons.groups_rounded
                  : conversation.type == ConversationType.coach
                      ? Icons.fitness_center_rounded
                      : Icons.person_rounded,
          color: isGeneral
              ? AppColors.onAccentOf(context)
              : AppColors.textPrimary(context),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          if (isGeneral)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentOf(context).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '48h',
                style: TextStyle(
                  color: AppColors.accentOf(context),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColors.textSecondary(context), fontSize: 14),
      ),
      trailing: Text(
        _formatTime(context, conversation.updatedAt),
        style: TextStyle(
          color: AppColors.textSecondary(context),
          fontSize: 12,
        ),
      ),
      onTap: () => context.push(AppRoutes.messagesChat(conversation.id)),
    );
  }
}

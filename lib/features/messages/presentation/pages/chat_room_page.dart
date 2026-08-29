import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/features/messages/data/conversations_repository.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/entities/chat_message.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/entities/conversation.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/enums/conversation_type.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key, required this.conversationId});

  final String conversationId;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Conversation? _conversation;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMeta());
  }

  Future<void> _loadMeta() async {
    final repo = context.read<ConversationsRepository>();
    if (widget.conversationId == ConversationsRepositoryImpl.generalId) {
      await repo.ensureGeneralConversation();
      await repo.purgeExpiredGeneralMessages();
    }
    final conv = await repo.getConversation(widget.conversationId);
    if (mounted) setState(() => _conversation = conv);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    final auth = context.read<AuthService>();
    final uid = auth.user?.uid;
    if (uid == null) return;

    setState(() => _sending = true);
    try {
      await context.read<ConversationsRepository>().sendMessage(
            conversationId: widget.conversationId,
            senderId: uid,
            senderName: auth.appUser?.name ?? auth.appUser?.email ?? 'User',
            text: text,
          );
      _controller.clear();
      if (_scrollController.hasClients) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';
    if (diff.inDays == 1) return '1 day ago';
    return DateFormat('dd/MM HH:mm').format(dt);
  }

  void _showCommunityInvite(BuildContext context) {
    final conv = _conversation;
    if (conv == null) return;
    final payload = conv.inviteToken != null
        ? 'atlas://community?token=${conv.inviteToken}'
        : 'atlas://community?id=${conv.id}';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Convidar para ${conv.title}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              QrImageView(
                data: payload,
                size: 200,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: payload));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copiado')),
                  );
                },
                child: const Text('Copiar link'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final uid = auth.user?.uid ?? '';
    final isGeneral =
        widget.conversationId == ConversationsRepositoryImpl.generalId ||
            _conversation?.type == ConversationType.general;
    final title = _conversation?.displayTitle(uid) ??
        (isGeneral ? 'Geral' : 'Chat');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          if (_conversation?.type == ConversationType.community)
            IconButton(
              icon: const Icon(Icons.qr_code_2_rounded),
              onPressed: () => _showCommunityInvite(context),
            ),
        ],
      ),
      body: Column(
        children: [
          if (isGeneral)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Text(
                'This is a public space for anyone in Atlas to type anything. '
                'Ask a question about an exercise, tell us about your new routine. '
                'Whatever you want. Messages are visible for 48 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: context
                  .read<ConversationsRepository>()
                  .watchMessages(widget.conversationId),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma mensagem ainda.',
                      style: TextStyle(color: AppColors.textSecondary(context)),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final showAvatar = isGeneral ||
                        index == 0 ||
                        messages[index - 1].senderId != msg.senderId;
                    return _MessageBubble(
                      message: msg,
                      showAvatar: showAvatar,
                      showHandle: isGeneral ||
                          _conversation?.type == ConversationType.community ||
                          _conversation?.type == ConversationType.coach,
                      relativeTime: _relativeTime(msg.createdAt),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_sending,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        filled: true,
                        fillColor: AppColors.component(context),
                        border: OutlineInputBorder(
                          borderRadius: AppRadii.pill,
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: AppColors.component(context),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _sending ? null : _send,
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.arrow_upward_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.showHandle,
    required this.relativeTime,
  });

  final ChatMessage message;
  final bool showAvatar;
  final bool showHandle;
  final String relativeTime;

  @override
  Widget build(BuildContext context) {
    final handle = message.senderName.trim().isEmpty
        ? 'user'
        : message.senderName.trim().toLowerCase().replaceAll(' ', '');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accent,
              child: Text(
                message.senderName.isNotEmpty
                    ? message.senderName[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          else
            const SizedBox(width: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: AppColors.component(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.border(context).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(fontSize: 15, height: 1.35),
                  ),
                  if (showHandle) ...[
                    const SizedBox(height: 8),
                    Text(
                      '@$handle · $relativeTime',
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

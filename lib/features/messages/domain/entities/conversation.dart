import 'package:atlas_mobile_pi1/features/messages/domain/enums/conversation_type.dart';

class ConversationParticipant {
  const ConversationParticipant({
    required this.userId,
    required this.name,
    this.username = '',
    this.photoUrl = '',
  });

  final String userId;
  final String name;
  final String username;
  final String photoUrl;

  String get displayLabel {
    if (username.trim().isNotEmpty) {
      final u = username.trim();
      return u.startsWith('@') ? u : '@$u';
    }
    return name.isNotEmpty ? name : 'User';
  }
}

class Conversation {
  const Conversation({
    required this.id,
    required this.type,
    required this.title,
    required this.participantIds,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
    this.lastSenderName = '',
    this.createdBy,
    this.inviteToken,
    this.peerPhotoUrl = '',
  });

  final String id;
  final ConversationType type;
  final String title;
  final List<String> participantIds;
  final List<ConversationParticipant> participants;
  final String lastMessage;
  final String lastSenderName;
  final DateTime updatedAt;
  final String? createdBy;
  final String? inviteToken;
  final String peerPhotoUrl;

  bool get isGeneral => type == ConversationType.general;
  bool get isCommunity => type == ConversationType.community;

  String displayTitle(String currentUserId) {
    if (type == ConversationType.general) return 'Geral';
    if (type == ConversationType.community) {
      return title.isNotEmpty ? title : 'Comunidade';
    }
    for (final peer in participants) {
      if (peer.userId != currentUserId) return peer.displayLabel;
    }
    return title.isNotEmpty ? title : 'Conversa';
  }

  String inboxPreview(String currentUserId) {
    if (lastMessage.isEmpty) return 'Sem mensagens';
    if (type == ConversationType.community || type == ConversationType.general) {
      if (lastSenderName.isEmpty) return lastMessage;
      return '~ $lastSenderName: $lastMessage';
    }
    return lastMessage;
  }

  static Conversation generalPlaceholder() {
    return Conversation(
      id: 'general',
      type: ConversationType.general,
      title: 'Geral',
      participantIds: const [],
      participants: const [],
      lastMessage: 'Espaço público · mensagens 48h',
      updatedAt: DateTime.now(),
    );
  }
}

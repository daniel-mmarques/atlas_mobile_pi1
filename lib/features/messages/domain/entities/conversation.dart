import 'package:atlas_mobile_pi1/features/messages/domain/enums/conversation_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationParticipant {
  const ConversationParticipant({
    required this.userId,
    required this.name,
    this.photoUrl = '',
  });

  final String userId;
  final String name;
  final String photoUrl;

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'name': name,
        'photoUrl': photoUrl,
      };

  factory ConversationParticipant.fromMap(Map<String, dynamic> map) {
    return ConversationParticipant(
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? 'User',
      photoUrl: map['photoUrl'] as String? ?? '',
    );
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
      if (peer.userId != currentUserId) return peer.name;
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

  factory Conversation.fromMap(
    String id,
    Map<String, dynamic> map,
    String currentUserId,
  ) {
    final type = ConversationTypeStorage.fromStorage(map['type'] as String?);
    final participantMaps = (map['participants'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((e) => ConversationParticipant.fromMap(
              Map<String, dynamic>.from(e),
            ))
        .toList();

    ConversationParticipant? peer;
    for (final p in participantMaps) {
      if (p.userId != currentUserId) {
        peer = p;
        break;
      }
    }

    final updatedAt = map['updatedAt'];
    final title = map['title'] as String? ?? '';

    return Conversation(
      id: id,
      type: type,
      title: title,
      participantIds:
          (map['participantIds'] as List<dynamic>? ?? []).cast<String>(),
      participants: participantMaps,
      lastMessage: map['lastMessage'] as String? ?? '',
      lastSenderName: map['lastSenderName'] as String? ?? '',
      updatedAt: updatedAt is Timestamp ? updatedAt.toDate() : DateTime.now(),
      createdBy: map['createdBy'] as String?,
      inviteToken: map['inviteToken'] as String?,
      peerPhotoUrl: peer?.photoUrl ?? '',
    );
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

import 'dart:async';

import 'package:atlas_mobile_pi1/core/dataconnect/dc_helpers.dart';
import 'package:atlas_mobile_pi1/dataconnect_generated/atlas.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/user_role.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/entities/chat_message.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/entities/conversation.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/enums/conversation_type.dart';
import 'package:uuid/uuid.dart';

abstract class ConversationsRepository {
  Future<void> ensureGeneralConversation();

  Stream<List<Conversation>> watchInbox(String userId);

  Stream<List<ChatMessage>> watchMessages(
    String conversationId, {
    int limit = 100,
  });

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String text,
  });

  Future<Conversation> getOrCreateDm({
    required AppUser me,
    required AppUser other,
  });

  Future<Conversation> getOrCreateCoachChat({
    required AppUser coach,
    required AppUser student,
  });

  Future<Conversation> createCommunity({
    required String name,
    required AppUser creator,
  });

  Future<Conversation> joinCommunity({
    required String conversationId,
    required AppUser user,
  });

  Future<Conversation?> joinCommunityByToken({
    required String token,
    required AppUser user,
  });

  Future<Conversation?> getConversation(String id);

  Future<List<AppUser>> searchUsersByName(String query, {String? excludeUid});

  Future<List<Conversation>> searchCommunities(String query);

  Future<void> purgeExpiredGeneralMessages();
}

class ConversationsRepositoryImpl implements ConversationsRepository {
  ConversationsRepositoryImpl({AtlasConnector? connector})
      : _dc = connector ?? AtlasConnector.instance;

  final AtlasConnector _dc;
  static const _uuid = Uuid();
  static const generalId = 'general';
  static const generalTtl = Duration(hours: 48);

  Conversation? _cachedGeneral;

  ConversationParticipant _participant(AppUser user) => ConversationParticipant(
        userId: user.id,
        name: user.name ?? user.email,
        username: user.username ?? '',
      );

  Conversation _mapConversation({
    required String id,
    required String type,
    required String title,
    required String lastMessage,
    required String lastSenderName,
    required dynamic updatedAt,
    String? createdBy,
    String? inviteToken,
    required List<ConversationParticipant> participants,
    required String viewerId,
  }) {
    ConversationParticipant? peer;
    for (final p in participants) {
      if (p.userId != viewerId) {
        peer = p;
        break;
      }
    }

    return Conversation(
      id: id,
      type: ConversationTypeStorage.fromStorage(type),
      title: title,
      participantIds: participants.map((p) => p.userId).toList(),
      participants: participants,
      lastMessage: lastMessage,
      lastSenderName: lastSenderName,
      updatedAt: fromDcTimestamp(updatedAt) ?? DateTime.now(),
      createdBy: createdBy,
      inviteToken: inviteToken,
      peerPhotoUrl: peer?.photoUrl ?? '',
    );
  }

  ConversationParticipant _participantFromUser({
    required String id,
    String? name,
    String? username,
  }) {
    return ConversationParticipant(
      userId: id,
      name: (name != null && name.trim().isNotEmpty) ? name : id,
      username: username ?? '',
      photoUrl: '',
    );
  }

  List<ConversationParticipant> _membersFromGet(
    List<GetConversationConversationConversationMembersOnConversation> members,
  ) {
    return members
        .map(
          (m) => _participantFromUser(
            id: m.user.id,
            name: m.user.name,
            username: m.user.username,
          ),
        )
        .toList();
  }

  List<ConversationParticipant> _membersFromInbox(
    List<ListInboxConversationMembersConversationConversationMembersOnConversation>
        members,
  ) {
    return members
        .map(
          (m) => _participantFromUser(
            id: m.user.id,
            name: m.user.name,
            username: m.user.username,
          ),
        )
        .toList();
  }

  Future<void> _addMember(String conversationId, AppUser user) async {
    await _dc
        .addConversationMember(
          conversationId: conversationId,
          userId: user.id,
        )
        .execute();
  }

  @override
  Future<void> ensureGeneralConversation() async {
    final existing = await getConversation(generalId);
    if (existing != null) return;

    await _dc
        .upsertConversation(
          id: generalId,
          type: ConversationType.general.storageName,
          title: 'Geral',
        )
        .titleLower('geral')
        .lastMessage('')
        .lastSenderName('')
        .execute();
  }

  @override
  Stream<List<Conversation>> watchInbox(String userId) {
    return subscribeMapped(
      () => _dc.listInbox(userId: userId).ref(),
      (ListInboxData data) {
        final list = data.conversationMembers
            .map((row) {
              final c = row.conversation;
              return _mapConversation(
                id: c.id,
                type: c.type,
                title: c.title,
                lastMessage: c.lastMessage,
                lastSenderName: c.lastSenderName,
                updatedAt: c.updatedAt,
                createdBy: c.createdBy,
                inviteToken: c.inviteToken,
                participants: _membersFromInbox(
                  c.conversationMembers_on_conversation,
                ),
                viewerId: userId,
              );
            })
            .where((c) => c.type != ConversationType.general)
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return list;
      },
    ).asyncMap((list) async {
      final general = await _loadGeneralConversation(userId);
      return [general, ...list];
    });
  }

  Future<Conversation> _loadGeneralConversation(String userId) async {
    if (_cachedGeneral != null) return _cachedGeneral!;
    try {
      final snap = await getConversation(generalId);
      if (snap != null) {
        _cachedGeneral = snap;
        return snap;
      }
    } catch (_) {}
    _cachedGeneral = Conversation.generalPlaceholder();
    return _cachedGeneral!;
  }

  @override
  Stream<List<ChatMessage>> watchMessages(
    String conversationId, {
    int limit = 100,
  }) {
    return subscribeMapped(
      () => _dc
          .listMessages(conversationId: conversationId)
          .limit(limit)
          .ref(),
      (ListMessagesData data) {
        final now = DateTime.now();
        final messages = data.messages
            .map(
              (m) => ChatMessage(
                id: m.id,
                text: m.text,
                senderId: m.senderId,
                senderName: m.senderName,
                createdAt: fromDcTimestamp(m.createdAt) ?? now,
                expiresAt: fromDcTimestamp(m.expiresAt),
              ),
            )
            .where((m) {
              if (m.expiresAt != null) return m.expiresAt!.isAfter(now);
              if (conversationId == generalId) {
                return now.difference(m.createdAt) < generalTtl;
              }
              return true;
            })
            .toList();
        return messages.reversed.toList();
      },
    );
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final isGeneral = conversationId == generalId;
    final builder = _dc.sendMessage(
      conversationId: conversationId,
      text: trimmed,
      senderId: senderId,
      senderName: senderName,
      createdAt: toDcTimestamp(now),
    );
    if (isGeneral) {
      builder.expiresAt(toDcTimestamp(now.add(generalTtl)));
    }
    await builder.execute();

    await _dc
        .updateConversationLastMessage(
          id: conversationId,
          lastMessage: trimmed,
          lastSenderName: senderName,
          updatedAt: toDcTimestamp(now),
        )
        .execute();

    if (isGeneral) {
      unawaited(purgeExpiredGeneralMessages());
    }
  }

  Future<Conversation> _upsertPairChat({
    required String id,
    required ConversationType type,
    required AppUser a,
    required AppUser b,
    required AppUser viewer,
  }) async {
    final existing = await getConversation(id);
    if (existing != null) return existing;

    await _dc
        .upsertConversation(
          id: id,
          type: type.storageName,
          title: '',
        )
        .lastMessage('')
        .lastSenderName('')
        .createdBy(viewer.id)
        .execute();

    await _addMember(id, a);
    await _addMember(id, b);

    return Conversation(
      id: id,
      type: type,
      title: '',
      participantIds: [a.id, b.id],
      participants: [_participant(a), _participant(b)],
      lastMessage: '',
      updatedAt: DateTime.now(),
      createdBy: viewer.id,
    );
  }

  @override
  Future<Conversation> getOrCreateDm({
    required AppUser me,
    required AppUser other,
  }) async {
    final ids = [me.id, other.id]..sort();
    return _upsertPairChat(
      id: 'dm_${ids[0]}_${ids[1]}',
      type: ConversationType.dm,
      a: me,
      b: other,
      viewer: me,
    );
  }

  @override
  Future<Conversation> getOrCreateCoachChat({
    required AppUser coach,
    required AppUser student,
  }) async {
    final ids = [coach.id, student.id]..sort();
    return _upsertPairChat(
      id: 'coach_${ids[0]}_${ids[1]}',
      type: ConversationType.coach,
      a: coach,
      b: student,
      viewer: coach,
    );
  }

  @override
  Future<Conversation> createCommunity({
    required String name,
    required AppUser creator,
  }) async {
    final id = _uuid.v4();
    final token = _uuid.v4();
    final title = name.trim();
    await _dc
        .upsertConversation(
          id: id,
          type: ConversationType.community.storageName,
          title: title,
        )
        .titleLower(title.toLowerCase())
        .lastMessage('')
        .lastSenderName('')
        .createdBy(creator.id)
        .inviteToken(token)
        .execute();
    await _addMember(id, creator);

    return Conversation(
      id: id,
      type: ConversationType.community,
      title: title,
      participantIds: [creator.id],
      participants: [_participant(creator)],
      lastMessage: '',
      updatedAt: DateTime.now(),
      createdBy: creator.id,
      inviteToken: token,
    );
  }

  @override
  Future<Conversation> joinCommunity({
    required String conversationId,
    required AppUser user,
  }) async {
    final existing = await getConversation(conversationId);
    if (existing == null) {
      throw StateError('Comunidade não encontrada');
    }
    if (existing.type != ConversationType.community) {
      throw StateError('Não é uma comunidade');
    }

    if (!existing.participantIds.contains(user.id)) {
      await _addMember(conversationId, user);
    }

    final fresh = await getConversation(conversationId);
    return fresh ?? existing;
  }

  @override
  Future<Conversation?> joinCommunityByToken({
    required String token,
    required AppUser user,
  }) async {
    final result =
        await _dc.getConversationByInviteToken(token: token).execute();
    final list = result.data.conversations;
    if (list.isEmpty) return null;
    return joinCommunity(conversationId: list.first.id, user: user);
  }

  @override
  Future<Conversation?> getConversation(String id) async {
    final result = await _dc.getConversation(id: id).execute();
    final c = result.data.conversation;
    if (c == null) return null;
    return _mapConversation(
      id: c.id,
      type: c.type,
      title: c.title,
      lastMessage: c.lastMessage,
      lastSenderName: c.lastSenderName,
      updatedAt: c.updatedAt,
      createdBy: c.createdBy,
      inviteToken: c.inviteToken,
      participants: _membersFromGet(c.conversationMembers_on_conversation),
      viewerId: '',
    );
  }

  @override
  Future<List<AppUser>> searchUsersByName(
    String query, {
    String? excludeUid,
  }) async {
    var q = query.trim().toLowerCase();
    if (q.startsWith('@')) q = q.substring(1);
    if (q.isEmpty) return [];

    final end = '$q\uf8ff';
    final byUsername =
        await _dc.searchUsersByUsername(q: q, end: end).execute();
    final byName = await _dc.searchUsersByName(q: q, end: end).execute();

    final seen = <String>{};
    final results = <AppUser>[];

    void addAll(Iterable<dynamic> users) {
      for (final u in users) {
        final id = u.id as String;
        if (!seen.add(id)) continue;
        if (excludeUid != null && id == excludeUid) continue;
        results.add(
          AppUser(
            id: id,
            email: u.email as String,
            name: u.name as String?,
            username: u.username as String?,
            gender: Gender.fromStorage(u.gender as String?),
            height: u.height as double?,
            weight: u.weight as double?,
            birthDate: fromDcTimestamp(u.birthDate),
            activityLevel:
                ActivityLevel.fromStorage(u.activityLevel as String?),
            role: UserRoleStorage.fromStorage(u.role as String?),
            profileCompleted: u.profileCompleted as bool,
            bannerPreset: u.bannerPreset as String?,
            bannerUrl: u.bannerUrl as String?,
            photoUrl: u.photoUrl as String?,
            createdAt: fromDcTimestamp(u.createdAt),
          ),
        );
      }
    }

    addAll(byUsername.data.users);
    addAll(byName.data.users);
    return results;
  }

  @override
  Future<List<Conversation>> searchCommunities(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final end = '$q\uf8ff';
    final result = await _dc.searchCommunities(q: q, end: end).execute();
    return result.data.conversations
        .map(
          (c) => _mapConversation(
            id: c.id,
            type: c.type,
            title: c.title,
            lastMessage: c.lastMessage,
            lastSenderName: c.lastSenderName,
            updatedAt: c.updatedAt,
            createdBy: c.createdBy,
            inviteToken: c.inviteToken,
            participants: c.conversationMembers_on_conversation
                .map(
                  (m) => _participantFromUser(
                    id: m.user.id,
                    name: m.user.name,
                    username: m.user.username,
                  ),
                )
                .toList(),
            viewerId: '',
          ),
        )
        .toList();
  }

  @override
  Future<void> purgeExpiredGeneralMessages() async {
    final cutoff = toDcTimestamp(DateTime.now().subtract(generalTtl));
    final old = await _dc
        .listExpiredGeneralMessages(cutoff: cutoff)
        .limit(50)
        .execute();
    for (final msg in old.data.messages) {
      await _dc.deleteMessage(id: msg.id).execute();
    }
  }
}

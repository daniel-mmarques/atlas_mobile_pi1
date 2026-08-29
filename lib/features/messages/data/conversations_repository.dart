import 'dart:async';

import 'package:atlas_mobile_pi1/core/firestore/firestore_paths.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/entities/chat_message.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/entities/conversation.dart';
import 'package:atlas_mobile_pi1/features/messages/domain/enums/conversation_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract class ConversationsRepository {
  Future<void> ensureGeneralConversation();

  Stream<List<Conversation>> watchInbox(String userId);

  Stream<List<ChatMessage>> watchMessages(String conversationId);

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
  ConversationsRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  static const _uuid = Uuid();
  static const generalId = 'general';
  static const generalTtl = Duration(hours: 48);

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _db.collection(FirestorePaths.conversations);

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection(FirestorePaths.users);

  CollectionReference<Map<String, dynamic>> _messages(String conversationId) =>
      _conversations.doc(conversationId).collection('messages');

  @override
  Future<void> ensureGeneralConversation() async {
    final doc = _conversations.doc(generalId);
    var exists = false;
    try {
      exists = (await doc.get()).exists;
    } on FirebaseException catch (e) {
      // Missing doc + rules that require resource.data → permission-denied.
      if (e.code != 'permission-denied') rethrow;
    }
    if (exists) return;

    await doc.set({
      'type': ConversationType.general.storageName,
      'title': 'Geral',
      'participantIds': <String>[],
      'participants': <Map<String, dynamic>>[],
      'lastMessage': '',
      'lastSenderName': '',
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': null,
    });
  }

  @override
  Stream<List<Conversation>> watchInbox(String userId) {
    return _conversations
        .where('participantIds', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      await ensureGeneralConversation();
      final generalSnap = await _conversations.doc(generalId).get();
      final list = snapshot.docs
          .map((doc) => Conversation.fromMap(doc.id, doc.data(), userId))
          .where((c) => c.type != ConversationType.general)
          .toList();

      final general = generalSnap.exists && generalSnap.data() != null
          ? Conversation.fromMap(generalId, generalSnap.data()!, userId)
          : Conversation.generalPlaceholder();

      return [general, ...list];
    });
  }

  @override
  Stream<List<ChatMessage>> watchMessages(String conversationId) {
    final query = _messages(conversationId).orderBy('createdAt', descending: false);

    return query.snapshots().map((snapshot) {
      final now = DateTime.now();
      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.id, doc.data()))
          .where((m) {
            if (m.expiresAt != null) return m.expiresAt!.isAfter(now);
            if (conversationId == generalId) {
              return now.difference(m.createdAt) < generalTtl;
            }
            return true;
          })
          .toList();
    });
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
    final data = <String, dynamic>{
      'text': trimmed,
      'senderId': senderId,
      'senderName': senderName,
      'createdAt': Timestamp.fromDate(now),
    };
    if (isGeneral) {
      data['expiresAt'] = Timestamp.fromDate(now.add(generalTtl));
    }

    await _messages(conversationId).add(data);
    await _conversations.doc(conversationId).set(
      {
        'lastMessage': trimmed,
        'lastSenderName': senderName,
        'updatedAt': Timestamp.fromDate(now),
      },
      SetOptions(merge: true),
    );

    if (isGeneral) {
      unawaited(purgeExpiredGeneralMessages());
    }
  }

  @override
  Future<Conversation> getOrCreateDm({
    required AppUser me,
    required AppUser other,
  }) async {
    final ids = [me.id, other.id]..sort();
    final id = 'dm_${ids[0]}_${ids[1]}';
    final doc = _conversations.doc(id);
    final snap = await doc.get();
    if (!snap.exists) {
      await doc.set({
        'type': ConversationType.dm.storageName,
        'title': '',
        'participantIds': [me.id, other.id],
        'participants': [
          {'userId': me.id, 'name': me.name ?? me.email, 'photoUrl': ''},
          {'userId': other.id, 'name': other.name ?? other.email, 'photoUrl': ''},
        ],
        'lastMessage': '',
        'lastSenderName': '',
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': me.id,
      });
    }
    final fresh = await doc.get();
    return Conversation.fromMap(id, fresh.data()!, me.id);
  }

  @override
  Future<Conversation> getOrCreateCoachChat({
    required AppUser coach,
    required AppUser student,
  }) async {
    final ids = [coach.id, student.id]..sort();
    final id = 'coach_${ids[0]}_${ids[1]}';
    final doc = _conversations.doc(id);
    final snap = await doc.get();
    if (!snap.exists) {
      await doc.set({
        'type': ConversationType.coach.storageName,
        'title': '',
        'participantIds': [coach.id, student.id],
        'participants': [
          {
            'userId': coach.id,
            'name': coach.name ?? coach.email,
            'photoUrl': '',
          },
          {
            'userId': student.id,
            'name': student.name ?? student.email,
            'photoUrl': '',
          },
        ],
        'lastMessage': '',
        'lastSenderName': '',
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': coach.id,
      });
    }
    final fresh = await doc.get();
    return Conversation.fromMap(id, fresh.data()!, coach.id);
  }

  @override
  Future<Conversation> createCommunity({
    required String name,
    required AppUser creator,
  }) async {
    final id = _uuid.v4();
    final token = _uuid.v4();
    final title = name.trim();
    await _conversations.doc(id).set({
      'type': ConversationType.community.storageName,
      'title': title,
      'titleLower': title.toLowerCase(),
      'participantIds': [creator.id],
      'participants': [
        {
          'userId': creator.id,
          'name': creator.name ?? creator.email,
          'photoUrl': '',
        },
      ],
      'lastMessage': '',
      'lastSenderName': '',
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': creator.id,
      'inviteToken': token,
    });
    final fresh = await _conversations.doc(id).get();
    return Conversation.fromMap(id, fresh.data()!, creator.id);
  }

  @override
  Future<Conversation> joinCommunity({
    required String conversationId,
    required AppUser user,
  }) async {
    final doc = _conversations.doc(conversationId);
    final snap = await doc.get();
    if (!snap.exists || snap.data() == null) {
      throw StateError('Comunidade não encontrada');
    }
    final data = snap.data()!;
    if (ConversationTypeStorage.fromStorage(data['type'] as String?) !=
        ConversationType.community) {
      throw StateError('Não é uma comunidade');
    }

    final participantIds =
        (data['participantIds'] as List<dynamic>? ?? []).cast<String>();
    if (!participantIds.contains(user.id)) {
      final participants = (data['participants'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      participants.add({
        'userId': user.id,
        'name': user.name ?? user.email,
        'photoUrl': '',
      });
      await doc.update({
        'participantIds': FieldValue.arrayUnion([user.id]),
        'participants': participants,
      });
    }

    final fresh = await doc.get();
    return Conversation.fromMap(conversationId, fresh.data()!, user.id);
  }

  @override
  Future<Conversation?> joinCommunityByToken({
    required String token,
    required AppUser user,
  }) async {
    final query = await _conversations
        .where('inviteToken', isEqualTo: token)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return joinCommunity(conversationId: query.docs.first.id, user: user);
  }

  @override
  Future<Conversation?> getConversation(String id) async {
    final snap = await _conversations.doc(id).get();
    if (!snap.exists || snap.data() == null) return null;
    return Conversation.fromMap(id, snap.data()!, '');
  }

  @override
  Future<List<AppUser>> searchUsersByName(
    String query, {
    String? excludeUid,
  }) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final end = '$q\uf8ff';
    final snap = await _users
        .where('nameLower', isGreaterThanOrEqualTo: q)
        .where('nameLower', isLessThanOrEqualTo: end)
        .limit(20)
        .get();

    return snap.docs
        .map((doc) => AppUser.fromMap(doc.id, doc.data()))
        .where((u) => excludeUid == null || u.id != excludeUid)
        .toList();
  }

  @override
  Future<List<Conversation>> searchCommunities(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final end = '$q\uf8ff';
    final snap = await _conversations
        .where('type', isEqualTo: ConversationType.community.storageName)
        .where('titleLower', isGreaterThanOrEqualTo: q)
        .where('titleLower', isLessThanOrEqualTo: end)
        .limit(20)
        .get();

    return snap.docs
        .map((doc) => Conversation.fromMap(doc.id, doc.data(), ''))
        .toList();
  }

  @override
  Future<void> purgeExpiredGeneralMessages() async {
    final cutoff = Timestamp.fromDate(DateTime.now().subtract(generalTtl));
    final old = await _messages(generalId)
        .where('createdAt', isLessThan: cutoff)
        .limit(50)
        .get();
    for (final doc in old.docs) {
      await doc.reference.delete();
    }
  }
}

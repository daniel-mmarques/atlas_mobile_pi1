import 'package:atlas_mobile_pi1/core/firestore/firestore_paths.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/coach/domain/entities/link_invitation.dart';
import 'package:atlas_mobile_pi1/features/coach/domain/enums/coach_enums.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/workout_mapper.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/workout_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract class CoachRepository {
  Future<LinkInvitation> generateInvitation({
    required String creatorId,
    required InvitationRole creatorRole,
  });

  Future<void> acceptInvitation({
    required String token,
    required String acceptorId,
  });

  Stream<List<AppUser>> watchStudents(String coachId);

  Stream<List<AppUser>> watchCoaches(String studentId);

  Future<int> countFinishedWorkouts(String userId);

  Future<void> assignWorkoutToStudent({
    required String coachId,
    required String studentId,
    required String name,
  });
}

class CoachRepositoryImpl implements CoachRepository {
  CoachRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  static const _uuid = Uuid();

  @override
  Future<LinkInvitation> generateInvitation({
    required String creatorId,
    required InvitationRole creatorRole,
  }) async {
    final token = _uuid.v4();
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(days: 7));
    final invitation = LinkInvitation(
      token: token,
      creatorId: creatorId,
      creatorRole: creatorRole,
      expiresAt: expiresAt,
      createdAt: now,
    );

    await _db.collection(FirestorePaths.linkInvitations).doc(token).set({
      'token': token,
      'creatorId': creatorId,
      'creatorRole': creatorRole.storageName,
      'status': InvitationStatus.pending.storageName,
      'expiresAt': Timestamp.fromDate(expiresAt),
      'createdAt': Timestamp.fromDate(now),
    });

    return invitation;
  }

  @override
  Future<void> acceptInvitation({
    required String token,
    required String acceptorId,
  }) async {
    final inviteRef =
        _db.collection(FirestorePaths.linkInvitations).doc(token);
    final snap = await inviteRef.get();
    if (!snap.exists || snap.data() == null) {
      throw StateError('Convite inválido');
    }

    final data = snap.data()!;
    final status =
        InvitationStatusStorage.fromStorage(data['status'] as String?);
    if (status != InvitationStatus.pending) {
      throw StateError('Convite já utilizado');
    }

    final expiresAt = (data['expiresAt'] as Timestamp?)?.toDate();
    if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
      await inviteRef.update({
        'status': InvitationStatus.expired.storageName,
      });
      throw StateError('Convite expirado');
    }

    final creatorId = data['creatorId'] as String? ?? '';
    final creatorRole =
        InvitationRoleStorage.fromStorage(data['creatorRole'] as String?);

    final coachId =
        creatorRole == InvitationRole.coach ? creatorId : acceptorId;
    final studentId =
        creatorRole == InvitationRole.coach ? acceptorId : creatorId;

    if (coachId == studentId) {
      throw StateError('Não é possível vincular a si mesmo');
    }

    final linkId = _uuid.v4();
    final now = DateTime.now();
    await _db.collection(FirestorePaths.coachLinks).doc(linkId).set({
      'id': linkId,
      'coachId': coachId,
      'studentId': studentId,
      'status': LinkStatus.active.storageName,
      'linkedAt': Timestamp.fromDate(now),
      'createdAt': Timestamp.fromDate(now),
    });

    await inviteRef.update({
      'status': InvitationStatus.accepted.storageName,
    });
  }

  @override
  Stream<List<AppUser>> watchStudents(String coachId) {
    return _db
        .collection(FirestorePaths.coachLinks)
        .where('coachId', isEqualTo: coachId)
        .where('status', isEqualTo: LinkStatus.active.storageName)
        .snapshots()
        .asyncMap((snapshot) async {
      final ids = snapshot.docs
          .map((doc) => doc.data()['studentId'] as String?)
          .whereType<String>()
          .toList();
      return _fetchUsersByIds(ids);
    });
  }

  @override
  Stream<List<AppUser>> watchCoaches(String studentId) {
    return _db
        .collection(FirestorePaths.coachLinks)
        .where('studentId', isEqualTo: studentId)
        .where('status', isEqualTo: LinkStatus.active.storageName)
        .snapshots()
        .asyncMap((snapshot) async {
      final ids = snapshot.docs
          .map((doc) => doc.data()['coachId'] as String?)
          .whereType<String>()
          .toList();
      return _fetchUsersByIds(ids);
    });
  }

  /// Firestore `whereIn` supports at most 30 ids per query.
  Future<List<AppUser>> _fetchUsersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final unique = ids.toSet().toList();
    final users = <AppUser>[];
    const chunkSize = 30;
    for (var i = 0; i < unique.length; i += chunkSize) {
      final end = (i + chunkSize < unique.length) ? i + chunkSize : unique.length;
      final chunk = unique.sublist(i, end);
      final snap = await _db
          .collection(FirestorePaths.users)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in snap.docs) {
        users.add(AppUser.fromMap(doc.id, doc.data()));
      }
    }
    return users;
  }

  @override
  Future<int> countFinishedWorkouts(String userId) async {
    final snap = await _db
        .collection(FirestorePaths.workouts)
        .where('userId', isEqualTo: userId)
        .limit(100)
        .get();
    return snap.docs.where((doc) => doc.data()['finishedAt'] != null).length;
  }

  @override
  Future<void> assignWorkoutToStudent({
    required String coachId,
    required String studentId,
    required String name,
  }) async {
    final id = _uuid.v4();
    final workout = Workout(
      id: id,
      userId: studentId,
      name: name,
      startedAt: DateTime.now(),
      exercises: const [],
      assignedByCoachId: coachId,
      source: WorkoutSource.coachAssigned,
    );
    await _db
        .collection(FirestorePaths.workouts)
        .doc(id)
        .set(WorkoutMapper.toMap(workout));
  }
}

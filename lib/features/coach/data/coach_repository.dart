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
      final students = <AppUser>[];
      for (final doc in snapshot.docs) {
        final studentId = doc.data()['studentId'] as String?;
        if (studentId == null) continue;
        final userSnap =
            await _db.collection(FirestorePaths.users).doc(studentId).get();
        if (userSnap.exists && userSnap.data() != null) {
          students.add(AppUser.fromMap(userSnap.id, userSnap.data()!));
        }
      }
      return students;
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
      final coaches = <AppUser>[];
      for (final doc in snapshot.docs) {
        final coachId = doc.data()['coachId'] as String?;
        if (coachId == null) continue;
        final userSnap =
            await _db.collection(FirestorePaths.users).doc(coachId).get();
        if (userSnap.exists && userSnap.data() != null) {
          coaches.add(AppUser.fromMap(userSnap.id, userSnap.data()!));
        }
      }
      return coaches;
    });
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

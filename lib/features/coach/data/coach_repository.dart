import 'package:atlas_mobile_pi1/core/dataconnect/dc_helpers.dart';
import 'package:atlas_mobile_pi1/dataconnect_generated/atlas.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/user_role.dart';
import 'package:atlas_mobile_pi1/features/coach/domain/entities/link_invitation.dart';
import 'package:atlas_mobile_pi1/features/coach/domain/enums/coach_enums.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/enums/workout_source.dart';
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
  CoachRepositoryImpl({AtlasConnector? connector})
      : _dc = connector ?? AtlasConnector.instance;

  final AtlasConnector _dc;
  static const _uuid = Uuid();

  AppUser _mapUser(GetUsersByIdsUsers u) {
    return AppUser(
      id: u.id,
      email: u.email,
      name: u.name,
      username: u.username,
      gender: Gender.fromStorage(u.gender),
      height: u.height,
      weight: u.weight,
      birthDate: fromDcTimestamp(u.birthDate),
      activityLevel: ActivityLevel.fromStorage(u.activityLevel),
      role: UserRoleStorage.fromStorage(u.role),
      profileCompleted: u.profileCompleted,
      bannerPreset: u.bannerPreset,
      bannerUrl: u.bannerUrl,
      photoUrl: u.photoUrl,
      createdAt: fromDcTimestamp(u.createdAt),
    );
  }

  Future<List<AppUser>> _fetchUsersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final result =
        await _dc.getUsersByIds(ids: ids.toSet().toList()).execute();
    return result.data.users.map(_mapUser).toList();
  }

  @override
  Future<LinkInvitation> generateInvitation({
    required String creatorId,
    required InvitationRole creatorRole,
  }) async {
    final token = _uuid.v4();
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(days: 7));
    await _dc
        .createLinkInvitation(
          token: token,
          creatorId: creatorId,
          creatorRole: creatorRole.storageName,
          expiresAt: toDcTimestamp(expiresAt),
        )
        .execute();

    return LinkInvitation(
      token: token,
      creatorId: creatorId,
      creatorRole: creatorRole,
      expiresAt: expiresAt,
      createdAt: now,
    );
  }

  @override
  Future<void> acceptInvitation({
    required String token,
    required String acceptorId,
  }) async {
    final result = await _dc.getLinkInvitation(token: token).execute();
    final invite = result.data.linkInvitation;
    if (invite == null) {
      throw StateError('Convite inválido');
    }

    final status = InvitationStatusStorage.fromStorage(invite.status);
    if (status != InvitationStatus.pending) {
      throw StateError('Convite já utilizado');
    }

    final expiresAt = fromDcTimestamp(invite.expiresAt);
    if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
      await _dc
          .updateLinkInvitationStatus(
            token: token,
            status: InvitationStatus.expired.storageName,
          )
          .execute();
      throw StateError('Convite expirado');
    }

    final creatorRole =
        InvitationRoleStorage.fromStorage(invite.creatorRole);
    final coachId =
        creatorRole == InvitationRole.coach ? invite.creatorId : acceptorId;
    final studentId =
        creatorRole == InvitationRole.coach ? acceptorId : invite.creatorId;

    if (coachId == studentId) {
      throw StateError('Não é possível vincular a si mesmo');
    }

    await _dc
        .createCoachLink(coachId: coachId, studentId: studentId)
        .execute();
    await _dc
        .updateLinkInvitationStatus(
          token: token,
          status: InvitationStatus.accepted.storageName,
        )
        .execute();
  }

  @override
  Stream<List<AppUser>> watchStudents(String coachId) {
    return subscribeMapped(
      () => _dc.listCoachLinksByCoach(coachId: coachId).ref(),
      (ListCoachLinksByCoachData data) => data,
    ).asyncMap((data) async {
      final ids = data.coachLinks.map((l) => l.studentId).toList();
      return _fetchUsersByIds(ids);
    });
  }

  @override
  Stream<List<AppUser>> watchCoaches(String studentId) {
    return subscribeMapped(
      () => _dc.listCoachLinksByStudent(studentId: studentId).ref(),
      (ListCoachLinksByStudentData data) => data,
    ).asyncMap((data) async {
      final ids = data.coachLinks.map((l) => l.coachId).toList();
      return _fetchUsersByIds(ids);
    });
  }

  @override
  Future<int> countFinishedWorkouts(String userId) async {
    final result = await _dc.countUserWorkouts(userId: userId).execute();
    return result.data.workouts.where((w) => w.finishedAt != null).length;
  }

  @override
  Future<void> assignWorkoutToStudent({
    required String coachId,
    required String studentId,
    required String name,
  }) async {
    await _dc
        .assignWorkoutToStudent(
          id: _uuid.v4(),
          studentId: studentId,
          name: name,
          startedAt: toDcTimestamp(DateTime.now()),
          coachId: coachId,
          source: WorkoutSource.coachAssigned.dbIndex,
        )
        .execute();
  }
}

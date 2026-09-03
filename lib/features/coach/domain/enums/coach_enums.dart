enum InvitationRole {
  coach,
  student,
}

extension InvitationRoleStorage on InvitationRole {
  String get storageName => name;

  static InvitationRole fromStorage(String? value) => switch (value) {
        'student' => InvitationRole.student,
        _ => InvitationRole.coach,
      };
}

enum InvitationStatus {
  pending,
  accepted,
  expired,
}

extension InvitationStatusStorage on InvitationStatus {
  String get storageName => name;

  static InvitationStatus fromStorage(String? value) => switch (value) {
        'accepted' => InvitationStatus.accepted,
        'expired' => InvitationStatus.expired,
        _ => InvitationStatus.pending,
      };
}

enum LinkStatus {
  pending,
  active,
  revoked,
}

extension LinkStatusStorage on LinkStatus {
  String get storageName => name;

  static LinkStatus fromStorage(String? value) => switch (value) {
        'active' => LinkStatus.active,
        'revoked' => LinkStatus.revoked,
        _ => LinkStatus.pending,
      };
}

import 'package:atlas_mobile_pi1/features/coach/domain/enums/coach_enums.dart';

class LinkInvitation {
  const LinkInvitation({
    required this.token,
    required this.creatorId,
    required this.creatorRole,
    this.status = InvitationStatus.pending,
    required this.expiresAt,
    required this.createdAt,
  });

  final String token;
  final String creatorId;
  final InvitationRole creatorRole;
  final InvitationStatus status;
  final DateTime expiresAt;
  final DateTime createdAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  LinkInvitation copyWith({InvitationStatus? status}) {
    return LinkInvitation(
      token: token,
      creatorId: creatorId,
      creatorRole: creatorRole,
      status: status ?? this.status,
      expiresAt: expiresAt,
      createdAt: createdAt,
    );
  }
}

import 'package:atlas_mobile_pi1/features/coach/domain/enums/coach_enums.dart';

class CoachStudentLink {
  const CoachStudentLink({
    required this.id,
    required this.coachId,
    required this.studentId,
    this.status = LinkStatus.pending,
    this.linkedAt,
    required this.createdAt,
  });

  final String id;
  final String coachId;
  final String studentId;
  final LinkStatus status;
  final DateTime? linkedAt;
  final DateTime createdAt;
}

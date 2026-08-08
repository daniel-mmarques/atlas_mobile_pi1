import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';

abstract class UserRepository {
  Future<void> createUserIfNotExists(String uid, String email);

  Future<AppUser?> getUser(String uid);

  Stream<AppUser?> watchUser(String uid);

  Future<void> completeProfile({
    required String uid,
    required String name,
    required DateTime birthDate,
    required Gender gender,
    required double height,
    required double weight,
    required ActivityLevel activityLevel,
  });
}

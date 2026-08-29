import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/user_role.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.gender,
    this.height,
    this.weight,
    this.birthDate,
    this.activityLevel,
    this.role = UserRole.student,
    this.profileCompleted = false,
    this.createdAt,
  });

  final String id;
  final String email;
  final String? name;
  final Gender? gender;
  final double? height;
  final double? weight;
  final DateTime? birthDate;
  final ActivityLevel? activityLevel;
  final UserRole role;
  final bool profileCompleted;
  final DateTime? createdAt;

  bool get isCoach => role == UserRole.coach;

  AppUser copyWith({
    String? name,
    Gender? gender,
    double? height,
    double? weight,
    DateTime? birthDate,
    ActivityLevel? activityLevel,
    UserRole? role,
    bool? profileCompleted,
  }) {
    return AppUser(
      id: id,
      email: email,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      birthDate: birthDate ?? this.birthDate,
      activityLevel: activityLevel ?? this.activityLevel,
      role: role ?? this.role,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'email': email,
      'name': name,
      'gender': gender?.name,
      'height': height,
      'weight': weight,
      'birthDate': birthDate,
      'activityLevel': activityLevel?.name,
      'role': role.storageName,
      'profileCompleted': profileCompleted,
      'createdAt': createdAt,
    };
  }

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      email: data['email'] as String? ?? '',
      name: data['name'] as String?,
      gender: Gender.fromStorage(data['gender'] as String?),
      height: (data['height'] as num?)?.toDouble(),
      weight: (data['weight'] as num?)?.toDouble(),
      birthDate: _parseDate(data['birthDate']),
      activityLevel:
          ActivityLevel.fromStorage(data['activityLevel'] as String?),
      role: UserRoleStorage.fromStorage(data['role'] as String?),
      profileCompleted: data['profileCompleted'] as bool? ?? false,
      createdAt: _parseDate(data['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    try {
      return (value as dynamic).toDate() as DateTime?;
    } catch (_) {
      return null;
    }
  }
}

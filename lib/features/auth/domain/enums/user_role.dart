enum UserRole {
  student,
  coach,
}

extension UserRoleStorage on UserRole {
  String get storageName => name;

  static UserRole fromStorage(String? value) {
    return switch (value) {
      'coach' => UserRole.coach,
      _ => UserRole.student,
    };
  }
}

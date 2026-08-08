enum Gender {
  male,
  female,
  other;

  String get label {
    switch (this) {
      case Gender.male:
        return 'Masculino';
      case Gender.female:
        return 'Feminino';
      case Gender.other:
        return 'Outro';
    }
  }

  static Gender? fromStorage(String? value) {
    if (value == null) return null;
    for (final g in Gender.values) {
      if (g.name == value) return g;
    }
    return null;
  }
}

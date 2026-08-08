enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extremelyActive;

  String get label {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentário';
      case ActivityLevel.lightlyActive:
        return 'Pouco ativo';
      case ActivityLevel.moderatelyActive:
        return 'Moderadamente ativo';
      case ActivityLevel.veryActive:
        return 'Muito ativo';
      case ActivityLevel.extremelyActive:
        return 'Extremamente ativo';
    }
  }

  static ActivityLevel? fromStorage(String? value) {
    if (value == null) return null;
    for (final level in ActivityLevel.values) {
      if (level.name == value) return level;
    }
    return null;
  }
}

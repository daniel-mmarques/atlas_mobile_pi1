abstract final class ApiKeys {
  static const exerciseDb = String.fromEnvironment('EXERCISEDB_API_KEY');

  static bool get hasExerciseDbKey => exerciseDb.trim().isNotEmpty;
}

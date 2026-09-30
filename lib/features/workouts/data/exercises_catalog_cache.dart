import 'dart:convert';

import 'package:atlas_mobile_pi1/features/workouts/domain/entities/catalog_exercise.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExercisesCatalogCache {
  ExercisesCatalogCache(this._prefs);

  final SharedPreferences _prefs;

  static const _bodyPartsKey = 'edb_body_parts_v1';
  static const _equipmentsKey = 'edb_equipments_v1';
  static String _bodyPartKey(String part) =>
      'edb_body_part_v1_${part.toUpperCase()}';
  static const _indexKey = 'edb_exercise_index_v1';

  List<String>? readBodyParts() {
    final raw = _prefs.getString(_bodyPartsKey);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! List) return null;
    return decoded.map((e) => e.toString()).toList();
  }

  Future<void> writeBodyParts(List<String> parts) async {
    await _prefs.setString(_bodyPartsKey, jsonEncode(parts));
  }

  List<String>? readEquipments() {
    final raw = _prefs.getString(_equipmentsKey);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! List) return null;
    return decoded.map((e) => e.toString()).toList();
  }

  Future<void> writeEquipments(List<String> equipments) async {
    await _prefs.setString(_equipmentsKey, jsonEncode(equipments));
  }

  List<CatalogExercise>? readByBodyPart(String bodyPart) {
    final raw = _prefs.getString(_bodyPartKey(bodyPart));
    if (raw == null || raw.isEmpty) return null;
    return _decodeExercises(raw);
  }

  Future<void> writeByBodyPart(
    String bodyPart,
    List<CatalogExercise> exercises,
  ) async {
    await _prefs.setString(
      _bodyPartKey(bodyPart),
      jsonEncode(exercises.map((e) => e.toJson()).toList()),
    );
    await _mergeIndex(exercises);
  }

  List<CatalogExercise> readIndex() {
    final raw = _prefs.getString(_indexKey);
    if (raw == null || raw.isEmpty) return const [];
    return _decodeExercises(raw) ?? const [];
  }

  Future<void> upsertExercises(List<CatalogExercise> exercises) async {
    await _mergeIndex(exercises);
  }

  Future<void> _mergeIndex(List<CatalogExercise> exercises) async {
    if (exercises.isEmpty) return;
    final map = <String, CatalogExercise>{
      for (final e in readIndex()) e.id: e,
    };
    for (final e in exercises) {
      final existing = map[e.id];
      map[e.id] = existing == null
          ? e
          : existing.copyWith(
              name: e.name.isNotEmpty ? e.name : null,
              imageUrl: e.imageUrl.isNotEmpty ? e.imageUrl : null,
              videoUrl: e.videoUrl.isNotEmpty ? e.videoUrl : null,
              bodyParts: e.bodyParts.isNotEmpty ? e.bodyParts : null,
              targetMuscles:
                  e.targetMuscles.isNotEmpty ? e.targetMuscles : null,
              secondaryMuscles:
                  e.secondaryMuscles.isNotEmpty ? e.secondaryMuscles : null,
              equipments: e.equipments.isNotEmpty ? e.equipments : null,
              instructions:
                  e.instructions.isNotEmpty ? e.instructions : null,
              overview: e.overview.isNotEmpty ? e.overview : null,
            );
    }
    await _prefs.setString(
      _indexKey,
      jsonEncode(map.values.map((e) => e.toJson()).toList()),
    );
  }

  List<CatalogExercise>? _decodeExercises(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return null;
    return decoded
        .whereType<Map>()
        .map((e) => CatalogExercise.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

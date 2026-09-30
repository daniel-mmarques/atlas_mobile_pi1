import 'dart:async';

import 'package:atlas_mobile_pi1/features/workouts/data/exercise_db_api_client.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/exercises_catalog_cache.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/seed_exercises.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/catalog_exercise.dart';

class ExercisesCatalogRepository {
  ExercisesCatalogRepository({
    required ExerciseDbApiClient api,
    required ExercisesCatalogCache cache,
  })  : _api = api,
        _cache = cache;

  final ExerciseDbApiClient _api;
  final ExercisesCatalogCache _cache;

  List<String>? _memoryBodyParts;
  List<String>? _memoryEquipments;
  final Map<String, List<CatalogExercise>> _memoryByBodyPart = {};
  List<CatalogExercise>? _memoryIndex;

  static List<CatalogExercise> get _seedCatalog => seedExercises
      .map(
        (e) => CatalogExercise(
          id: e['id'] ?? '',
          name: e['name'] ?? '',
        ),
      )
      .where((e) => e.id.isNotEmpty)
      .toList();

  Future<List<String>> bodyParts({bool sync = true}) async {
    if (_memoryBodyParts != null && _memoryBodyParts!.isNotEmpty) {
      if (sync) unawaited(_syncBodyParts());
      return _memoryBodyParts!;
    }

    final disk = _cache.readBodyParts();
    if (disk != null && disk.isNotEmpty) {
      _memoryBodyParts = disk;
      if (sync) unawaited(_syncBodyParts());
      return disk;
    }

    if (_api.isConfigured) {
      try {
        final remote = await _api.fetchBodyParts();
        if (remote.isNotEmpty) {
          _memoryBodyParts = remote;
          await _cache.writeBodyParts(remote);
          return remote;
        }
      } catch (_) {}
    }

    final fallback = _defaultBodyParts;
    _memoryBodyParts = fallback;
    return fallback;
  }

  Future<List<CatalogExercise>> byBodyPart(
    String bodyPart, {
    bool sync = true,
  }) async {
    final key = bodyPart.toUpperCase();

    final memory = _memoryByBodyPart[key];
    if (memory != null && memory.isNotEmpty) {
      if (sync) unawaited(_syncBodyPart(key));
      return memory;
    }

    final disk = _cache.readByBodyPart(key);
    if (disk != null && disk.isNotEmpty) {
      _memoryByBodyPart[key] = disk;
      if (sync) unawaited(_syncBodyPart(key));
      return disk;
    }

    if (_api.isConfigured) {
      try {
        final remote = await _api.fetchByBodyPart(key);
        if (remote.isNotEmpty) {
          _memoryByBodyPart[key] = remote;
          await _cache.writeByBodyPart(key, remote);
          return remote;
        }
      } catch (_) {}
    }

    final seed = _seedCatalog;
    _memoryByBodyPart[key] = seed;
    return seed;
  }

  Future<List<CatalogExercise>> search(String query, {bool sync = true}) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];

    final local = _localIndex()
        .where((e) => e.name.toLowerCase().contains(q))
        .toList();

    if (!sync || !_api.isConfigured) return local;

    try {
      final remote = await _api.search(q);
      if (remote.isNotEmpty) {
        await _cache.upsertExercises(remote);
        _memoryIndex = null;
        final merged = <String, CatalogExercise>{
          for (final e in local) e.id: e,
          for (final e in remote) e.id: e,
        };
        return merged.values.toList();
      }
    } catch (_) {}
    return local;
  }

  Future<CatalogExercise?> getById(String id, {bool sync = true}) async {
    CatalogExercise? cached;
    for (final e in _localIndex()) {
      if (e.id == id) {
        cached = e;
        break;
      }
    }

    if (cached != null &&
        cached.videoUrl.isNotEmpty &&
        cached.instructions.isNotEmpty) {
      return cached;
    }

    if (!sync || !_api.isConfigured) return cached;

    try {
      final remote = await _api.fetchById(id);
      if (remote != null) {
        await _cache.upsertExercises([remote]);
        _memoryIndex = null;
        return remote;
      }
    } catch (_) {}
    return cached;
  }

  Future<List<String>> equipments({bool sync = true}) async {
    if (_memoryEquipments != null && _memoryEquipments!.isNotEmpty) {
      if (sync) unawaited(_syncEquipments());
      return _memoryEquipments!;
    }

    final disk = _cache.readEquipments();
    if (disk != null && disk.isNotEmpty) {
      _memoryEquipments = disk;
      if (sync) unawaited(_syncEquipments());
      return disk;
    }

    if (_api.isConfigured) {
      try {
        final remote = await _api.fetchEquipments();
        if (remote.isNotEmpty) {
          _memoryEquipments = remote;
          await _cache.writeEquipments(remote);
          return remote;
        }
      } catch (_) {}
    }

    final fallback = _defaultEquipments;
    _memoryEquipments = fallback;
    return fallback;
  }

  Future<List<CatalogExercise>> filter({
    String? bodyPart,
    String? equipment,
    String? query,
    bool sync = true,
  }) async {
    final q = query?.trim() ?? '';
    final part = bodyPart?.trim();
    final equip = equipment?.trim();
    final hasPart = part != null && part.isNotEmpty;
    final hasEquip = equip != null && equip.isNotEmpty;

    List<CatalogExercise> local = _localIndex();
    if (hasPart) {
      local = local
          .where(
            (e) => e.bodyParts.any(
              (b) => b.toUpperCase() == part.toUpperCase(),
            ),
          )
          .toList();
    }
    if (hasEquip) {
      local = local
          .where(
            (e) => e.equipments.any(
              (eq) => eq.toUpperCase() == equip.toUpperCase(),
            ),
          )
          .toList();
    }
    if (q.isNotEmpty) {
      final lower = q.toLowerCase();
      local = local.where((e) => e.name.toLowerCase().contains(lower)).toList();
    }

    if (!hasPart && !hasEquip && q.isEmpty) {
      local = _localIndex();
    }

    if (!sync || !_api.isConfigured) {
      if (local.isNotEmpty) return local;
      if (hasPart) return byBodyPart(part, sync: false);
      return _seedCatalog;
    }

    try {
      final remote = await _api.fetchFiltered(
        bodyPart: hasPart ? part : null,
        equipment: hasEquip ? equip : null,
        name: q.isNotEmpty ? q : null,
      );
      if (remote.isNotEmpty) {
        await _cache.upsertExercises(remote);
        if (hasPart && !hasEquip && q.isEmpty) {
          _memoryByBodyPart[part.toUpperCase()] = remote;
          await _cache.writeByBodyPart(part.toUpperCase(), remote);
        }
        _memoryIndex = null;
        return remote;
      }
    } catch (_) {}

    if (local.isNotEmpty) return local;
    if (hasPart) return byBodyPart(part, sync: false);
    return _seedCatalog;
  }

  Future<void> _syncEquipments() async {
    if (!_api.isConfigured) return;
    try {
      final remote = await _api.fetchEquipments();
      if (remote.isEmpty) return;
      _memoryEquipments = remote;
      await _cache.writeEquipments(remote);
    } catch (_) {}
  }

  Future<void> _syncBodyParts() async {
    if (!_api.isConfigured) return;
    try {
      final remote = await _api.fetchBodyParts();
      if (remote.isEmpty) return;
      _memoryBodyParts = remote;
      await _cache.writeBodyParts(remote);
    } catch (_) {}
  }

  Future<void> _syncBodyPart(String bodyPart) async {
    if (!_api.isConfigured) return;
    try {
      final remote = await _api.fetchByBodyPart(bodyPart);
      if (remote.isEmpty) return;
      _memoryByBodyPart[bodyPart] = remote;
      await _cache.writeByBodyPart(bodyPart, remote);
    } catch (_) {}
  }

  List<CatalogExercise> _localIndex() {
    if (_memoryIndex != null) return _memoryIndex!;
    final disk = _cache.readIndex();
    final merged = <String, CatalogExercise>{
      for (final e in _seedCatalog) e.id: e,
      for (final e in disk) e.id: e,
      for (final list in _memoryByBodyPart.values)
        for (final e in list) e.id: e,
    };
    _memoryIndex = merged.values.toList();
    return _memoryIndex!;
  }

  static const _defaultBodyParts = [
    'CHEST',
    'BACK',
    'SHOULDERS',
    'BICEPS',
    'TRICEPS',
    'THIGHS',
    'HAMSTRINGS',
    'QUADRICEPS',
    'CALVES',
    'WAIST',
    'FULL BODY',
  ];

  static const _defaultEquipments = [
    'BARBELL',
    'DUMBBELL',
    'BODY WEIGHT',
    'CABLE',
    'MACHINE',
    'KETTLEBELL',
    'BAND',
  ];
}

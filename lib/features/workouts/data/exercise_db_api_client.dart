import 'package:atlas_mobile_pi1/core/config/api_keys.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/catalog_exercise.dart';
import 'package:dio/dio.dart';

class ExerciseDbApiClient {
  ExerciseDbApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl:
                    'https://edb-with-videos-and-images-by-ascendapi.p.rapidapi.com',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 20),
                headers: {
                  'X-RapidAPI-Key': ApiKeys.exerciseDb,
                  'X-RapidAPI-Host':
                      'edb-with-videos-and-images-by-ascendapi.p.rapidapi.com',
                  'Content-Type': 'application/json',
                },
              ),
            );

  final Dio _dio;

  bool get isConfigured => ApiKeys.hasExerciseDbKey;

  Future<List<String>> fetchBodyParts() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/bodyparts');
    final data = response.data?['data'];
    if (data is! List) return const [];
    return data
        .map((e) {
          if (e is Map && e['name'] != null) return e['name'].toString();
          return e.toString();
        })
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  Future<List<String>> fetchEquipments() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/equipments');
    final data = response.data?['data'];
    if (data is! List) return const [];
    return data
        .map((e) {
          if (e is Map && e['name'] != null) return e['name'].toString();
          return e.toString();
        })
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  Future<List<CatalogExercise>> fetchFiltered({
    String? bodyPart,
    String? equipment,
    String? name,
    int limit = 25,
  }) async {
    final params = <String, dynamic>{'limit': limit};
    if (bodyPart != null && bodyPart.trim().isNotEmpty) {
      params['bodyParts'] = bodyPart.trim();
    }
    if (equipment != null && equipment.trim().isNotEmpty) {
      params['equipments'] = equipment.trim();
    }
    if (name != null && name.trim().isNotEmpty) {
      params['name'] = name.trim();
    }
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/exercises',
      queryParameters: params,
    );
    return _parseExerciseList(response.data);
  }

  Future<List<CatalogExercise>> fetchByBodyPart(
    String bodyPart, {
    int limit = 25,
  }) {
    return fetchFiltered(bodyPart: bodyPart, limit: limit);
  }

  Future<List<CatalogExercise>> search(String query, {int limit = 25}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/v1/exercises',
        queryParameters: {
          'name': trimmed,
          'limit': limit,
        },
      );
      final list = _parseExerciseList(response.data);
      if (list.isNotEmpty) return list;
    } catch (_) {
      // Fall through to /search endpoint.
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/exercises/search',
      queryParameters: {'search': trimmed},
    );
    return _parseExerciseList(response.data);
  }

  Future<CatalogExercise?> fetchById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/exercises/$id',
    );
    final data = response.data?['data'];
    if (data is! Map) return null;
    return CatalogExercise.fromJson(Map<String, dynamic>.from(data));
  }

  List<CatalogExercise> _parseExerciseList(Map<String, dynamic>? payload) {
    final data = payload?['data'];
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((e) => CatalogExercise.fromJson(Map<String, dynamic>.from(e)))
        .where((e) => e.id.isNotEmpty && e.name.isNotEmpty)
        .toList();
  }
}

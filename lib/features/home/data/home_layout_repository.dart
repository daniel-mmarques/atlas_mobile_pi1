import 'dart:convert';

import 'package:atlas_mobile_pi1/data/datasources/local/preferences/repository_preferences.dart';
import 'package:atlas_mobile_pi1/data/datasources/local/preferences/repository_preferences_keys.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeLayoutRepository {
  HomeLayoutRepository({SharedPreferences? prefs})
      : _prefs = prefs ?? PreferencesRepository.instance.sharedPreferences;

  final SharedPreferences _prefs;

  HomeLayout load(String userId) {
    final raw = _prefs.getString(PreferencesKeys.homeLayout(userId));
    if (raw == null || raw.isEmpty) return const HomeLayout();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return HomeLayout.fromJson(decoded);
      }
      if (decoded is Map) {
        return HomeLayout.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {
      return const HomeLayout();
    }
    return const HomeLayout();
  }

  Future<void> save(String userId, HomeLayout layout) async {
    await _prefs.setString(
      PreferencesKeys.homeLayout(userId),
      jsonEncode(layout.toJson()),
    );
  }

  Future<void> clear(String userId) async {
    await _prefs.remove(PreferencesKeys.homeLayout(userId));
  }
}

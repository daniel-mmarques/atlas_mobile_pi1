import 'package:atlas_mobile_pi1/features/home/data/home_layout_repository.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_layout.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:flutter/foundation.dart';

class HomeDashboardController extends ChangeNotifier {
  HomeDashboardController({
    required String userId,
    HomeLayoutRepository? repository,
  })  : _userId = userId,
        _repository = repository ?? HomeLayoutRepository();

  final String _userId;
  final HomeLayoutRepository _repository;

  HomeLayout _layout = const HomeLayout();
  bool _loaded = false;

  HomeLayout get layout => _layout;
  List<HomeWidgetInstance> get widgets => _layout.sortedWidgets;
  bool get isEmpty => _layout.isEmpty;
  bool get isLoaded => _loaded;

  HomeDashboardController load() {
    _layout = _repository.load(_userId);
    _loaded = true;
    notifyListeners();
    return this;
  }

  Future<void> addWidget({
    required HomeWidgetType type,
    required HomeWidgetStyle style,
    required HomeWidgetSize size,
    required String name,
  }) async {
    final order = _layout.widgets.isEmpty
        ? 0
        : _layout.widgets.map((w) => w.order).reduce((a, b) => a > b ? a : b) +
            1;

    final trimmed = name.trim();
    final instance = HomeWidgetInstance(
      id: 'hw_${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      style: style,
      size: size,
      order: order,
      name: trimmed.isEmpty
          ? switch (type) {
              HomeWidgetType.streak => 'Streak',
              HomeWidgetType.weeklyVolume => 'Volume',
              HomeWidgetType.frequency => 'Frequência',
              HomeWidgetType.personalRecords => 'PRs',
              HomeWidgetType.avgDuration => 'Duração',
            }
          : trimmed,
    );

    _layout = _layout.copyWith(
      widgets: [..._layout.widgets, instance],
    );
    notifyListeners();
    await _repository.save(_userId, _layout);
  }

  Future<void> updateWidget(
    String id, {
    HomeWidgetStyle? style,
    HomeWidgetSize? size,
    String? name,
  }) async {
    final updated = _layout.widgets.map((w) {
      if (w.id != id) return w;
      return w.copyWith(
        style: style ?? w.style,
        size: size ?? w.size,
        name: name ?? w.name,
      );
    }).toList();

    _layout = _layout.copyWith(widgets: updated);
    notifyListeners();
    await _repository.save(_userId, _layout);
  }

  Future<void> removeWidget(String id) async {
    _layout = _layout.copyWith(
      widgets: _layout.widgets.where((w) => w.id != id).toList(),
    );
    notifyListeners();
    await _repository.save(_userId, _layout);
  }
}

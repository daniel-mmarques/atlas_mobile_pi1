import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';

class HomeLayout {
  const HomeLayout({this.widgets = const []});

  final List<HomeWidgetInstance> widgets;

  bool get isEmpty => widgets.isEmpty;

  List<HomeWidgetInstance> get sortedWidgets {
    final copy = List<HomeWidgetInstance>.from(widgets);
    copy.sort((a, b) => a.order.compareTo(b.order));
    return copy;
  }

  HomeLayout copyWith({List<HomeWidgetInstance>? widgets}) {
    return HomeLayout(widgets: widgets ?? this.widgets);
  }

  Map<String, dynamic> toJson() => {
        'widgets': widgets.map((w) => w.toJson()).toList(),
      };

  factory HomeLayout.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const HomeLayout();
    final raw = json['widgets'];
    if (raw is! List) return const HomeLayout();
    return HomeLayout(
      widgets: raw
          .whereType<Map>()
          .map(
            (e) => HomeWidgetInstance.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .where((w) => w.id.isNotEmpty)
          .toList(),
    );
  }
}

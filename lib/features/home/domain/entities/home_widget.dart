enum HomeWidgetType {
  streak,
  weeklyVolume,
  frequency,
  personalRecords,
  avgDuration;

  List<HomeWidgetStyle> get supportedStyles => switch (this) {
    HomeWidgetType.streak => const [
      HomeWidgetStyle.number,
      HomeWidgetStyle.calendar,
    ],
    HomeWidgetType.weeklyVolume => const [
      HomeWidgetStyle.number,
      HomeWidgetStyle.chart,
    ],
    HomeWidgetType.frequency => const [
      HomeWidgetStyle.number,
      HomeWidgetStyle.list,
    ],
    HomeWidgetType.personalRecords => const [
      HomeWidgetStyle.number,
      HomeWidgetStyle.list,
    ],
    HomeWidgetType.avgDuration => const [HomeWidgetStyle.number],
  };

  /// Layouts offered in the size carousel (height × width). Max 2×2.
  List<HomeWidgetSize> get supportedSizes => const [
    HomeWidgetSize.s1x1,
    HomeWidgetSize.s1x2,
    HomeWidgetSize.s2x1,
    HomeWidgetSize.s2x2,
  ];

  /// Default visual style for a given size.
  HomeWidgetStyle styleForSize(HomeWidgetSize size) {
    final area = size.height * size.width;
    return switch (this) {
      HomeWidgetType.streak =>
        area >= 4 ? HomeWidgetStyle.calendar : HomeWidgetStyle.number,
      HomeWidgetType.weeklyVolume =>
        area >= 4 ? HomeWidgetStyle.chart : HomeWidgetStyle.number,
      HomeWidgetType.frequency =>
        area >= 2 ? HomeWidgetStyle.list : HomeWidgetStyle.number,
      HomeWidgetType.personalRecords =>
        area >= 2 ? HomeWidgetStyle.list : HomeWidgetStyle.number,
      HomeWidgetType.avgDuration => HomeWidgetStyle.number,
    };
  }

  static HomeWidgetType? tryParse(String value) {
    for (final type in HomeWidgetType.values) {
      if (type.name == value) return type;
    }
    return null;
  }
}

enum HomeWidgetStyle {
  number,
  chart,
  list,
  calendar;

  static HomeWidgetStyle? tryParse(String value) {
    for (final style in HomeWidgetStyle.values) {
      if (style.name == value) return style;
    }
    return null;
  }
}

/// Size as height × width on a 2-column grid.
enum HomeWidgetSize {
  s1x1(height: 1, width: 1),
  s1x2(height: 1, width: 2),
  s2x1(height: 2, width: 1),
  s2x2(height: 2, width: 2),
  s3x1(height: 3, width: 1),
  s3x2(height: 3, width: 2);

  const HomeWidgetSize({required this.height, required this.width});

  final int height;
  final int width;

  String get label => '$height×$width';

  String get layoutTitle => switch (this) {
    HomeWidgetSize.s1x1 => 'Square layout',
    HomeWidgetSize.s1x2 => 'Wide layout',
    HomeWidgetSize.s2x1 => 'Tall layout',
    HomeWidgetSize.s2x2 => 'Large layout',
    HomeWidgetSize.s3x1 => 'Tall layout',
    HomeWidgetSize.s3x2 => 'Large layout',
  };

  String get layoutSubtitle => switch (this) {
    HomeWidgetSize.s1x1 => 'Highlights your logged values',
    HomeWidgetSize.s1x2 => 'More room across both columns',
    HomeWidgetSize.s2x1 => 'Extra height for details',
    HomeWidgetSize.s2x2 => 'Bigger card with more context',
    HomeWidgetSize.s3x1 => 'Extra height for details',
    HomeWidgetSize.s3x2 => 'Bigger card with more context',
  };

  /// Caps legacy 3-row sizes to the 2×2 maximum.
  HomeWidgetSize get clampedToMax {
    if (height <= 2 && width <= 2) return this;
    return HomeWidgetSize.fromDimensions(
          height.clamp(1, 2),
          width.clamp(1, 2),
        ) ??
        HomeWidgetSize.s2x2;
  }

  static HomeWidgetSize? fromDimensions(int height, int width) {
    for (final size in HomeWidgetSize.values) {
      if (size.height == height && size.width == width) return size;
    }
    return null;
  }

  static HomeWidgetSize? tryParse(String value) {
    for (final size in HomeWidgetSize.values) {
      if (size.name == value) return size;
    }
    return null;
  }
}

class HomeWidgetInstance {
  const HomeWidgetInstance({
    required this.id,
    required this.type,
    required this.style,
    required this.size,
    required this.order,
    required this.name,
  });

  final String id;
  final HomeWidgetType type;
  final HomeWidgetStyle style;
  final HomeWidgetSize size;
  final int order;
  final String name;

  HomeWidgetInstance copyWith({
    String? id,
    HomeWidgetType? type,
    HomeWidgetStyle? style,
    HomeWidgetSize? size,
    int? order,
    String? name,
  }) {
    return HomeWidgetInstance(
      id: id ?? this.id,
      type: type ?? this.type,
      style: style ?? this.style,
      size: size ?? this.size,
      order: order ?? this.order,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'style': style.name,
    'size': size.name,
    'order': order,
    'name': name,
    'height': size.height,
    'width': size.width,
  };

  factory HomeWidgetInstance.fromJson(Map<String, dynamic> json) {
    final type =
        HomeWidgetType.tryParse(json['type'] as String? ?? '') ??
        HomeWidgetType.streak;
    final style =
        HomeWidgetStyle.tryParse(json['style'] as String? ?? '') ??
        type.supportedStyles.first;
    final parsedSize = HomeWidgetSize.tryParse(json['size'] as String? ?? '');
    final size =
        parsedSize ??
        HomeWidgetSize.fromDimensions(
          (json['height'] as num?)?.toInt() ?? 1,
          (json['width'] as num?)?.toInt() ?? 1,
        ) ??
        type.supportedSizes.first;
    final rawName = (json['name'] as String?)?.trim();

    final clamped =
        (HomeWidgetSize.values.contains(size)
                ? size
                : type.supportedSizes.first)
            .clampedToMax;

    return HomeWidgetInstance(
      id: json['id'] as String? ?? '',
      type: type,
      style: type.supportedStyles.contains(style)
          ? style
          : type.supportedStyles.first,
      size: clamped,
      order: (json['order'] as num?)?.toInt() ?? 0,
      name: (rawName != null && rawName.isNotEmpty)
          ? rawName
          : _defaultNameFor(type),
    );
  }
}

String _defaultNameFor(HomeWidgetType type) => switch (type) {
  HomeWidgetType.streak => 'Streak',
  HomeWidgetType.weeklyVolume => 'Volume',
  HomeWidgetType.frequency => 'Frequência',
  HomeWidgetType.personalRecords => 'PRs',
  HomeWidgetType.avgDuration => 'Duração',
};

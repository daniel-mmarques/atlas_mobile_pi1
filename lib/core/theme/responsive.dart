import 'package:flutter/material.dart';

/// Helpers de responsividade.
abstract class AppResponsive {
  static Size sizeOf(BuildContext context) => MediaQuery.sizeOf(context);

  static double widthOf(BuildContext context) => sizeOf(context).width;

  static double heightOf(BuildContext context) => sizeOf(context).height;

  static bool isCompact(BuildContext context) => widthOf(context) < 380;

  static bool isShort(BuildContext context) => heightOf(context) < 700;

  /// Escala tipográfica suave entre [min] e [max] conforme a largura.
  static double font(
    BuildContext context, {
    required double base,
    double min = 12,
    double? max,
  }) {
    final w = widthOf(context);
    final scale = (w / 390).clamp(0.85, 1.15);
    final value = base * scale;
    final upper = max ?? base * 1.15;
    return value.clamp(min, upper);
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final w = widthOf(context);
    final horizontal = w < 360 ? 12.0 : (w > 600 ? 32.0 : 16.0);
    return EdgeInsets.symmetric(horizontal: horizontal);
  }

  static double logoSize(BuildContext context) {
    final shortest = sizeOf(context).shortestSide;
    return (shortest * 0.55).clamp(160.0, 285.0);
  }
}

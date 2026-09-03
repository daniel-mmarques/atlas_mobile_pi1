import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Ao soltar, a inércia puxa como ímã para o múltiplo mais próximo de [itemExtent].
class MagnetSnapScrollPhysics extends ScrollPhysics {
  const MagnetSnapScrollPhysics({
    required this.itemExtent,
    super.parent,
  });

  final double itemExtent;

  @override
  MagnetSnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return MagnetSnapScrollPhysics(
      itemExtent: itemExtent,
      parent: buildParent(ancestor),
    );
  }

  double _getTargetPixels(ScrollMetrics position, double velocity) {
    final pixels = position.pixels;
    var page = pixels / itemExtent;
    final tol = toleranceFor(position).velocity;

    if (velocity < -tol) {
      page = page.floorToDouble();
    } else if (velocity > tol) {
      page = page.ceilToDouble();
    } else {
      page = page.roundToDouble();
    }

    final maxPage = (position.maxScrollExtent / itemExtent).floorToDouble();
    page = page.clamp(0.0, math.max(0.0, maxPage));
    return page * itemExtent;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final target = _getTargetPixels(position, velocity);
    if ((target - position.pixels).abs() < toleranceFor(position).distance) {
      return null;
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: toleranceFor(position),
    );
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 0.8,
        stiffness: 180,
        damping: 22,
      );

  @override
  bool get allowImplicitScrolling => false;
}

import 'package:flutter/material.dart';

/// Shared motion tokens for perceived fluency (sheets, content swaps).
abstract final class AppMotion {
  static const Duration sheet = Duration(milliseconds: 320);
  static const Duration content = Duration(milliseconds: 280);

  static const Curve sheetCurve = Curves.easeOutCubic;
  static const Curve contentCurve = Curves.easeOutCubic;
}

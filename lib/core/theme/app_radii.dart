import 'package:flutter/material.dart';

abstract class AppRadii {
  static const sm = BorderRadius.all(Radius.circular(12));
  static const md = BorderRadius.all(Radius.circular(16));
  static const lg = BorderRadius.all(Radius.circular(24));
  static const sheet = BorderRadius.vertical(top: Radius.circular(28));
  static const sheetButton = BorderRadius.all(Radius.circular(28));
  static const pill = BorderRadius.all(Radius.circular(50));

  static const card = lg;
  static const cardSm = md;
  static const button = BorderRadius.all(Radius.circular(14));
  static const authPanel = BorderRadius.only(
    topLeft: Radius.circular(40),
    topRight: Radius.circular(40),
  );
}

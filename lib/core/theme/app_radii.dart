import 'package:flutter/material.dart';

abstract class AppRadii {
  static const card = BorderRadius.all(Radius.circular(24));
  static const cardSm = BorderRadius.all(Radius.circular(16));
  static const button = BorderRadius.all(Radius.circular(14));
  static const pill = BorderRadius.all(Radius.circular(50));
  static const iconButton = BorderRadius.all(Radius.circular(50));
  static const authPanel = BorderRadius.only(
    topLeft: Radius.circular(40),
    topRight: Radius.circular(40),
  );
}

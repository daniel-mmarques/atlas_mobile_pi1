import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:flutter/material.dart';

InputDecoration authInputDecoration(
  BuildContext context, {
  required String hint,
  required IconData icon,
  Widget? suffix,
  String? label,
}) {
  final hintSize = AppResponsive.font(context, base: 15, min: 13);

  return InputDecoration(
    hintText: hint,
    labelText: label,
    hintStyle: TextStyle(
      color: AppColors.lightTextSecondary,
      fontSize: hintSize,
    ),
    labelStyle: TextStyle(
      color: AppColors.lightTextSecondary,
      fontSize: hintSize,
    ),
    prefixIcon: Icon(icon, color: AppColors.accent),
    suffixIcon: suffix,
    filled: true,
    fillColor: AppColors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: const BorderSide(color: AppColors.lightBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: const BorderSide(color: AppColors.lightBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    errorStyle: const TextStyle(
      color: AppColors.error,
      fontSize: 12,
    ),
    errorMaxLines: 2,
  );
}

TextStyle authFieldTextStyle(BuildContext context) {
  return TextStyle(
    color: AppColors.black,
    fontSize: AppResponsive.font(context, base: 15, min: 14),
  );
}

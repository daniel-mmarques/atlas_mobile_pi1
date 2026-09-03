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
  final secondary = AppColors.textSecondary(context);
  final border = AppColors.border(context);
  final accent = AppColors.accentOf(context);

  return InputDecoration(
    hintText: hint,
    labelText: label,
    hintStyle: TextStyle(
      color: secondary,
      fontSize: hintSize,
    ),
    labelStyle: TextStyle(
      color: secondary,
      fontSize: hintSize,
    ),
    prefixIcon: Icon(icon, color: accent),
    suffixIcon: suffix,
    filled: true,
    fillColor: AppColors.surfaceSecondary(context),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: BorderSide(color: border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: BorderSide(color: border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: BorderSide(color: accent, width: 1.5),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: AppRadii.button,
      borderSide: BorderSide(color: AppColors.error, width: 1.5),
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
    color: AppColors.textPrimary(context),
    fontSize: AppResponsive.font(context, base: 15, min: 14),
  );
}

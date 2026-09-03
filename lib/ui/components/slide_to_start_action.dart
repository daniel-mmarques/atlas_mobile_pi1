import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SlideToStartAction extends StatelessWidget {
  const SlideToStartAction({
    super.key,
    required this.text,
    required this.onSubmit,
    this.outerColor,
    this.innerColor,
    this.height = 66,
    this.borderRadius = 50,
    this.textStyle,
    this.sliderButtonIcon,
  });

  final String text;
  final VoidCallback? onSubmit;
  final Color? outerColor;
  final Color? innerColor;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget? sliderButtonIcon;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentOf(context);
    final onAccent = AppColors.onAccentOf(context);
    final surface = AppColors.surface(context);

    return SlideAction(
      height: height,
      outerColor: outerColor ?? accent,
      innerColor: innerColor ?? surface,
      text: text,
      textStyle: textStyle ??
          TextStyle(
            color: onAccent,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
      sliderButtonIcon: sliderButtonIcon ??
          Icon(Icons.arrow_forward, color: onAccent),
      sliderRotate: false,
      borderRadius: borderRadius,
      onSubmit: () {
        onSubmit?.call();
        return null;
      },
    );
  }
}

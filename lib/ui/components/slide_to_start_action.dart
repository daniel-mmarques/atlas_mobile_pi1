import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SlideToStartAction extends StatelessWidget {
  const SlideToStartAction({
    super.key,
    required this.text,
    required this.onSubmit,
    this.outerColor = AppColors.mutedTeal,
    this.innerColor = AppColors.darkSurface,
    this.height = 66,
    this.borderRadius = 50,
    this.textStyle,
    this.sliderButtonIcon =
        const Icon(Icons.arrow_forward, color: AppColors.white),
  });

  final String text;
  final VoidCallback? onSubmit;
  final Color outerColor;
  final Color innerColor;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget sliderButtonIcon;

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      height: height,
      outerColor: outerColor,
      innerColor: innerColor,
      text: text,
      textStyle: textStyle ??
          const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
      sliderButtonIcon: sliderButtonIcon,
      sliderRotate: false,
      borderRadius: borderRadius,
      onSubmit: () {
        onSubmit?.call();
        return null;
      },
    );
  }
}

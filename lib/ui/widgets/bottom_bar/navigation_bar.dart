import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _icons = [
    (Icons.grid_view_outlined, Icons.grid_view_rounded),
    (Icons.calendar_today_outlined, Icons.calendar_today_rounded),
    (Icons.timeline_outlined, Icons.timeline_rounded),
    (Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final active = AppColors.textPrimary(context);
    final inactive = AppColors.textSecondary(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: SizedBox(
          height: AppSpacing.navHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              final selected = currentIndex == index;
              return IconButton(
                onPressed: () => onTap(index),
                icon: Icon(
                  selected ? _icons[index].$2 : _icons[index].$1,
                  size: AppSpacing.iconNav,
                  color: selected ? active : inactive,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

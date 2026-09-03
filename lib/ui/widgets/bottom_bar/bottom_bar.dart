import 'package:atlas_mobile_pi1/ui/widgets/bottom_bar/navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      currentIndex: currentIndex,
      onTap: onTap!,
    );
  }
}

import 'package:atlas_mobile_pi1/core/navigation/bottom_bar_type.dart';
import 'package:atlas_mobile_pi1/ui/widgets/bottom_bar/chat_bar.dart';
import 'package:atlas_mobile_pi1/ui/widgets/bottom_bar/navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.type,
    this.currentIndex = 0,
    this.onTap,
    this.onSend,
  });

  final BottomBarType type;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final ValueChanged<String>? onSend;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BottomBarType.navigation:
        return NavigationBarWidget(
          currentIndex: currentIndex,
          onTap: onTap!,
        );
      case BottomBarType.chat:
        return ChatBar(onSend: onSend);
    }
  }
}

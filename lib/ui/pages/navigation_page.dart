import 'package:atlas_mobile_pi1/core/navigation/bottom_bar_type.dart';
import 'package:atlas_mobile_pi1/ui/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: Stack(
        children: [
          shell,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: BottomBar(
                currentIndex: shell.currentIndex,
                onTap: (index) => shell.goBranch(
                  index,
                  initialLocation: index == shell.currentIndex,
                ),
                type: BottomBarType.navigation,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

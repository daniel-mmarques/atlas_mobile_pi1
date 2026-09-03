import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logoSize = AppResponsive.logoSize(context);

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/atlas_logo.png',
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                CircularProgressIndicator(color: AppColors.accentOf(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

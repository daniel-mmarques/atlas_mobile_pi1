import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/ui/components/app_card.dart';
import 'package:flutter/material.dart';

class HomeAddWidgetCard extends StatelessWidget {
  const HomeAddWidgetCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      color: AppColors.component(context),
      child: Center(
        child: Icon(
          Icons.add_rounded,
          size: 36,
          color: AppColors.textSecondary(context),
        ),
      ),
    );
  }
}

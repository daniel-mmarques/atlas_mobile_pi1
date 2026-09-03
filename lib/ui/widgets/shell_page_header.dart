import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Header das abas principais — padding e altura fixos para o título não saltar.
class ShellPageHeader extends StatelessWidget {
  const ShellPageHeader({
    super.key,
    required this.title,
    this.actions = const [],
    this.onTitleTap,
  });

  final String title;
  final List<Widget> actions;
  final VoidCallback? onTitleTap;

  @override
  Widget build(BuildContext context) {
    final titleText = Text(
      title,
      style: AppTypography.shellTitle(context),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final titleChild = onTitleTap == null
        ? titleText
        : InkWell(
            borderRadius: AppRadii.sm,
            onTap: onTitleTap,
            child: titleText,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      child: SizedBox(
        height: AppSpacing.shellHeaderHeight,
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: titleChild,
              ),
            ),
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              actions[i],
            ],
          ],
        ),
      ),
    );
  }
}

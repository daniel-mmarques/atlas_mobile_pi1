import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

enum FeedType { discover, following }

/// Switch central estilo Instagram: Discover | Friends.
class FeedSectionSwitch extends StatelessWidget {
  const FeedSectionSwitch({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final FeedType selected;
  final ValueChanged<FeedType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TabLabel(
          label: l10n.feedDiscover,
          isActive: selected == FeedType.discover,
          onTap: () => onChanged(FeedType.discover),
        ),
        const SizedBox(width: AppSpacing.xl),
        _TabLabel(
          label: l10n.feedFriends,
          isActive: selected == FeedType.following,
          onTap: () => onChanged(FeedType.following),
        ),
      ],
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? AppColors.textPrimary(context)
        : AppColors.textSecondary(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: -0.3,
            shadows: isActive
                ? [
                    Shadow(
                      color: AppColors.textPrimary(context)
                          .withValues(alpha: 0.35),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}

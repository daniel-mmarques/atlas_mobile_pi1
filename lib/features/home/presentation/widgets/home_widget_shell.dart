import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/ui/components/app_card.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';

class HomeWidgetShell extends StatelessWidget {
  const HomeWidgetShell({
    super.key,
    required this.instance,
    required this.child,
    required this.onEditStyle,
    required this.onEditSize,
    required this.onRemove,
    this.onEditName,
  });

  final HomeWidgetInstance instance;
  final Widget child;
  final VoidCallback onEditStyle;
  final VoidCallback onEditSize;
  final VoidCallback onRemove;
  final VoidCallback? onEditName;

  Future<void> _showMenu(BuildContext context) async {
    final l10n = context.l10n;
    final action = await showAtlasSheet<String>(
      context: context,
      isScrollControlled: false,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sheetPaddingH,
              0,
              AppSpacing.sheetPaddingH,
              AppSpacing.sheetPaddingB,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AtlasSheetHandle(),
                const SizedBox(height: AppSpacing.sectionGap),
                Text(
                  instance.name,
                  style: AppTypography.sectionTitle(ctx),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  instance.size.layoutTitle,
                  style: AppTypography.meta(ctx),
                ),
                const SizedBox(height: AppSpacing.md),
                if (onEditName != null)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.edit_outlined),
                    title: Text(l10n.widgetRename),
                    onTap: () => Navigator.pop(ctx, 'name'),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.palette_outlined),
                  title: Text(l10n.widgetChangeStyle),
                  onTap: () => Navigator.pop(ctx, 'style'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.aspect_ratio_rounded),
                  title: Text(l10n.widgetChangeSize),
                  onTap: () => Navigator.pop(ctx, 'size'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    color: Theme.of(ctx).colorScheme.error,
                  ),
                  title: Text(
                    l10n.delete,
                    style: TextStyle(color: Theme.of(ctx).colorScheme.error),
                  ),
                  onTap: () => Navigator.pop(ctx, 'remove'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (action == 'name') onEditName?.call();
    if (action == 'style') onEditStyle();
    if (action == 'size') onEditSize();
    if (action == 'remove') onRemove();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onLongPress: () => _showMenu(context),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.md,
      ),
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: AppSpacing.minTouch,
                minHeight: AppSpacing.minTouch,
              ),
              onPressed: () => _showMenu(context),
              icon: Icon(
                Icons.tune_rounded,
                size: AppSpacing.iconSm,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/ui/components/app_card.dart';
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
    final action = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border(ctx).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  instance.name,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  instance.size.layoutTitle,
                  style: TextStyle(
                    color: AppColors.textSecondary(ctx),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                if (onEditName != null)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Renomear'),
                    onTap: () => Navigator.pop(ctx, 'name'),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Alterar estilo'),
                  onTap: () => Navigator.pop(ctx, 'style'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.aspect_ratio_rounded),
                  title: const Text('Alterar tamanho'),
                  onTap: () => Navigator.pop(ctx, 'size'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    color: Theme.of(ctx).colorScheme.error,
                  ),
                  title: Text(
                    'Remover',
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
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () => _showMenu(context),
              icon: Icon(
                Icons.tune_rounded,
                size: 18,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

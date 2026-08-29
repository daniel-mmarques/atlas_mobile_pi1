import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/controllers/home_dashboard_controller.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/catalog/add_widget_sheet.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/home_widget_grid.dart';
import 'package:atlas_mobile_pi1/features/settings/presentation/pages/settings_page.dart';
import 'package:atlas_mobile_pi1/features/profile/presentation/pages/profile_page.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:atlas_mobile_pi1/ui/pages/home/add_sheet.dart';
import 'package:atlas_mobile_pi1/ui/widgets/shell_page_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return ChangeNotifierProvider(
      create: (_) => HomeDashboardController(userId: userId).load(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShellPageHeader(
                title: 'Atlas',
                onTitleTap: () => showProfileSheet(context),
                actions: [
                  AppIconButton(
                    icon: Icons.tune_rounded,
                    onPressed: () => showSettingsSheet(context),
                  ),
                  AppIconButton(
                    icon: Icons.add_rounded,
                    onPressed: () => showAddSheet(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: _HomeDashboard(userId: userId.isEmpty ? null : userId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({this.userId});

  final String? userId;

  Future<void> _onEditStyle(
    BuildContext context,
    HomeWidgetInstance instance,
  ) async {
    final style = await showPickStyleSheet(
      context,
      type: instance.type,
      current: instance.style,
    );
    if (style == null || !context.mounted) return;
    await context.read<HomeDashboardController>().updateWidget(
          instance.id,
          style: style,
        );
  }

  Future<void> _onEditSize(
    BuildContext context,
    HomeWidgetInstance instance,
  ) async {
    final size = await showPickSizeSheet(
      context,
      type: instance.type,
      current: instance.size,
    );
    if (size == null || !context.mounted) return;
    final style = instance.type.styleForSize(size);
    await context.read<HomeDashboardController>().updateWidget(
          instance.id,
          size: size,
          style: style,
        );
  }

  Future<void> _onEditName(
    BuildContext context,
    HomeWidgetInstance instance,
  ) async {
    final controller = TextEditingController(text: instance.name);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
          title: const Text('Renomear'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Nome do widget'),
            onSubmitted: (value) => Navigator.pop(ctx, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (name == null || !context.mounted) return;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await context.read<HomeDashboardController>().updateWidget(
          instance.id,
          name: trimmed,
        );
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<HomeDashboardController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.navHeight + AppSpacing.xl,
      ),
      child: HomeWidgetGrid(
        widgets: dashboard.widgets,
        userId: userId,
        onAdd: () => showAddWidgetSheet(context),
        onEditStyle: (w) => _onEditStyle(context, w),
        onEditSize: (w) => _onEditSize(context, w),
        onEditName: (w) => _onEditName(context, w),
        onRemove: (w) =>
            context.read<HomeDashboardController>().removeWidget(w.id),
      ),
    );
  }
}

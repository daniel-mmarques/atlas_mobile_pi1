import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/username.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/controllers/home_dashboard_controller.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/catalog/add_widget_sheet.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/home_widget_grid.dart';
import 'package:atlas_mobile_pi1/features/profile/presentation/pages/profile_page.dart';
import 'package:atlas_mobile_pi1/features/profile/presentation/widgets/claim_username_dialog.dart';
import 'package:atlas_mobile_pi1/features/settings/presentation/pages/settings_page.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:atlas_mobile_pi1/ui/pages/home/add_sheet.dart';
import 'package:atlas_mobile_pi1/ui/widgets/shell_page_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _claimPrompted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_claimPrompted) return;
    final user = context.read<AuthService>().appUser;
    if (user != null &&
        user.profileCompleted &&
        (user.username == null || user.username!.trim().isEmpty)) {
      _claimPrompted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await showClaimUsernameDialog(context);
      });
    }
  }

  Future<void> _onTitleTap(BuildContext context) async {
    final user = context.read<AuthService>().appUser;
    if (user != null &&
        (user.username == null || user.username!.trim().isEmpty)) {
      await showClaimUsernameDialog(context);
      if (!context.mounted) return;
    }
    await showProfileSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final username = context.select<AuthService, String>((a) {
      final u = Username.normalize(a.appUser?.username);
      return u.isEmpty ? '…' : u;
    });

    return ChangeNotifierProvider(
      create: (_) => HomeDashboardController(userId: userId).load(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShellPageHeader(
                title: username,
                titleStyle: AppTypography.shellTitle(context).copyWith(
                  fontSize: 26,
                  letterSpacing: -0.5,
                ),
                onTitleTap: () => _onTitleTap(context),
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
    final l10n = context.l10n;
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
          title: Text(l10n.widgetRename),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: l10n.widgetNameHint),
            onSubmitted: (value) => Navigator.pop(ctx, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: Text(l10n.save),
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
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.shellBottomInset + MediaQuery.paddingOf(context).bottom,
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

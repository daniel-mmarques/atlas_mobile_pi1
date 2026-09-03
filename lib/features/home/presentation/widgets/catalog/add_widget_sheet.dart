import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/controllers/home_dashboard_controller.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/home_widget_labels.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:atlas_mobile_pi1/ui/widgets/magnet_snap_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> showAddWidgetSheet(BuildContext context) {
  final controller = context.read<HomeDashboardController>();

  return showAtlasSheet<void>(
    context: context,
    builder: (_) {
      return ChangeNotifierProvider<HomeDashboardController>.value(
        value: controller,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: AppSpacing.sheetInitial,
          minChildSize: AppSpacing.sheetMinContent,
          maxChildSize: AppSpacing.sheetMax,
          shouldCloseOnMinExtent: true,
          builder: (_, scrollController) {
            return AddWidgetSheet(scrollController: scrollController);
          },
        ),
      );
    },
  );
}

Future<HomeWidgetStyle?> showPickStyleSheet(
  BuildContext context, {
  required HomeWidgetType type,
  HomeWidgetStyle? current,
}) {
  return showAtlasSheet<HomeWidgetStyle>(
    context: context,
    isScrollControlled: false,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.md,
            AppSpacing.sheetPaddingH,
            AppSpacing.sheetPaddingB,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AtlasSheetHandle(),
              const SizedBox(height: 16),
              Text(
                ctx.l10n.widgetStyleTitle,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              for (final style in type.supportedStyles)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(style.icon),
                  title: Text(style.label(ctx.l10n)),
                  trailing: current == style
                      ? Icon(Icons.check_rounded, color: AppColors.accentOf(context))
                      : null,
                  onTap: () => Navigator.pop(ctx, style),
                ),
            ],
          ),
        ),
      );
    },
  );
}

Future<HomeWidgetSize?> showPickSizeSheet(
  BuildContext context, {
  required HomeWidgetType type,
  HomeWidgetSize? current,
}) {
  final sizes = type.supportedSizes;
  var index = current == null ? 0 : sizes.indexOf(current);
  if (index < 0) index = 0;

  return showAtlasSheet<HomeWidgetSize>(
    context: context,
    builder: (ctx) {
      return _SizePickerSheet(
        type: type,
        initialIndex: index,
        name: type.label(context.l10n),
      );
    },
  );
}

class AddWidgetSheet extends StatefulWidget {
  const AddWidgetSheet({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  State<AddWidgetSheet> createState() => _AddWidgetSheetState();
}

class _AddWidgetSheetState extends State<AddWidgetSheet> {
  /// 0 = pick type, 1 = name, 2 = size carousel
  int _step = 0;
  HomeWidgetType? _type;
  late final TextEditingController _nameController;
  late final PageController _pageController;
  int _sizeIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _pageController = PageController(viewportFraction: 0.72);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _step -= 1);
  }

  void _selectType(HomeWidgetType type) {
    setState(() {
      _type = type;
      _nameController.text = type.label(context.l10n);
      _sizeIndex = 0;
    });
  }

  void _goToNameStep() {
    if (_type == null) return;
    setState(() => _step = 1);
  }

  void _goToSizeStep() {
    final name = _nameController.text.trim();
    if (name.isEmpty && _type != null) {
      _nameController.text = _type!.label(context.l10n);
    }
    FocusScope.of(context).unfocus();
    setState(() => _step = 2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_sizeIndex);
      }
    });
  }

  Future<void> _confirm() async {
    final type = _type;
    if (type == null) return;
    final sizes = type.supportedSizes;
    final size = sizes[_sizeIndex.clamp(0, sizes.length - 1)];
    final style = type.styleForSize(size);
    final name = _nameController.text.trim().isEmpty
        ? type.label(context.l10n)
        : _nameController.text.trim();

    await context.read<HomeDashboardController>().addWidget(
          type: type,
          style: style,
          size: size,
          name: name,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AtlasSheetContentTransition(
      child: KeyedSubtree(
        key: ValueKey(_step),
        child: switch (_step) {
          0 => _TypeStep(
              selected: _type,
              onBack: _back,
              onSelect: _selectType,
              onContinue: _type == null ? null : _goToNameStep,
            ),
          1 => _NameStep(
              scrollController: widget.scrollController,
              controller: _nameController,
              onBack: _back,
              onContinue: _goToSizeStep,
            ),
          _ => _SizeStep(
              type: _type!,
              name: _nameController.text.trim().isEmpty
                  ? _type!.label(context.l10n)
                  : _nameController.text.trim(),
              pageController: _pageController,
              sizeIndex: _sizeIndex,
              onBack: _back,
              onPageChanged: (i) => setState(() => _sizeIndex = i),
              onConfirm: _confirm,
            ),
        },
      ),
    );
  }
}

class _TypeStep extends StatefulWidget {
  const _TypeStep({
    required this.selected,
    required this.onBack,
    required this.onSelect,
    required this.onContinue,
  });

  final HomeWidgetType? selected;
  final VoidCallback onBack;
  final void Function(HomeWidgetType) onSelect;
  final VoidCallback? onContinue;

  @override
  State<_TypeStep> createState() => _TypeStepState();
}

class _TypeStepState extends State<_TypeStep> {
  static const double _itemExtent = 64;
  static const double _bandTopFraction = 0.22;
  static const double _ctaSize = 40;

  /// Espaço entre o gutter lateral e o CTA circular sobre a lista.
  static const double _ctaGap = AppSpacing.md;

  late final ScrollController _scrollController;

  /// Índice 0 = vazio (nada selecionado). 1..n = [HomeWidgetType.values].
  int _wheelIndex = 0;

  List<HomeWidgetType> get _types => HomeWidgetType.values;

  int get _slotCount => 1 + _types.length;

  HomeWidgetType? get _focusedType =>
      _wheelIndex <= 0 ? null : _types[_wheelIndex - 1];

  bool get _canAdvance => _focusedType != null;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    final selected = widget.selected;
    if (selected != null) {
      final i = _types.indexOf(selected);
      if (i >= 0) _wheelIndex = i + 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        _scrollController.jumpTo(_wheelIndex * _itemExtent);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final index = (_scrollController.offset / _itemExtent)
        .round()
        .clamp(0, _slotCount - 1);
    if (index == _wheelIndex) return;

    setState(() => _wheelIndex = index);
    HapticFeedback.selectionClick();

    final type = _focusedType;
    if (type != null) widget.onSelect(type);
  }

  double _opacityFor(int index) {
    if (index <= 0) return 0;
    final distance = (index - _wheelIndex).abs();
    if (distance == 0) return 1;
    if (distance == 1) return 0.55;
    if (distance == 2) return 0.38;
    if (distance == 3) return 0.26;
    return 0.16;
  }

  String _footerTitle(BuildContext context) {
    final type = _focusedType;
    final l10n = context.l10n;
    if (type == null) return l10n.widgetCreateTitle;
    return type.sheetFooterTitle(l10n);
  }

  String _footerSubtitle(BuildContext context) {
    final type = _focusedType;
    final l10n = context.l10n;
    if (type == null) return l10n.widgetCreateSubtitle;
    return type.sheetFooterSubtitle(l10n);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final surface = AppColors.surface(context);
    final border = AppColors.border(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.sm),
        const AtlasSheetHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.sectionGap,
            AppSpacing.sheetPaddingH,
            AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  l10n.widgetCreateTitle,
                  style: AppTypography.sheetTitle(context),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AtlasSheetNavIcon(
                onPressed: widget.onBack,
                isDismiss: true,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            0,
            AppSpacing.sheetPaddingH,
            AppSpacing.sm,
          ),
          child: Text(
            l10n.widgetCreateSubtitle,
            style: AppTypography.meta(context).copyWith(fontSize: 15),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final topPad = (constraints.maxHeight * _bandTopFraction)
                  .clamp(_itemExtent, constraints.maxHeight * 0.4);
              final bottomPad =
                  (constraints.maxHeight - topPad - _itemExtent).clamp(
                _itemExtent * 2,
                constraints.maxHeight,
              );

              return Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    physics: const MagnetSnapScrollPhysics(
                      itemExtent: _itemExtent,
                      parent: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      top: topPad,
                      bottom: bottomPad,
                      left: AppSpacing.sheetPaddingH,
                      right: AppSpacing.sheetPaddingH + _ctaSize + _ctaGap,
                    ),
                    itemExtent: _itemExtent,
                    itemCount: _slotCount,
                    itemBuilder: (context, index) {
                      if (index <= 0) return const SizedBox.shrink();
                      final type = _types[index - 1];
                      final isFocused = index == _wheelIndex;
                      final opacity = _opacityFor(index);
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          type.label(l10n),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: isFocused
                                ? primary
                                : secondary.withValues(alpha: opacity),
                            fontSize: 28,
                            fontWeight:
                                isFocused ? FontWeight.w700 : FontWeight.w600,
                            height: 1.1,
                            letterSpacing: -0.6,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: topPad,
                    left: 0,
                    right: 0,
                    height: _itemExtent,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: border.withValues(alpha: 0.55),
                            ),
                            bottom: BorderSide(
                              color: border.withValues(alpha: 0.55),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: topPad + (_itemExtent - _ctaSize) / 2,
                    right: AppSpacing.sheetPaddingH,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: _canAdvance ? 1 : 0.28,
                      child: Material(
                        color: _canAdvance
                            ? primary
                            : primary.withValues(alpha: 0.35),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _canAdvance ? widget.onContinue : null,
                          child: SizedBox(
                              width: _ctaSize,
                              height: _ctaSize,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: _canAdvance
                                  ? surface
                                  : surface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Divider(height: 1, color: border.withValues(alpha: 0.4)),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.lg,
            AppSpacing.sheetPaddingH,
            AppSpacing.sheetPaddingB,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: Text(
                  _footerTitle(context),
                  key: ValueKey(_footerTitle(context)),
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: Text(
                  _footerSubtitle(context),
                  key: ValueKey(_footerSubtitle(context)),
                  style: TextStyle(color: secondary, fontSize: 14, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.scrollController,
    required this.controller,
    required this.onBack,
    required this.onContinue,
  });

  final ScrollController? scrollController;
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sheetPaddingH,
        AppSpacing.sm,
        AppSpacing.sheetPaddingH,
        AppSpacing.sheetPaddingB,
      ),
      children: [
        const AtlasSheetHandle(),
        const SizedBox(height: AppSpacing.sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AtlasSheetNavIcon(
              onPressed: onBack,
              isDismiss: false,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.l10n.widgetNameTitle,
                style: AppTypography.sheetTitle(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          context.l10n.widgetNameCustomize,
          style: AppTypography.meta(context).copyWith(fontSize: 15),
        ),
        const SizedBox(height: AppSpacing.xxl),
        TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
          cursorColor: AppColors.accentOf(context),
          decoration: InputDecoration(
            isDense: true,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.border(context),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.border(context),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.accentOf(context),
                width: 1.4,
              ),
            ),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onContinue(),
        ),
        const SizedBox(height: 36),
        Row(
          children: [
            Material(
              color: AppColors.component(context),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => FocusScope.of(context).unfocus(),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.keyboard_arrow_down_rounded, size: 26),
                ),
              ),
            ),
            const Spacer(),
            Material(
              color: AppColors.textPrimary(context),
              borderRadius: AppRadii.pill,
              child: InkWell(
                onTap: onContinue,
                borderRadius: AppRadii.pill,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.surface(context),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.continueAction,
                        style: TextStyle(
                          color: AppColors.surface(context),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SizeStep extends StatelessWidget {
  const _SizeStep({
    required this.type,
    required this.name,
    required this.pageController,
    required this.sizeIndex,
    required this.onBack,
    required this.onPageChanged,
    required this.onConfirm,
  });

  final HomeWidgetType type;
  final String name;
  final PageController pageController;
  final int sizeIndex;
  final VoidCallback onBack;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final sizes = type.supportedSizes;
    final size = sizes[sizeIndex.clamp(0, sizes.length - 1)];
    final secondary = AppColors.textSecondary(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AtlasSheetHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.sm,
            AppSpacing.sheetPaddingH,
            0,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AtlasSheetNavIcon(
              onPressed: onBack,
              isDismiss: false,
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: sizes.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final s = sizes[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Align(
                  alignment: Alignment.center,
                  child: _LayoutPreviewCard(
                    type: type,
                    name: name,
                    size: s,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.sm,
            AppSpacing.sheetPaddingH,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                size.layoutTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                size.layoutSubtitle,
                style: TextStyle(color: secondary, fontSize: 14),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.xxl,
            AppSpacing.sheetPaddingH,
            AppSpacing.sheetPaddingB,
          ),
          child: AppActionButton.sheet(
            label: context.l10n.widgetAddToWorkouts,
            icon: Icons.download_rounded,
            onTap: onConfirm,
          ),
        ),
      ],
    );
  }
}

class _SizePickerSheet extends StatefulWidget {
  const _SizePickerSheet({
    required this.type,
    required this.initialIndex,
    required this.name,
  });

  final HomeWidgetType type;
  final int initialIndex;
  final String name;

  @override
  State<_SizePickerSheet> createState() => _SizePickerSheetState();
}

class _SizePickerSheetState extends State<_SizePickerSheet> {
  late int _index;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(
      viewportFraction: 0.72,
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = widget.type.supportedSizes;
    final size = sizes[_index.clamp(0, sizes.length - 1)];

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AtlasSheetHandle(),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: sizes.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      child: _LayoutPreviewCard(
                        type: widget.type,
                        name: widget.name,
                        size: sizes[index],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sheetPaddingH,
                AppSpacing.sm,
                AppSpacing.sheetPaddingH,
                0,
              ),
              child: Text(
                size.layoutTitle,
                style: AppTypography.cardTitle(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sheetPaddingH,
                AppSpacing.xl,
                AppSpacing.sheetPaddingH,
                AppSpacing.sheetPaddingB,
              ),
              child: AppActionButton.sheet(
                label: context.l10n.widgetApplySize,
                onTap: () => Navigator.pop(context, size),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LayoutPreviewCard extends StatelessWidget {
  const _LayoutPreviewCard({
    required this.type,
    required this.name,
    required this.size,
  });

  final HomeWidgetType type;
  final String name;
  final HomeWidgetSize size;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final maxW = MediaQuery.sizeOf(context).width * 0.62;
    final base = maxW / 2;
    final width = (base * size.width).clamp(120.0, maxW);
    final height = (base * size.height * 0.95).clamp(120.0, 280.0);

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.component(context),
        borderRadius: AppRadii.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.tune_rounded,
              size: 18,
              color: AppColors.textSecondary(context),
            ),
          ),
          const Spacer(),
          Text(
            type.previewValue(l10n),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            type.emptyStatus(l10n),
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

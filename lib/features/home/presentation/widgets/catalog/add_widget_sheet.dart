import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/controllers/home_dashboard_controller.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/home_widget_labels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showAddWidgetSheet(BuildContext context) {
  final controller = context.read<HomeDashboardController>();

  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) {
      return ChangeNotifierProvider<HomeDashboardController>.value(
        value: controller,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.92,
          minChildSize: 0.55,
          maxChildSize: 0.95,
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
  return showModalBottomSheet<HomeWidgetStyle>(
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
              const _SheetHandle(),
              const SizedBox(height: 16),
              Text(
                'Estilo',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              for (final style in type.supportedStyles)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(style.icon),
                  title: Text(style.label),
                  trailing: current == style
                      ? Icon(Icons.check_rounded, color: AppColors.accent)
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

  return showModalBottomSheet<HomeWidgetSize>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return _SizePickerSheet(
        type: type,
        initialIndex: index,
        name: type.label,
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
      _nameController.text = type.label;
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
      _nameController.text = _type!.label;
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
        ? type.label
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
    return switch (_step) {
      0 => _TypeStep(
          scrollController: widget.scrollController,
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
              ? _type!.label
              : _nameController.text.trim(),
          pageController: _pageController,
          sizeIndex: _sizeIndex,
          onBack: _back,
          onPageChanged: (i) => setState(() => _sizeIndex = i),
          onConfirm: _confirm,
        ),
    };
  }
}

class _TypeStep extends StatelessWidget {
  const _TypeStep({
    required this.scrollController,
    required this.selected,
    required this.onBack,
    required this.onSelect,
    required this.onContinue,
  });

  final ScrollController? scrollController;
  final HomeWidgetType? selected;
  final VoidCallback onBack;
  final void Function(HomeWidgetType) onSelect;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final secondary = AppColors.textSecondary(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const _SheetHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
          child: IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 32,
              color: AppColors.textPrimary(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.border(context).withValues(alpha: 0.5),
                ),
                bottom: BorderSide(
                  color: AppColors.border(context).withValues(alpha: 0.5),
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected?.label ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: selected == null
                          ? secondary
                          : AppColors.textPrimary(context),
                    ),
                  ),
                ),
                Material(
                  color: selected == null
                      ? AppColors.component(context)
                      : Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onContinue,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: selected == null
                            ? secondary
                            : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            children: [
              for (final type in HomeWidgetType.values)
                InkWell(
                  onTap: () => onSelect(type),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.6,
                        color: selected == type
                            ? AppColors.textPrimary(context)
                            : secondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selected?.sheetFooterTitle ??
                    'Add a widget to your dashboard',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                selected?.sheetFooterSubtitle ??
                    'Pick the data you want to see on Home.',
                style: TextStyle(color: secondary, fontSize: 14, height: 1.3),
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
    final secondary = AppColors.textSecondary(context);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        const _SheetHandle(),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 28,
              color: AppColors.textPrimary(context),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Name',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Customize the name if you like',
          style: TextStyle(color: secondary, fontSize: 15),
        ),
        const SizedBox(height: 28),
        TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
          cursorColor: AppColors.accent,
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
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.4),
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
              color: Colors.white,
              borderRadius: AppRadii.pill,
              child: InkWell(
                onTap: onContinue,
                borderRadius: AppRadii.pill,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.black,
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
        const SizedBox(height: 10),
        const _SheetHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 20, 0),
          child: IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 28,
              color: AppColors.textPrimary(context),
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
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
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
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onConfirm,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const StadiumBorder(),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_rounded, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Add to Workouts',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
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
            const SizedBox(height: 10),
            const _SheetHandle(),
            const SizedBox(height: 8),
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
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Text(
                size.layoutTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, size),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Aplicar tamanho',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
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
            type.previewValue,
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
            type.emptyStatus,
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

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border(context).withValues(alpha: 0.7),
          borderRadius: AppRadii.pill,
        ),
      ),
    );
  }
}

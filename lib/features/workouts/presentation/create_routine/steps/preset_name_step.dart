import 'dart:async';

import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/templates_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/create_routine_controller.dart';
import 'package:atlas_mobile_pi1/ui/widgets/magnet_snap_scroll_physics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Lista plana: opções passam pela faixa de evidência (terço superior).
class PresetNameStep extends StatefulWidget {
  const PresetNameStep({super.key});

  @override
  State<PresetNameStep> createState() => _PresetNameStepState();
}

class _PresetNameStepState extends State<PresetNameStep> {
  static const double _itemExtent = 64;
  /// Faixa no terço superior da área rolável (referência do vídeo).
  static const double _bandTopFraction = 0.22;
  static const double _ctaSize = 40;
  static const double _ctaGap = AppSpacing.md;

  late final ScrollController _scrollController;
  StreamSubscription<List<WorkoutTemplate>>? _templatesSub;
  final Set<String> _existingNames = {};

  /// Índice 0 = vazio. 1 = Custom. 2.. = presets.
  int _wheelIndex = 0;

  int get _slotCount => 2 + CreateRoutineController.presets.length;

  int? get _selectedSlot => _wheelIndex <= 0 ? null : _wheelIndex;

  bool get _canAdvance => _selectedSlot != null;

  bool get _isCustomSelected => _selectedSlot == 1;

  String? get _selectedPresetName {
    final slot = _selectedSlot;
    if (slot == null || slot < 2) return null;
    return CreateRoutineController.presets[slot - 2];
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final repo = context.read<TemplatesRepository>();
      final userId = context.read<CreateRoutineController>().userId;
      _templatesSub = repo.watchUserTemplates(userId).listen((templates) {
        if (!mounted) return;
        setState(() {
          _existingNames
            ..clear()
            ..addAll(
              templates.map((t) => t.name.trim().toLowerCase()),
            );
        });
      });
    });
  }

  @override
  void dispose() {
    _templatesSub?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final index = (_scrollController.offset / _itemExtent)
        .round()
        .clamp(0, _slotCount - 1);
    if (index != _wheelIndex) {
      setState(() => _wheelIndex = index);
      HapticFeedback.selectionClick();
      context.read<CreateRoutineController>().setPresetInEvidence(index > 0);
    }
  }

  void _confirm() {
    if (!_canAdvance) return;
    final controller = context.read<CreateRoutineController>();
    if (_isCustomSelected) {
      controller.selectPreset(null);
    } else {
      controller.selectPreset(_selectedPresetName);
    }
  }

  String _labelForSlot(BuildContext context, int slot) {
    if (slot <= 0) return '';
    if (slot == 1) return context.l10n.routinePresetCustom;
    return CreateRoutineController.presets[slot - 2];
  }

  String _displayLabel(BuildContext context) {
    final slot = _selectedSlot;
    if (slot == null) return '';
    return _labelForSlot(context, slot);
  }

  bool _alreadyExists(String label) {
    return _existingNames.contains(label.trim().toLowerCase());
  }

  String _footerTitle(BuildContext context) {
    if (!_canAdvance) return context.l10n.routineCreateTitle;
    if (_isCustomSelected) return context.l10n.routinePresetCustomTitle;
    final label = _displayLabel(context);
    if (_alreadyExists(label)) {
      return context.l10n.routinePresetAlreadyExists(label);
    }
    return context.l10n.routineCreateNamedTitle(label);
  }

  String _footerSubtitle(BuildContext context) {
    if (!_canAdvance) return context.l10n.routineCreateSubtitle;
    if (_isCustomSelected) return context.l10n.routinePresetCustomSubtitle;
    final name = _selectedPresetName;
    if (name == null) return context.l10n.routineCreateSubtitle;
    return CreateRoutineController.presetDescriptions[name] ??
        context.l10n.routineCreateSubtitle;
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

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);
    final surface = AppColors.surface(context);
    final border = AppColors.border(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                      if (index <= 0) {
                        return const SizedBox.shrink();
                      }
                      final isFocused = index == _wheelIndex;
                      final label = _labelForSlot(context, index);
                      final opacity = _opacityFor(index);
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          label,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: isFocused
                                ? primary
                                : secondary.withValues(alpha: opacity),
                            fontSize: 28,
                            fontWeight:
                                isFocused ? FontWeight.w700 : FontWeight.w600,
                            height: 1.1,
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
                    top: topPad + (_itemExtent - 40) / 2,
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
                          onTap: _canAdvance ? _confirm : null,
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
            AppSpacing.sectionGap,
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
                  style: TextStyle(color: secondary, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

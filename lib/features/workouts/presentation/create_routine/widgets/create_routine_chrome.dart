import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';

class CreateRoutineProgressBar extends StatefulWidget {
  const CreateRoutineProgressBar({super.key, required this.progress});

  final double progress;

  @override
  State<CreateRoutineProgressBar> createState() =>
      _CreateRoutineProgressBarState();
}

class _CreateRoutineProgressBarState extends State<CreateRoutineProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  double _current = 0;

  @override
  void initState() {
    super.initState();
    _current = widget.progress.clamp(0.0, 1.0);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _animation = AlwaysStoppedAnimation(_current);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant CreateRoutineProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.progress.clamp(0.0, 1.0);
    if (oldWidget.progress == widget.progress) return;

    final from = _animation.value;
    _animation = Tween<double>(begin: from, end: next).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller
      ..value = 0
      ..forward().whenComplete(() {
        if (mounted) _current = next;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.pill,
      child: LinearProgressIndicator(
        value: _animation.value,
        minHeight: 3,
        backgroundColor: AppColors.component(context),
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.textPrimary(context),
        ),
      ),
    );
  }
}

class CreateRoutineHeader extends StatelessWidget {
  const CreateRoutineHeader({
    super.key,
    required this.progress,
    this.onNav,
    this.isDismiss = false,
  });

  final double progress;
  final VoidCallback? onNav;
  final bool isDismiss;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.minTouch,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FractionallySizedBox(
            widthFactor: 0.70,
            child: CreateRoutineProgressBar(progress: progress),
          ),
          if (onNav != null)
            Align(
              alignment: isDismiss
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: AtlasSheetNavIcon(
                onPressed: onNav!,
                isDismiss: isDismiss,
              ),
            ),
        ],
      ),
    );
  }
}

class CreateRoutineContinueButton extends StatelessWidget {
  const CreateRoutineContinueButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
    required this.label,
  });

  final VoidCallback? onPressed;
  final bool enabled;
  final String label;

  /// Raio alinhado ao CTA / topo da sheet de criar rotina.
  static const double sheetRadius = 28;

  @override
  Widget build(BuildContext context) {
    return AppActionButton(
      label: label,
      icon: Icons.arrow_forward_rounded,
      onTap: enabled ? onPressed : null,
      bold: true,
      emphasized: true,
      height: 60,
      borderRadius: BorderRadius.circular(30),
    );
  }
}

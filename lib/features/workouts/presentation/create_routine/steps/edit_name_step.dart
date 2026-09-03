import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/create_routine_controller.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/create_routine/widgets/create_routine_chrome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditNameStep extends StatefulWidget {
  const EditNameStep({super.key});

  @override
  State<EditNameStep> createState() => _EditNameStepState();
}

class _EditNameStepState extends State<EditNameStep> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final name = context.read<CreateRoutineController>().name;
    _textController = TextEditingController(text: name);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreateRoutineController>();
    final canContinue = context.select<CreateRoutineController, bool>(
      (c) => c.canContinueFromName,
    );
    final l10n = context.l10n;
    final primary = AppColors.textPrimary(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sheetPaddingH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sectionGap),
                Text(
                  l10n.routineNameTitle,
                  style: AppTypography.sheetTitle(context),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.routineNameSubtitle,
                  style: AppTypography.meta(context).copyWith(fontSize: 15),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: false,
                      fillColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                  ),
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    style: TextStyle(
                      color: primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: primary,
                    textInputAction: TextInputAction.done,
                    onChanged: controller.updateName,
                    onSubmitted: (_) {
                      if (controller.canContinueFromName) {
                        controller.goToSchedule();
                      }
                    },
                    decoration: InputDecoration(
                      filled: false,
                      fillColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: primary, width: 1.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primary, width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primary, width: 1.5),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.sheetPaddingH,
            AppSpacing.sm,
            AppSpacing.sheetPaddingH,
            keyboardInset > 0
                ? AppSpacing.sm + keyboardInset
                : AppSpacing.sheetPaddingB,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.38,
              child: CreateRoutineContinueButton(
                enabled: canContinue,
                label: l10n.continueAction,
                onPressed: controller.goToSchedule,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

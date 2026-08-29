import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ChatBar extends StatelessWidget {
  const ChatBar({super.key, this.onSend});

  final ValueChanged<String>? onSend;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Mensagem',
                  filled: true,
                  fillColor: AppColors.component(context),
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.pill,
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
                onSubmitted: (value) {
                  final text = value.trim();
                  if (text.isEmpty) return;
                  onSend?.call(text);
                  controller.clear();
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;
                onSend?.call(text);
                controller.clear();
              },
              icon: Icon(Icons.send_rounded, color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}

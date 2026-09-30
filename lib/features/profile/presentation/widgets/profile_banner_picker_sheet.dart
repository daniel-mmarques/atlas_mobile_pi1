import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/profile/domain/profile_banner_presets.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';

Future<void> showProfileBannerPickerSheet({
  required BuildContext context,
  required String? currentPresetId,
  required bool hasPhoto,
  required ValueChanged<String> onSelectPreset,
  required VoidCallback onPickPhoto,
  required VoidCallback onClearPhoto,
}) {
  return showAtlasSheet<void>(
    context: context,
    builder: (_) {
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AtlasSheetHandle(),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.l10n.profileCustomizeBanner,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.pop(context);
                  onPickPhoto();
                },
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(context.l10n.profileChoosePhoto),
              ),
              if (hasPhoto) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onClearPhoto();
                  },
                  child: Text(context.l10n.profileClearPhoto),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Text(
                context.l10n.profileBannerPresets,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ProfileBannerPresets.all.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final preset = ProfileBannerPresets.all[index];
                  final selected = preset.id ==
                      (currentPresetId ?? ProfileBannerPresets.defaultId);
                  return InkWell(
                    borderRadius: AppRadii.md,
                    onTap: () {
                      Navigator.pop(context);
                      onSelectPreset(preset.id);
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: preset.gradient,
                        borderRadius: AppRadii.md,
                        border: Border.all(
                          color: selected
                              ? AppColors.textPrimary(context)
                              : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/profile/domain/profile_banner_presets.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.isOwnProfile,
    required this.displayName,
    required this.username,
    required this.workoutCount,
    required this.followers,
    required this.following,
    this.bannerPreset,
    this.bannerUrl,
    this.photoUrl,
    this.isCoach = false,
    this.onClose,
    this.onEditBanner,
    this.onEditProfile,
    this.onCoachTap,
    this.onFollow,
    this.onShareQr,
  });

  final bool isOwnProfile;
  final String displayName;
  final String username;
  final int workoutCount;
  final int followers;
  final int following;
  final String? bannerPreset;
  final String? bannerUrl;
  final String? photoUrl;
  final bool isCoach;
  final VoidCallback? onClose;
  final VoidCallback? onEditBanner;
  final VoidCallback? onEditProfile;
  final VoidCallback? onCoachTap;
  final VoidCallback? onFollow;
  final VoidCallback? onShareQr;

  static const _bannerHeight = 148.0;
  static const _avatarRadius = 40.0;
  static const _avatarBorder = 3.0;
  static const _bannerRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final preset = ProfileBannerPresets.byId(bannerPreset);
    final hasBannerPhoto = bannerUrl != null && bannerUrl!.trim().isNotEmpty;
    final hasAvatarPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    const bannerInset = AppSpacing.md + 4;
    const bannerTop = AppSpacing.sm;
    final avatarLeft = bannerInset + AppSpacing.sm;
    final bannerBottom = bannerTop + _bannerHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: bannerBottom + _avatarRadius,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: bannerTop,
                left: bannerInset,
                right: bannerInset,
                height: _bannerHeight,
                child: GestureDetector(
                  onTap: isOwnProfile ? onEditBanner : null,
                  onLongPress: isOwnProfile ? onEditBanner : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_bannerRadius),
                    child: hasBannerPhoto
                        ? Image.network(
                            bannerUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _PresetBanner(preset: preset),
                          )
                        : _PresetBanner(preset: preset),
                  ),
                ),
              ),
              if (isOwnProfile && onEditProfile != null)
                Positioned(
                  top: bannerTop + AppSpacing.sm,
                  left: bannerInset + AppSpacing.sm,
                  child: _BannerAction(
                    child: AppIconButton(
                      icon: Icons.edit_rounded,
                      onPressed: onEditProfile!,
                      iconSize: AppSpacing.iconMd,
                    ),
                  ),
                ),
              if (onClose != null || (isCoach && onCoachTap != null))
                Positioned(
                  top: bannerTop + AppSpacing.sm,
                  right: bannerInset + AppSpacing.sm,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCoach && onCoachTap != null)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: _BannerAction(
                            child: AppIconButton(
                              icon: Icons.people_rounded,
                              onPressed: onCoachTap!,
                              iconSize: AppSpacing.iconMd,
                            ),
                          ),
                        ),
                      if (onClose != null)
                        _BannerAction(
                          child: AtlasSheetNavIcon(
                            onPressed: onClose!,
                            isDismiss: true,
                          ),
                        ),
                    ],
                  ),
                ),
              Positioned(
                left: avatarLeft,
                top: bannerBottom - _avatarRadius,
                child: Container(
                  padding: const EdgeInsets.all(_avatarBorder),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: _avatarRadius,
                    backgroundColor: AppColors.accentOf(context),
                    backgroundImage:
                        hasAvatarPhoto ? NetworkImage(photoUrl!) : null,
                    child: hasAvatarPhoto
                        ? null
                        : Text(
                            initial,
                            style: TextStyle(
                              fontSize: 28,
                              color: AppColors.onAccentOf(context),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            bannerInset,
            AppSpacing.md,
            bannerInset,
            0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (username.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '@$username',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onShareQr != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Material(
                  color: AppColors.component(context),
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onShareQr,
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(
                        Icons.qr_code_rounded,
                        size: 24,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ),
              ],
              if (!isOwnProfile) ...[
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: onFollow,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.textPrimary(context),
                    foregroundColor: AppColors.surface(context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: 10,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(l10n.profileFollow),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sheetPaddingH,
          ),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border(context).withValues(alpha: 0.45),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sheetPaddingH,
          ),
          child: Row(
            children: [
              Expanded(
                child: _Stat(
                  value: '$workoutCount',
                  label: l10n.profileWorkouts,
                ),
              ),
              Expanded(
                child: _Stat(
                  value: '$followers',
                  label: l10n.profileFollowers,
                ),
              ),
              Expanded(
                child: _Stat(
                  value: '$following',
                  label: l10n.profileFollowing,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PresetBanner extends StatelessWidget {
  const _PresetBanner({required this.preset});

  final ProfileBannerPreset preset;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: preset.gradient),
      child: const SizedBox.expand(),
    );
  }
}

class _BannerAction extends StatelessWidget {
  const _BannerAction({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface(context).withValues(alpha: 0.72),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

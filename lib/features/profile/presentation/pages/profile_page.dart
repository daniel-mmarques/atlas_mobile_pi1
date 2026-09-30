import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/app_typography.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/username.dart';
import 'package:atlas_mobile_pi1/features/metrics/workout_metrics.dart';
import 'package:atlas_mobile_pi1/features/profile/data/profile_banner_uploader.dart';
import 'package:atlas_mobile_pi1/features/profile/presentation/widgets/edit_profile_sheet.dart';
import 'package:atlas_mobile_pi1/features/profile/presentation/widgets/profile_banner_picker_sheet.dart';
import 'package:atlas_mobile_pi1/features/profile/presentation/widgets/profile_header.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> showProfileSheet(BuildContext context) {
  return showAtlasSheet<void>(
    context: context,
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: AppSpacing.sheetInitial,
        minChildSize: AppSpacing.sheetMin,
        maxChildSize: AppSpacing.sheetMax,
        shouldCloseOnMinExtent: true,
        builder: (_, scrollController) {
          return ProfileContent(
            scrollController: scrollController,
            showHandle: true,
          );
        },
      );
    },
  );
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
    this.scrollController,
    this.showHandle = false,
  });

  final ScrollController? scrollController;
  final bool showHandle;

  void _openRoute(BuildContext context, String route) {
    final router = GoRouter.of(context);
    Navigator.pop(context);
    router.push(route);
  }

  Future<void> _editBanner(BuildContext context) async {
    final auth = context.read<AuthService>();
    final user = auth.appUser;
    final uid = auth.user?.uid;
    if (user == null || uid == null) return;

    final users = context.read<UserRepository>();
    final uploader = ProfileBannerUploader();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    await showProfileBannerPickerSheet(
      context: context,
      currentPresetId: user.bannerPreset,
      hasPhoto: user.bannerUrl != null && user.bannerUrl!.trim().isNotEmpty,
      onSelectPreset: (presetId) async {
        try {
          await users.updateBanner(
            uid: uid,
            bannerPreset: presetId,
            clearBannerUrl: true,
          );
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.profileBannerUpdated)),
          );
        } catch (_) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.profileBannerError)),
          );
        }
      },
      onPickPhoto: () async {
        try {
          final file = await uploader.pickImage();
          if (file == null) return;
          final url = await uploader.uploadBanner(uid: uid, file: file);
          await users.updateBanner(uid: uid, bannerUrl: url);
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.profileBannerUpdated)),
          );
        } catch (_) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.profileBannerError)),
          );
        }
      },
      onClearPhoto: () async {
        try {
          await users.updateBanner(uid: uid, clearBannerUrl: true);
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.profileBannerUpdated)),
          );
        } catch (_) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.profileBannerError)),
          );
        }
      },
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    final user = context.read<AuthService>().appUser;
    if (user == null) return;
    await showEditProfileSheet(
      context: context,
      user: user,
      onEditBanner: () => _editBanner(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.appUser;
    final uid = auth.user?.uid;
    final l10n = context.l10n;

    final usernameRaw = Username.normalize(user?.username);
    final displayName = user?.name?.trim().isNotEmpty == true
        ? user!.name!.trim()
        : (usernameRaw.isNotEmpty
            ? usernameRaw
            : (user?.email.isNotEmpty == true ? user!.email : 'user'));

    return Column(
      children: [
        if (showHandle) const AtlasSheetHandle(),
        Expanded(
          child: uid == null
              ? Center(child: Text(l10n.notAuthenticated))
              : StreamBuilder<List<Workout>>(
                  stream: context
                      .read<WorkoutService>()
                      .watchUserWorkouts(
                        uid,
                        limit: WorkoutService.profileLimit,
                      ),
                  builder: (context, snapshot) {
                    final workouts = snapshot.data ?? [];
                    final finished =
                        workouts.where((w) => w.finishedAt != null).toList();
                    final weekVolumes =
                        WorkoutMetrics.volumeByWeekday(workouts);
                    final freq = WorkoutMetrics.weeklyFrequency(workouts);
                    final maxVol = weekVolumes.fold<int>(
                      0,
                      (a, b) => a > b ? a : b,
                    );

                    return ListView(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(
                        0,
                        showHandle ? 0 : AppSpacing.sm,
                        0,
                        AppSpacing.sheetPaddingB,
                      ),
                      children: [
                        ProfileHeader(
                          isOwnProfile: true,
                          displayName: displayName,
                          username: usernameRaw,
                          workoutCount: finished.length,
                          followers: 0,
                          following: 0,
                          bannerPreset: user?.bannerPreset,
                          bannerUrl: user?.bannerUrl,
                          photoUrl: user?.photoUrl,
                          isCoach: auth.isCoach,
                          onClose: () => Navigator.of(context).maybePop(),
                          onEditBanner: () => _editBanner(context),
                          onEditProfile: () => _editProfile(context),
                          onCoachTap: () =>
                              _openRoute(context, AppRoutes.coach),
                          onShareQr: () =>
                              _openRoute(context, AppRoutes.profileShare),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sheetPaddingH,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.widgetVolumeSubtitle,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              SizedBox(
                                height: 120,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: List.generate(7, (i) {
                                    final v = weekVolumes[i];
                                    final h = maxVol == 0
                                        ? 8.0
                                        : 16 + (v / maxVol) * 90;
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                        ),
                                        child: Container(
                                          height: h,
                                          decoration: BoxDecoration(
                                            color: v > 0
                                                ? AppColors.accentOf(context)
                                                : AppColors.component(context),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D']
                                    .map(
                                      (e) => Expanded(
                                        child: Text(
                                          e,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.textSecondary(
                                              context,
                                            ),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: AppSpacing.xxl),
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$freq',
                                            style: AppTypography.metric(
                                              context,
                                              size: 32,
                                            ),
                                          ),
                                          Text(
                                            l10n.calendarThisWeek,
                                            style: TextStyle(
                                              color: AppColors.textSecondary(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                l10n.profileRecent,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              if (finished.isEmpty)
                                Text(
                                  l10n.workoutsNoRoutines,
                                  style: TextStyle(
                                    color: AppColors.textSecondary(context),
                                  ),
                                )
                              else
                                ...finished.take(8).map(
                                      (w) => ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(w.name),
                                        subtitle: Text(
                                          '${w.volume} ${l10n.commonKg} · ${w.formattedDuration}',
                                        ),
                                        trailing: const Icon(
                                          Icons.chevron_right_rounded,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          context.push(
                                            AppRoutes.workoutDetails(w.id),
                                            extra: w,
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

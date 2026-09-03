import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/feed/domain/entities/post.dart';
import 'package:atlas_mobile_pi1/ui/components/app_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.accentOf(context),
                backgroundImage: post.userPhotoUrl.isNotEmpty
                    ? ResizeImage(
                        NetworkImage(post.userPhotoUrl),
                        width: 100,
                        height: 100,
                      )
                    : null,
                child: post.userPhotoUrl.isEmpty
                    ? Text(
                        () {
                          final label =
                              post.displayHandle.replaceFirst('@', '');
                          return label.isNotEmpty
                              ? label[0].toUpperCase()
                              : '?';
                        }(),
                        style: TextStyle(color: AppColors.onAccentOf(context)),
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.displayHandle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm', locale)
                          .format(post.createdAt),
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            post.caption,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (post.volume > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.workoutsVolume,
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${post.volume} ${l10n.commonKg}',
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.seeAllExercises,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 22),
              ),
              Text(
                '${post.likes}',
                style: TextStyle(color: AppColors.textSecondary(context)),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.feedCommentsSoon)),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 22),
              ),
              Text(
                '${post.comments}',
                style: TextStyle(color: AppColors.textSecondary(context)),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, size: 22),
              ),
              const Text('0'),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/feed/data/posts_repository.dart';
import 'package:atlas_mobile_pi1/features/feed/domain/entities/post.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/components/loading_empty_list.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:atlas_mobile_pi1/ui/widgets/feed/feed_section_switch.dart';
import 'package:atlas_mobile_pi1/ui/widgets/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  FeedType _selectedFeed = FeedType.discover;

  @override
  Widget build(BuildContext context) {
    final uid = context.select<AuthService, String?>((a) => a.user?.uid);
    final postsRepo = context.read<PostsRepository>();
    final l10n = context.l10n;
    final bottomClearance =
        AppSpacing.shellBottomInset + MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: AppSpacing.shellHeaderHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FeedSectionSwitch(
                      selected: _selectedFeed,
                      onChanged: (type) =>
                          setState(() => _selectedFeed = type),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppIconButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        onPressed: () => context.push(AppRoutes.messages),
                        tooltip: l10n.messagesTitle,
                        iconSize: AppSpacing.iconMd,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: switch (_selectedFeed) {
                  FeedType.discover => LoadingEmptyList<Post>(
                      key: const ValueKey('discover'),
                      stream: postsRepo.watchPublicPosts(),
                      emptyMessage: l10n.feedEmpty,
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.pageHorizontal,
                        0,
                        AppSpacing.pageHorizontal,
                        bottomClearance,
                      ),
                      keyBuilder: (post) => ValueKey(post.id),
                      itemBuilder: (context, post) => FeedCard(post: post),
                    ),
                  FeedType.following => uid == null
                      ? Padding(
                          key: const ValueKey('friends-auth'),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Center(
                            child: Text(l10n.feedLoginRequired),
                          ),
                        )
                      : LoadingEmptyList<Post>(
                          key: const ValueKey('friends'),
                          stream: postsRepo.watchUserPosts(uid),
                          emptyMessage: l10n.feedEmpty,
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.pageHorizontal,
                            0,
                            AppSpacing.pageHorizontal,
                            bottomClearance,
                          ),
                          keyBuilder: (post) => ValueKey(post.id),
                          itemBuilder: (context, post) => FeedCard(post: post),
                        ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

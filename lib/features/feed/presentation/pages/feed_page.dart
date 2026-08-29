import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/feed/data/posts_repository.dart';
import 'package:atlas_mobile_pi1/features/feed/domain/entities/post.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/components/loading_empty_list.dart';
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
    final uid = context.watch<AuthService>().user?.uid;
    final postsRepo = context.read<PostsRepository>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: kToolbarHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FeedSectionSwitch(
                    selected: _selectedFeed,
                    onChanged: (type) => setState(() => _selectedFeed = type),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: IconButton(
                        tooltip: 'Messages',
                        onPressed: () => context.push(AppRoutes.messages),
                        icon: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal - 2,
            0,
            AppSpacing.pageHorizontal - 2,
            AppSpacing.navHeight + AppSpacing.xxl,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: switch (_selectedFeed) {
              FeedType.discover => LoadingEmptyList<Post>(
                  key: const ValueKey('discover'),
                  stream: postsRepo.watchPublicPosts(),
                  emptyMessage: 'Nenhuma publicação no feed ainda.',
                  itemBuilder: (context, post) => FeedCard(post: post),
                ),
              FeedType.following => uid == null
                  ? const Padding(
                      key: ValueKey('friends-auth'),
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(
                        child: Text('Faça login para ver seus posts.'),
                      ),
                    )
                  : LoadingEmptyList<Post>(
                      key: const ValueKey('friends'),
                      stream: postsRepo.watchUserPosts(uid),
                      emptyMessage:
                          'Você ainda não publicou treinos. Finalize um treino!',
                      itemBuilder: (context, post) => FeedCard(post: post),
                    ),
            },
          ),
        ),
      ),
    );
  }
}

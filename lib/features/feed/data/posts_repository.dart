import 'package:atlas_mobile_pi1/core/dataconnect/dc_helpers.dart';
import 'package:atlas_mobile_pi1/dataconnect_generated/atlas.dart';
import 'package:atlas_mobile_pi1/features/feed/domain/entities/post.dart';

abstract class PostsRepository {
  Stream<List<Post>> watchPublicPosts({int limit = 20});
  Stream<List<Post>> watchUserPosts(String userId, {int limit = 20});
  Future<void> createPostFromWorkout({
    required String userId,
    required String userName,
    String username = '',
    required String workoutName,
    required int volume,
    required bool isPublic,
  });
}

class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl({AtlasConnector? connector})
      : _dc = connector ?? AtlasConnector.instance;

  final AtlasConnector _dc;

  Post _mapPublic(ListPublicPostsPosts p) {
    return Post(
      id: p.id,
      userId: p.user.id,
      userName: p.user.name?.trim().isNotEmpty == true
          ? p.user.name!
          : 'User',
      username: p.user.username ?? '',
      userPhotoUrl: '',
      caption: p.caption,
      imageUrl: p.imageUrl,
      likes: p.likes,
      comments: p.comments,
      createdAt: fromDcTimestamp(p.createdAt) ?? DateTime.now(),
      isPublic: p.isPublic,
      volume: p.volume,
    );
  }

  Post _mapUser(ListUserPostsPosts p) {
    return Post(
      id: p.id,
      userId: p.user.id,
      userName: p.user.name?.trim().isNotEmpty == true
          ? p.user.name!
          : 'User',
      username: p.user.username ?? '',
      userPhotoUrl: '',
      caption: p.caption,
      imageUrl: p.imageUrl,
      likes: p.likes,
      comments: p.comments,
      createdAt: fromDcTimestamp(p.createdAt) ?? DateTime.now(),
      isPublic: p.isPublic,
      volume: p.volume,
    );
  }

  @override
  Stream<List<Post>> watchPublicPosts({int limit = 20}) {
    return subscribeMapped(
      () => _dc.listPublicPosts().limit(limit).ref(),
      (ListPublicPostsData data) => data.posts.map(_mapPublic).toList(),
    );
  }

  @override
  Stream<List<Post>> watchUserPosts(String userId, {int limit = 20}) {
    return subscribeMapped(
      () => _dc.listUserPosts(userId: userId).limit(limit).ref(),
      (ListUserPostsData data) => data.posts.map(_mapUser).toList(),
    );
  }

  @override
  Future<void> createPostFromWorkout({
    required String userId,
    required String userName,
    String username = '',
    required String workoutName,
    required int volume,
    required bool isPublic,
  }) async {
    await _dc
        .createPost(
          userId: userId,
          caption: workoutName,
          volume: volume,
          isPublic: isPublic,
        )
        .execute();
  }
}

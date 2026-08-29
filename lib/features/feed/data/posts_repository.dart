import 'package:atlas_mobile_pi1/core/firestore/firestore_paths.dart';
import 'package:atlas_mobile_pi1/features/feed/domain/entities/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PostsRepository {
  Stream<List<Post>> watchPublicPosts({int limit = 20});
  Stream<List<Post>> watchUserPosts(String userId, {int limit = 20});
  Future<void> createPostFromWorkout({
    required String userId,
    required String userName,
    required String workoutName,
    required int volume,
    required bool isPublic,
  });
}

class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  Stream<List<Post>> watchPublicPosts({int limit = 20}) {
    return _db
        .collection(FirestorePaths.posts)
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(_mapPosts);
  }

  @override
  Stream<List<Post>> watchUserPosts(String userId, {int limit = 20}) {
    return _db
        .collection(FirestorePaths.posts)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(_mapPosts);
  }

  List<Post> _mapPosts(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => Post.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> createPostFromWorkout({
    required String userId,
    required String userName,
    required String workoutName,
    required int volume,
    required bool isPublic,
  }) async {
    await _db.collection(FirestorePaths.posts).add({
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': '',
      'caption': workoutName,
      'imageUrl': '',
      'likes': 0,
      'comments': 0,
      'volume': volume,
      'isPublic': isPublic,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhotoUrl,
    required this.caption,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
    this.username = '',
    this.isPublic = true,
    this.volume = 0,
  });

  final String id;
  final String userId;
  final String userName;
  final String username;
  final String userPhotoUrl;
  final String caption;
  final String imageUrl;
  final int likes;
  final int comments;
  final DateTime createdAt;
  final bool isPublic;
  final int volume;

  String get displayHandle {
    final u = username.trim();
    if (u.isNotEmpty) return u.startsWith('@') ? u : '@$u';
    return userName.isNotEmpty ? userName : 'User';
  }

  factory Post.fromMap(String id, Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    return Post(
      id: id,
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'User',
      username: map['username'] as String? ?? '',
      userPhotoUrl: map['userPhotoUrl'] as String? ?? '',
      caption: map['caption'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      likes: (map['likes'] as num?)?.toInt() ?? 0,
      comments: (map['comments'] as num?)?.toInt() ?? 0,
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      isPublic: map['isPublic'] as bool? ?? true,
      volume: (map['volume'] as num?)?.toInt() ?? 0,
    );
  }
}

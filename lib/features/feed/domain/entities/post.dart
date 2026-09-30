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
}

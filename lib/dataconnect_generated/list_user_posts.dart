part of 'atlas.dart';

class ListUserPostsVariablesBuilder {
  String userId;
  final Optional<int> _limit = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListUserPostsVariablesBuilder limit(int? t) {
    _limit.value = t;
    return this;
  }

  ListUserPostsVariablesBuilder(this._dataConnect, {required this.userId});
  Deserializer<ListUserPostsData> dataDeserializer = (dynamic json) =>
      ListUserPostsData.fromJson(jsonDecode(json));
  Serializer<ListUserPostsVariables> varsSerializer =
      (ListUserPostsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListUserPostsData, ListUserPostsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListUserPostsData, ListUserPostsVariables> ref() {
    ListUserPostsVariables vars = ListUserPostsVariables(
      userId: userId,
      limit: _limit,
    );
    return _dataConnect.query(
      "ListUserPosts",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListUserPostsPosts {
  final String id;
  final ListUserPostsPostsUser user;
  final String caption;
  final String imageUrl;
  final int likes;
  final int comments;
  final int volume;
  final bool isPublic;
  final Timestamp createdAt;
  ListUserPostsPosts.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      user = ListUserPostsPostsUser.fromJson(json['user']),
      caption = nativeFromJson<String>(json['caption']),
      imageUrl = nativeFromJson<String>(json['imageUrl']),
      likes = nativeFromJson<int>(json['likes']),
      comments = nativeFromJson<int>(json['comments']),
      volume = nativeFromJson<int>(json['volume']),
      isPublic = nativeFromJson<bool>(json['isPublic']),
      createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserPostsPosts otherTyped = other as ListUserPostsPosts;
    return id == otherTyped.id &&
        user == otherTyped.user &&
        caption == otherTyped.caption &&
        imageUrl == otherTyped.imageUrl &&
        likes == otherTyped.likes &&
        comments == otherTyped.comments &&
        volume == otherTyped.volume &&
        isPublic == otherTyped.isPublic &&
        createdAt == otherTyped.createdAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    user.hashCode,
    caption.hashCode,
    imageUrl.hashCode,
    likes.hashCode,
    comments.hashCode,
    volume.hashCode,
    isPublic.hashCode,
    createdAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['user'] = user.toJson();
    json['caption'] = nativeToJson<String>(caption);
    json['imageUrl'] = nativeToJson<String>(imageUrl);
    json['likes'] = nativeToJson<int>(likes);
    json['comments'] = nativeToJson<int>(comments);
    json['volume'] = nativeToJson<int>(volume);
    json['isPublic'] = nativeToJson<bool>(isPublic);
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  const ListUserPostsPosts({
    required this.id,
    required this.user,
    required this.caption,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.volume,
    required this.isPublic,
    required this.createdAt,
  });
}

@immutable
class ListUserPostsPostsUser {
  final String id;
  final String? name;
  final String? username;
  ListUserPostsPostsUser.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
      username = json['username'] == null
          ? null
          : nativeFromJson<String>(json['username']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserPostsPostsUser otherTyped = other as ListUserPostsPostsUser;
    return id == otherTyped.id &&
        name == otherTyped.name &&
        username == otherTyped.username;
  }

  @override
  int get hashCode =>
      Object.hashAll([id.hashCode, name.hashCode, username.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    if (username != null) {
      json['username'] = nativeToJson<String?>(username);
    }
    return json;
  }

  const ListUserPostsPostsUser({required this.id, this.name, this.username});
}

@immutable
class ListUserPostsData {
  final List<ListUserPostsPosts> posts;
  ListUserPostsData.fromJson(dynamic json)
    : posts = (json['posts'] as List<dynamic>)
          .map((e) => ListUserPostsPosts.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserPostsData otherTyped = other as ListUserPostsData;
    return posts == otherTyped.posts;
  }

  @override
  int get hashCode => posts.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['posts'] = posts.map((e) => e.toJson()).toList();
    return json;
  }

  const ListUserPostsData({required this.posts});
}

@immutable
class ListUserPostsVariables {
  final String userId;
  late final Optional<int> limit;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListUserPostsVariables.fromJson(Map<String, dynamic> json)
    : userId = nativeFromJson<String>(json['userId']) {
    limit = Optional.optional(nativeFromJson, nativeToJson);
    limit.value = json['limit'] == null
        ? null
        : nativeFromJson<int>(json['limit']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserPostsVariables otherTyped = other as ListUserPostsVariables;
    return userId == otherTyped.userId && limit == otherTyped.limit;
  }

  @override
  int get hashCode => Object.hashAll([userId.hashCode, limit.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    if (limit.state == OptionalState.set) {
      json['limit'] = limit.toJson();
    }
    return json;
  }

  ListUserPostsVariables({required this.userId, required this.limit});
}

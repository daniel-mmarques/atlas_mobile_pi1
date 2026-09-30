part of 'atlas.dart';

class ListPublicPostsVariablesBuilder {
  final Optional<int> _limit = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListPublicPostsVariablesBuilder limit(int? t) {
    _limit.value = t;
    return this;
  }

  ListPublicPostsVariablesBuilder(this._dataConnect);
  Deserializer<ListPublicPostsData> dataDeserializer = (dynamic json) =>
      ListPublicPostsData.fromJson(jsonDecode(json));
  Serializer<ListPublicPostsVariables> varsSerializer =
      (ListPublicPostsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListPublicPostsData, ListPublicPostsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListPublicPostsData, ListPublicPostsVariables> ref() {
    ListPublicPostsVariables vars = ListPublicPostsVariables(limit: _limit);
    return _dataConnect.query(
      "ListPublicPosts",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListPublicPostsPosts {
  final String id;
  final ListPublicPostsPostsUser user;
  final String caption;
  final String imageUrl;
  final int likes;
  final int comments;
  final int volume;
  final bool isPublic;
  final Timestamp createdAt;
  ListPublicPostsPosts.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      user = ListPublicPostsPostsUser.fromJson(json['user']),
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

    final ListPublicPostsPosts otherTyped = other as ListPublicPostsPosts;
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

  const ListPublicPostsPosts({
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
class ListPublicPostsPostsUser {
  final String id;
  final String? name;
  final String? username;
  ListPublicPostsPostsUser.fromJson(dynamic json)
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

    final ListPublicPostsPostsUser otherTyped =
        other as ListPublicPostsPostsUser;
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

  const ListPublicPostsPostsUser({required this.id, this.name, this.username});
}

@immutable
class ListPublicPostsData {
  final List<ListPublicPostsPosts> posts;
  ListPublicPostsData.fromJson(dynamic json)
    : posts = (json['posts'] as List<dynamic>)
          .map((e) => ListPublicPostsPosts.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListPublicPostsData otherTyped = other as ListPublicPostsData;
    return posts == otherTyped.posts;
  }

  @override
  int get hashCode => posts.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['posts'] = posts.map((e) => e.toJson()).toList();
    return json;
  }

  const ListPublicPostsData({required this.posts});
}

@immutable
class ListPublicPostsVariables {
  late final Optional<int> limit;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListPublicPostsVariables.fromJson(Map<String, dynamic> json) {
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

    final ListPublicPostsVariables otherTyped =
        other as ListPublicPostsVariables;
    return limit == otherTyped.limit;
  }

  @override
  int get hashCode => limit.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (limit.state == OptionalState.set) {
      json['limit'] = limit.toJson();
    }
    return json;
  }

  ListPublicPostsVariables({required this.limit});
}

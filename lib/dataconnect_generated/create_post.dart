part of 'atlas.dart';

class CreatePostVariablesBuilder {
  String userId;
  String caption;
  int volume;
  bool isPublic;

  final FirebaseDataConnect _dataConnect;
  CreatePostVariablesBuilder(
    this._dataConnect, {
    required this.userId,
    required this.caption,
    required this.volume,
    required this.isPublic,
  });
  Deserializer<CreatePostData> dataDeserializer = (dynamic json) =>
      CreatePostData.fromJson(jsonDecode(json));
  Serializer<CreatePostVariables> varsSerializer = (CreatePostVariables vars) =>
      jsonEncode(vars.toJson());
  Future<OperationResult<CreatePostData, CreatePostVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePostData, CreatePostVariables> ref() {
    CreatePostVariables vars = CreatePostVariables(
      userId: userId,
      caption: caption,
      volume: volume,
      isPublic: isPublic,
    );
    return _dataConnect.mutation(
      "CreatePost",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreatePostPostInsert {
  final String id;
  CreatePostPostInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePostPostInsert otherTyped = other as CreatePostPostInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreatePostPostInsert({required this.id});
}

@immutable
class CreatePostData {
  final CreatePostPostInsert post_insert;
  CreatePostData.fromJson(dynamic json)
    : post_insert = CreatePostPostInsert.fromJson(json['post_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePostData otherTyped = other as CreatePostData;
    return post_insert == otherTyped.post_insert;
  }

  @override
  int get hashCode => post_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['post_insert'] = post_insert.toJson();
    return json;
  }

  const CreatePostData({required this.post_insert});
}

@immutable
class CreatePostVariables {
  final String userId;
  final String caption;
  final int volume;
  final bool isPublic;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreatePostVariables.fromJson(Map<String, dynamic> json)
    : userId = nativeFromJson<String>(json['userId']),
      caption = nativeFromJson<String>(json['caption']),
      volume = nativeFromJson<int>(json['volume']),
      isPublic = nativeFromJson<bool>(json['isPublic']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePostVariables otherTyped = other as CreatePostVariables;
    return userId == otherTyped.userId &&
        caption == otherTyped.caption &&
        volume == otherTyped.volume &&
        isPublic == otherTyped.isPublic;
  }

  @override
  int get hashCode => Object.hashAll([
    userId.hashCode,
    caption.hashCode,
    volume.hashCode,
    isPublic.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    json['caption'] = nativeToJson<String>(caption);
    json['volume'] = nativeToJson<int>(volume);
    json['isPublic'] = nativeToJson<bool>(isPublic);
    return json;
  }

  const CreatePostVariables({
    required this.userId,
    required this.caption,
    required this.volume,
    required this.isPublic,
  });
}

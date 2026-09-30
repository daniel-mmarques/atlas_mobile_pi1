part of 'atlas.dart';

class GetConversationVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetConversationVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetConversationData> dataDeserializer = (dynamic json) =>
      GetConversationData.fromJson(jsonDecode(json));
  Serializer<GetConversationVariables> varsSerializer =
      (GetConversationVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetConversationData, GetConversationVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetConversationData, GetConversationVariables> ref() {
    GetConversationVariables vars = GetConversationVariables(id: id);
    return _dataConnect.query(
      "GetConversation",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetConversationConversation {
  final String id;
  final String type;
  final String title;
  final String? titleLower;
  final String lastMessage;
  final String lastSenderName;
  final Timestamp updatedAt;
  final String? createdBy;
  final String? inviteToken;
  final List<GetConversationConversationConversationMembersOnConversation>
  conversationMembers_on_conversation;
  GetConversationConversation.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      type = nativeFromJson<String>(json['type']),
      title = nativeFromJson<String>(json['title']),
      titleLower = json['titleLower'] == null
          ? null
          : nativeFromJson<String>(json['titleLower']),
      lastMessage = nativeFromJson<String>(json['lastMessage']),
      lastSenderName = nativeFromJson<String>(json['lastSenderName']),
      updatedAt = Timestamp.fromJson(json['updatedAt']),
      createdBy = json['createdBy'] == null
          ? null
          : nativeFromJson<String>(json['createdBy']),
      inviteToken = json['inviteToken'] == null
          ? null
          : nativeFromJson<String>(json['inviteToken']),
      conversationMembers_on_conversation =
          (json['conversationMembers_on_conversation'] as List<dynamic>)
              .map(
                (e) =>
                    GetConversationConversationConversationMembersOnConversation.fromJson(
                      e,
                    ),
              )
              .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetConversationConversation otherTyped =
        other as GetConversationConversation;
    return id == otherTyped.id &&
        type == otherTyped.type &&
        title == otherTyped.title &&
        titleLower == otherTyped.titleLower &&
        lastMessage == otherTyped.lastMessage &&
        lastSenderName == otherTyped.lastSenderName &&
        updatedAt == otherTyped.updatedAt &&
        createdBy == otherTyped.createdBy &&
        inviteToken == otherTyped.inviteToken &&
        conversationMembers_on_conversation ==
            otherTyped.conversationMembers_on_conversation;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    type.hashCode,
    title.hashCode,
    titleLower.hashCode,
    lastMessage.hashCode,
    lastSenderName.hashCode,
    updatedAt.hashCode,
    createdBy.hashCode,
    inviteToken.hashCode,
    conversationMembers_on_conversation.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['type'] = nativeToJson<String>(type);
    json['title'] = nativeToJson<String>(title);
    if (titleLower != null) {
      json['titleLower'] = nativeToJson<String?>(titleLower);
    }
    json['lastMessage'] = nativeToJson<String>(lastMessage);
    json['lastSenderName'] = nativeToJson<String>(lastSenderName);
    json['updatedAt'] = updatedAt.toJson();
    if (createdBy != null) {
      json['createdBy'] = nativeToJson<String?>(createdBy);
    }
    if (inviteToken != null) {
      json['inviteToken'] = nativeToJson<String?>(inviteToken);
    }
    json['conversationMembers_on_conversation'] =
        conversationMembers_on_conversation.map((e) => e.toJson()).toList();
    return json;
  }

  const GetConversationConversation({
    required this.id,
    required this.type,
    required this.title,
    this.titleLower,
    required this.lastMessage,
    required this.lastSenderName,
    required this.updatedAt,
    this.createdBy,
    this.inviteToken,
    required this.conversationMembers_on_conversation,
  });
}

@immutable
class GetConversationConversationConversationMembersOnConversation {
  final GetConversationConversationConversationMembersOnConversationUser user;
  GetConversationConversationConversationMembersOnConversation.fromJson(
    dynamic json,
  ) : user =
          GetConversationConversationConversationMembersOnConversationUser.fromJson(
            json['user'],
          );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetConversationConversationConversationMembersOnConversation
    otherTyped =
        other as GetConversationConversationConversationMembersOnConversation;
    return user == otherTyped.user;
  }

  @override
  int get hashCode => user.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user'] = user.toJson();
    return json;
  }

  const GetConversationConversationConversationMembersOnConversation({
    required this.user,
  });
}

@immutable
class GetConversationConversationConversationMembersOnConversationUser {
  final String id;
  final String? name;
  final String? username;
  GetConversationConversationConversationMembersOnConversationUser.fromJson(
    dynamic json,
  ) : id = nativeFromJson<String>(json['id']),
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

    final GetConversationConversationConversationMembersOnConversationUser
    otherTyped =
        other
            as GetConversationConversationConversationMembersOnConversationUser;
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

  const GetConversationConversationConversationMembersOnConversationUser({
    required this.id,
    this.name,
    this.username,
  });
}

@immutable
class GetConversationData {
  final GetConversationConversation? conversation;
  GetConversationData.fromJson(dynamic json)
    : conversation = json['conversation'] == null
          ? null
          : GetConversationConversation.fromJson(json['conversation']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetConversationData otherTyped = other as GetConversationData;
    return conversation == otherTyped.conversation;
  }

  @override
  int get hashCode => conversation.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (conversation != null) {
      json['conversation'] = conversation!.toJson();
    }
    return json;
  }

  const GetConversationData({this.conversation});
}

@immutable
class GetConversationVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetConversationVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetConversationVariables otherTyped =
        other as GetConversationVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetConversationVariables({required this.id});
}

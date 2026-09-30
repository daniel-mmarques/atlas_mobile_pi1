part of 'atlas.dart';

class GetConversationByInviteTokenVariablesBuilder {
  String token;

  final FirebaseDataConnect _dataConnect;
  GetConversationByInviteTokenVariablesBuilder(
    this._dataConnect, {
    required this.token,
  });
  Deserializer<GetConversationByInviteTokenData> dataDeserializer =
      (dynamic json) =>
          GetConversationByInviteTokenData.fromJson(jsonDecode(json));
  Serializer<GetConversationByInviteTokenVariables> varsSerializer =
      (GetConversationByInviteTokenVariables vars) => jsonEncode(vars.toJson());
  Future<
    QueryResult<
      GetConversationByInviteTokenData,
      GetConversationByInviteTokenVariables
    >
  >
  execute() {
    return ref().execute();
  }

  QueryRef<
    GetConversationByInviteTokenData,
    GetConversationByInviteTokenVariables
  >
  ref() {
    GetConversationByInviteTokenVariables vars =
        GetConversationByInviteTokenVariables(token: token);
    return _dataConnect.query(
      "GetConversationByInviteToken",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetConversationByInviteTokenConversations {
  final String id;
  final String type;
  final String title;
  final String? titleLower;
  final String lastMessage;
  final String lastSenderName;
  final Timestamp updatedAt;
  final String? createdBy;
  final String? inviteToken;
  final List<
    GetConversationByInviteTokenConversationsConversationMembersOnConversation
  >
  conversationMembers_on_conversation;
  GetConversationByInviteTokenConversations.fromJson(dynamic json)
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
                    GetConversationByInviteTokenConversationsConversationMembersOnConversation.fromJson(
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

    final GetConversationByInviteTokenConversations otherTyped =
        other as GetConversationByInviteTokenConversations;
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

  const GetConversationByInviteTokenConversations({
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
class GetConversationByInviteTokenConversationsConversationMembersOnConversation {
  final GetConversationByInviteTokenConversationsConversationMembersOnConversationUser
  user;
  GetConversationByInviteTokenConversationsConversationMembersOnConversation.fromJson(
    dynamic json,
  ) : user =
          GetConversationByInviteTokenConversationsConversationMembersOnConversationUser.fromJson(
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

    final GetConversationByInviteTokenConversationsConversationMembersOnConversation
    otherTyped =
        other
            as GetConversationByInviteTokenConversationsConversationMembersOnConversation;
    return user == otherTyped.user;
  }

  @override
  int get hashCode => user.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user'] = user.toJson();
    return json;
  }

  const GetConversationByInviteTokenConversationsConversationMembersOnConversation({
    required this.user,
  });
}

@immutable
class GetConversationByInviteTokenConversationsConversationMembersOnConversationUser {
  final String id;
  final String? name;
  final String? username;
  GetConversationByInviteTokenConversationsConversationMembersOnConversationUser.fromJson(
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

    final GetConversationByInviteTokenConversationsConversationMembersOnConversationUser
    otherTyped =
        other
            as GetConversationByInviteTokenConversationsConversationMembersOnConversationUser;
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

  const GetConversationByInviteTokenConversationsConversationMembersOnConversationUser({
    required this.id,
    this.name,
    this.username,
  });
}

@immutable
class GetConversationByInviteTokenData {
  final List<GetConversationByInviteTokenConversations> conversations;
  GetConversationByInviteTokenData.fromJson(dynamic json)
    : conversations = (json['conversations'] as List<dynamic>)
          .map((e) => GetConversationByInviteTokenConversations.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetConversationByInviteTokenData otherTyped =
        other as GetConversationByInviteTokenData;
    return conversations == otherTyped.conversations;
  }

  @override
  int get hashCode => conversations.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversations'] = conversations.map((e) => e.toJson()).toList();
    return json;
  }

  const GetConversationByInviteTokenData({required this.conversations});
}

@immutable
class GetConversationByInviteTokenVariables {
  final String token;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetConversationByInviteTokenVariables.fromJson(Map<String, dynamic> json)
    : token = nativeFromJson<String>(json['token']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetConversationByInviteTokenVariables otherTyped =
        other as GetConversationByInviteTokenVariables;
    return token == otherTyped.token;
  }

  @override
  int get hashCode => token.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['token'] = nativeToJson<String>(token);
    return json;
  }

  const GetConversationByInviteTokenVariables({required this.token});
}

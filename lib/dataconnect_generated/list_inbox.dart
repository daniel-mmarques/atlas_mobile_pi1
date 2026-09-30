part of 'atlas.dart';

class ListInboxVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  ListInboxVariablesBuilder(this._dataConnect, {required this.userId});
  Deserializer<ListInboxData> dataDeserializer = (dynamic json) =>
      ListInboxData.fromJson(jsonDecode(json));
  Serializer<ListInboxVariables> varsSerializer = (ListInboxVariables vars) =>
      jsonEncode(vars.toJson());
  Future<QueryResult<ListInboxData, ListInboxVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListInboxData, ListInboxVariables> ref() {
    ListInboxVariables vars = ListInboxVariables(userId: userId);
    return _dataConnect.query(
      "ListInbox",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListInboxConversationMembers {
  final ListInboxConversationMembersConversation conversation;
  ListInboxConversationMembers.fromJson(dynamic json)
    : conversation = ListInboxConversationMembersConversation.fromJson(
        json['conversation'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListInboxConversationMembers otherTyped =
        other as ListInboxConversationMembers;
    return conversation == otherTyped.conversation;
  }

  @override
  int get hashCode => conversation.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversation'] = conversation.toJson();
    return json;
  }

  const ListInboxConversationMembers({required this.conversation});
}

@immutable
class ListInboxConversationMembersConversation {
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
    ListInboxConversationMembersConversationConversationMembersOnConversation
  >
  conversationMembers_on_conversation;
  ListInboxConversationMembersConversation.fromJson(dynamic json)
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
                    ListInboxConversationMembersConversationConversationMembersOnConversation.fromJson(
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

    final ListInboxConversationMembersConversation otherTyped =
        other as ListInboxConversationMembersConversation;
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

  const ListInboxConversationMembersConversation({
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
class ListInboxConversationMembersConversationConversationMembersOnConversation {
  final ListInboxConversationMembersConversationConversationMembersOnConversationUser
  user;
  ListInboxConversationMembersConversationConversationMembersOnConversation.fromJson(
    dynamic json,
  ) : user =
          ListInboxConversationMembersConversationConversationMembersOnConversationUser.fromJson(
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

    final ListInboxConversationMembersConversationConversationMembersOnConversation
    otherTyped =
        other
            as ListInboxConversationMembersConversationConversationMembersOnConversation;
    return user == otherTyped.user;
  }

  @override
  int get hashCode => user.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user'] = user.toJson();
    return json;
  }

  const ListInboxConversationMembersConversationConversationMembersOnConversation({
    required this.user,
  });
}

@immutable
class ListInboxConversationMembersConversationConversationMembersOnConversationUser {
  final String id;
  final String? name;
  final String? username;
  ListInboxConversationMembersConversationConversationMembersOnConversationUser.fromJson(
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

    final ListInboxConversationMembersConversationConversationMembersOnConversationUser
    otherTyped =
        other
            as ListInboxConversationMembersConversationConversationMembersOnConversationUser;
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

  const ListInboxConversationMembersConversationConversationMembersOnConversationUser({
    required this.id,
    this.name,
    this.username,
  });
}

@immutable
class ListInboxData {
  final List<ListInboxConversationMembers> conversationMembers;
  ListInboxData.fromJson(dynamic json)
    : conversationMembers = (json['conversationMembers'] as List<dynamic>)
          .map((e) => ListInboxConversationMembers.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListInboxData otherTyped = other as ListInboxData;
    return conversationMembers == otherTyped.conversationMembers;
  }

  @override
  int get hashCode => conversationMembers.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversationMembers'] = conversationMembers
        .map((e) => e.toJson())
        .toList();
    return json;
  }

  const ListInboxData({required this.conversationMembers});
}

@immutable
class ListInboxVariables {
  final String userId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListInboxVariables.fromJson(Map<String, dynamic> json)
    : userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListInboxVariables otherTyped = other as ListInboxVariables;
    return userId == otherTyped.userId;
  }

  @override
  int get hashCode => userId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  const ListInboxVariables({required this.userId});
}

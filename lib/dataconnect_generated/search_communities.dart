part of 'atlas.dart';

class SearchCommunitiesVariablesBuilder {
  String q;
  String end;

  final FirebaseDataConnect _dataConnect;
  SearchCommunitiesVariablesBuilder(
    this._dataConnect, {
    required this.q,
    required this.end,
  });
  Deserializer<SearchCommunitiesData> dataDeserializer = (dynamic json) =>
      SearchCommunitiesData.fromJson(jsonDecode(json));
  Serializer<SearchCommunitiesVariables> varsSerializer =
      (SearchCommunitiesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SearchCommunitiesData, SearchCommunitiesVariables>>
  execute() {
    return ref().execute();
  }

  QueryRef<SearchCommunitiesData, SearchCommunitiesVariables> ref() {
    SearchCommunitiesVariables vars = SearchCommunitiesVariables(
      q: q,
      end: end,
    );
    return _dataConnect.query(
      "SearchCommunities",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class SearchCommunitiesConversations {
  final String id;
  final String type;
  final String title;
  final String? titleLower;
  final String lastMessage;
  final String lastSenderName;
  final Timestamp updatedAt;
  final String? createdBy;
  final String? inviteToken;
  final List<SearchCommunitiesConversationsConversationMembersOnConversation>
  conversationMembers_on_conversation;
  SearchCommunitiesConversations.fromJson(dynamic json)
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
                    SearchCommunitiesConversationsConversationMembersOnConversation.fromJson(
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

    final SearchCommunitiesConversations otherTyped =
        other as SearchCommunitiesConversations;
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

  const SearchCommunitiesConversations({
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
class SearchCommunitiesConversationsConversationMembersOnConversation {
  final SearchCommunitiesConversationsConversationMembersOnConversationUser
  user;
  SearchCommunitiesConversationsConversationMembersOnConversation.fromJson(
    dynamic json,
  ) : user =
          SearchCommunitiesConversationsConversationMembersOnConversationUser.fromJson(
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

    final SearchCommunitiesConversationsConversationMembersOnConversation
    otherTyped =
        other
            as SearchCommunitiesConversationsConversationMembersOnConversation;
    return user == otherTyped.user;
  }

  @override
  int get hashCode => user.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user'] = user.toJson();
    return json;
  }

  const SearchCommunitiesConversationsConversationMembersOnConversation({
    required this.user,
  });
}

@immutable
class SearchCommunitiesConversationsConversationMembersOnConversationUser {
  final String id;
  final String? name;
  final String? username;
  SearchCommunitiesConversationsConversationMembersOnConversationUser.fromJson(
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

    final SearchCommunitiesConversationsConversationMembersOnConversationUser
    otherTyped =
        other
            as SearchCommunitiesConversationsConversationMembersOnConversationUser;
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

  const SearchCommunitiesConversationsConversationMembersOnConversationUser({
    required this.id,
    this.name,
    this.username,
  });
}

@immutable
class SearchCommunitiesData {
  final List<SearchCommunitiesConversations> conversations;
  SearchCommunitiesData.fromJson(dynamic json)
    : conversations = (json['conversations'] as List<dynamic>)
          .map((e) => SearchCommunitiesConversations.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SearchCommunitiesData otherTyped = other as SearchCommunitiesData;
    return conversations == otherTyped.conversations;
  }

  @override
  int get hashCode => conversations.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversations'] = conversations.map((e) => e.toJson()).toList();
    return json;
  }

  const SearchCommunitiesData({required this.conversations});
}

@immutable
class SearchCommunitiesVariables {
  final String q;
  final String end;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  SearchCommunitiesVariables.fromJson(Map<String, dynamic> json)
    : q = nativeFromJson<String>(json['q']),
      end = nativeFromJson<String>(json['end']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SearchCommunitiesVariables otherTyped =
        other as SearchCommunitiesVariables;
    return q == otherTyped.q && end == otherTyped.end;
  }

  @override
  int get hashCode => Object.hashAll([q.hashCode, end.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['q'] = nativeToJson<String>(q);
    json['end'] = nativeToJson<String>(end);
    return json;
  }

  const SearchCommunitiesVariables({required this.q, required this.end});
}

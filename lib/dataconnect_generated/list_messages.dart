part of 'atlas.dart';

class ListMessagesVariablesBuilder {
  String conversationId;
  final Optional<int> _limit = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListMessagesVariablesBuilder limit(int? t) {
    _limit.value = t;
    return this;
  }

  ListMessagesVariablesBuilder(
    this._dataConnect, {
    required this.conversationId,
  });
  Deserializer<ListMessagesData> dataDeserializer = (dynamic json) =>
      ListMessagesData.fromJson(jsonDecode(json));
  Serializer<ListMessagesVariables> varsSerializer =
      (ListMessagesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListMessagesData, ListMessagesVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListMessagesData, ListMessagesVariables> ref() {
    ListMessagesVariables vars = ListMessagesVariables(
      conversationId: conversationId,
      limit: _limit,
    );
    return _dataConnect.query(
      "ListMessages",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListMessagesMessages {
  final String id;
  final ListMessagesMessagesConversation conversation;
  final String text;
  final String senderId;
  final String senderName;
  final Timestamp createdAt;
  final Timestamp? expiresAt;
  ListMessagesMessages.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      conversation = ListMessagesMessagesConversation.fromJson(
        json['conversation'],
      ),
      text = nativeFromJson<String>(json['text']),
      senderId = nativeFromJson<String>(json['senderId']),
      senderName = nativeFromJson<String>(json['senderName']),
      createdAt = Timestamp.fromJson(json['createdAt']),
      expiresAt = json['expiresAt'] == null
          ? null
          : Timestamp.fromJson(json['expiresAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMessagesMessages otherTyped = other as ListMessagesMessages;
    return id == otherTyped.id &&
        conversation == otherTyped.conversation &&
        text == otherTyped.text &&
        senderId == otherTyped.senderId &&
        senderName == otherTyped.senderName &&
        createdAt == otherTyped.createdAt &&
        expiresAt == otherTyped.expiresAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    conversation.hashCode,
    text.hashCode,
    senderId.hashCode,
    senderName.hashCode,
    createdAt.hashCode,
    expiresAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['conversation'] = conversation.toJson();
    json['text'] = nativeToJson<String>(text);
    json['senderId'] = nativeToJson<String>(senderId);
    json['senderName'] = nativeToJson<String>(senderName);
    json['createdAt'] = createdAt.toJson();
    if (expiresAt != null) {
      json['expiresAt'] = expiresAt!.toJson();
    }
    return json;
  }

  const ListMessagesMessages({
    required this.id,
    required this.conversation,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.createdAt,
    this.expiresAt,
  });
}

@immutable
class ListMessagesMessagesConversation {
  final String id;
  ListMessagesMessagesConversation.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMessagesMessagesConversation otherTyped =
        other as ListMessagesMessagesConversation;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const ListMessagesMessagesConversation({required this.id});
}

@immutable
class ListMessagesData {
  final List<ListMessagesMessages> messages;
  ListMessagesData.fromJson(dynamic json)
    : messages = (json['messages'] as List<dynamic>)
          .map((e) => ListMessagesMessages.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMessagesData otherTyped = other as ListMessagesData;
    return messages == otherTyped.messages;
  }

  @override
  int get hashCode => messages.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['messages'] = messages.map((e) => e.toJson()).toList();
    return json;
  }

  const ListMessagesData({required this.messages});
}

@immutable
class ListMessagesVariables {
  final String conversationId;
  late final Optional<int> limit;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListMessagesVariables.fromJson(Map<String, dynamic> json)
    : conversationId = nativeFromJson<String>(json['conversationId']) {
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

    final ListMessagesVariables otherTyped = other as ListMessagesVariables;
    return conversationId == otherTyped.conversationId &&
        limit == otherTyped.limit;
  }

  @override
  int get hashCode => Object.hashAll([conversationId.hashCode, limit.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversationId'] = nativeToJson<String>(conversationId);
    if (limit.state == OptionalState.set) {
      json['limit'] = limit.toJson();
    }
    return json;
  }

  ListMessagesVariables({
    required this.conversationId,
    required this.limit,
  });
}

part of 'atlas.dart';

class UpsertConversationVariablesBuilder {
  String id;
  String type;
  String title;
  final Optional<String> _titleLower = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<String> _lastMessage = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<String> _lastSenderName = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<String> _createdBy = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<String> _inviteToken = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  UpsertConversationVariablesBuilder titleLower(String? t) {
    _titleLower.value = t;
    return this;
  }

  UpsertConversationVariablesBuilder lastMessage(String? t) {
    _lastMessage.value = t;
    return this;
  }

  UpsertConversationVariablesBuilder lastSenderName(String? t) {
    _lastSenderName.value = t;
    return this;
  }

  UpsertConversationVariablesBuilder createdBy(String? t) {
    _createdBy.value = t;
    return this;
  }

  UpsertConversationVariablesBuilder inviteToken(String? t) {
    _inviteToken.value = t;
    return this;
  }

  UpsertConversationVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.type,
    required this.title,
  });
  Deserializer<UpsertConversationData> dataDeserializer = (dynamic json) =>
      UpsertConversationData.fromJson(jsonDecode(json));
  Serializer<UpsertConversationVariables> varsSerializer =
      (UpsertConversationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertConversationData, UpsertConversationVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<UpsertConversationData, UpsertConversationVariables> ref() {
    UpsertConversationVariables vars = UpsertConversationVariables(
      id: id,
      type: type,
      title: title,
      titleLower: _titleLower,
      lastMessage: _lastMessage,
      lastSenderName: _lastSenderName,
      createdBy: _createdBy,
      inviteToken: _inviteToken,
    );
    return _dataConnect.mutation(
      "UpsertConversation",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpsertConversationConversationUpsert {
  final String id;
  UpsertConversationConversationUpsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertConversationConversationUpsert otherTyped =
        other as UpsertConversationConversationUpsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpsertConversationConversationUpsert({required this.id});
}

@immutable
class UpsertConversationData {
  final UpsertConversationConversationUpsert conversation_upsert;
  UpsertConversationData.fromJson(dynamic json)
    : conversation_upsert = UpsertConversationConversationUpsert.fromJson(
        json['conversation_upsert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertConversationData otherTyped = other as UpsertConversationData;
    return conversation_upsert == otherTyped.conversation_upsert;
  }

  @override
  int get hashCode => conversation_upsert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversation_upsert'] = conversation_upsert.toJson();
    return json;
  }

  const UpsertConversationData({required this.conversation_upsert});
}

@immutable
class UpsertConversationVariables {
  final String id;
  final String type;
  final String title;
  late final Optional<String> titleLower;
  late final Optional<String> lastMessage;
  late final Optional<String> lastSenderName;
  late final Optional<String> createdBy;
  late final Optional<String> inviteToken;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpsertConversationVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      type = nativeFromJson<String>(json['type']),
      title = nativeFromJson<String>(json['title']) {
    titleLower = Optional.optional(nativeFromJson, nativeToJson);
    titleLower.value = json['titleLower'] == null
        ? null
        : nativeFromJson<String>(json['titleLower']);

    lastMessage = Optional.optional(nativeFromJson, nativeToJson);
    lastMessage.value = json['lastMessage'] == null
        ? null
        : nativeFromJson<String>(json['lastMessage']);

    lastSenderName = Optional.optional(nativeFromJson, nativeToJson);
    lastSenderName.value = json['lastSenderName'] == null
        ? null
        : nativeFromJson<String>(json['lastSenderName']);

    createdBy = Optional.optional(nativeFromJson, nativeToJson);
    createdBy.value = json['createdBy'] == null
        ? null
        : nativeFromJson<String>(json['createdBy']);

    inviteToken = Optional.optional(nativeFromJson, nativeToJson);
    inviteToken.value = json['inviteToken'] == null
        ? null
        : nativeFromJson<String>(json['inviteToken']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertConversationVariables otherTyped =
        other as UpsertConversationVariables;
    return id == otherTyped.id &&
        type == otherTyped.type &&
        title == otherTyped.title &&
        titleLower == otherTyped.titleLower &&
        lastMessage == otherTyped.lastMessage &&
        lastSenderName == otherTyped.lastSenderName &&
        createdBy == otherTyped.createdBy &&
        inviteToken == otherTyped.inviteToken;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    type.hashCode,
    title.hashCode,
    titleLower.hashCode,
    lastMessage.hashCode,
    lastSenderName.hashCode,
    createdBy.hashCode,
    inviteToken.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['type'] = nativeToJson<String>(type);
    json['title'] = nativeToJson<String>(title);
    if (titleLower.state == OptionalState.set) {
      json['titleLower'] = titleLower.toJson();
    }
    if (lastMessage.state == OptionalState.set) {
      json['lastMessage'] = lastMessage.toJson();
    }
    if (lastSenderName.state == OptionalState.set) {
      json['lastSenderName'] = lastSenderName.toJson();
    }
    if (createdBy.state == OptionalState.set) {
      json['createdBy'] = createdBy.toJson();
    }
    if (inviteToken.state == OptionalState.set) {
      json['inviteToken'] = inviteToken.toJson();
    }
    return json;
  }

  UpsertConversationVariables({
    required this.id,
    required this.type,
    required this.title,
    required this.titleLower,
    required this.lastMessage,
    required this.lastSenderName,
    required this.createdBy,
    required this.inviteToken,
  });
}

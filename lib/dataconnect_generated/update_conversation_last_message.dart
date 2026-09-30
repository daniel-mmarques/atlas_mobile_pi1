part of 'atlas.dart';

class UpdateConversationLastMessageVariablesBuilder {
  String id;
  String lastMessage;
  String lastSenderName;
  Timestamp updatedAt;

  final FirebaseDataConnect _dataConnect;
  UpdateConversationLastMessageVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.lastMessage,
    required this.lastSenderName,
    required this.updatedAt,
  });
  Deserializer<UpdateConversationLastMessageData> dataDeserializer =
      (dynamic json) =>
          UpdateConversationLastMessageData.fromJson(jsonDecode(json));
  Serializer<UpdateConversationLastMessageVariables> varsSerializer =
      (UpdateConversationLastMessageVariables vars) =>
          jsonEncode(vars.toJson());
  Future<
    OperationResult<
      UpdateConversationLastMessageData,
      UpdateConversationLastMessageVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<
    UpdateConversationLastMessageData,
    UpdateConversationLastMessageVariables
  >
  ref() {
    UpdateConversationLastMessageVariables vars =
        UpdateConversationLastMessageVariables(
          id: id,
          lastMessage: lastMessage,
          lastSenderName: lastSenderName,
          updatedAt: updatedAt,
        );
    return _dataConnect.mutation(
      "UpdateConversationLastMessage",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateConversationLastMessageConversationUpdate {
  final String id;
  UpdateConversationLastMessageConversationUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateConversationLastMessageConversationUpdate otherTyped =
        other as UpdateConversationLastMessageConversationUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdateConversationLastMessageConversationUpdate({required this.id});
}

@immutable
class UpdateConversationLastMessageData {
  final UpdateConversationLastMessageConversationUpdate? conversation_update;
  UpdateConversationLastMessageData.fromJson(dynamic json)
    : conversation_update = json['conversation_update'] == null
          ? null
          : UpdateConversationLastMessageConversationUpdate.fromJson(
              json['conversation_update'],
            );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateConversationLastMessageData otherTyped =
        other as UpdateConversationLastMessageData;
    return conversation_update == otherTyped.conversation_update;
  }

  @override
  int get hashCode => conversation_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (conversation_update != null) {
      json['conversation_update'] = conversation_update!.toJson();
    }
    return json;
  }

  const UpdateConversationLastMessageData({this.conversation_update});
}

@immutable
class UpdateConversationLastMessageVariables {
  final String id;
  final String lastMessage;
  final String lastSenderName;
  final Timestamp updatedAt;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateConversationLastMessageVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      lastMessage = nativeFromJson<String>(json['lastMessage']),
      lastSenderName = nativeFromJson<String>(json['lastSenderName']),
      updatedAt = Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateConversationLastMessageVariables otherTyped =
        other as UpdateConversationLastMessageVariables;
    return id == otherTyped.id &&
        lastMessage == otherTyped.lastMessage &&
        lastSenderName == otherTyped.lastSenderName &&
        updatedAt == otherTyped.updatedAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    lastMessage.hashCode,
    lastSenderName.hashCode,
    updatedAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['lastMessage'] = nativeToJson<String>(lastMessage);
    json['lastSenderName'] = nativeToJson<String>(lastSenderName);
    json['updatedAt'] = updatedAt.toJson();
    return json;
  }

  const UpdateConversationLastMessageVariables({
    required this.id,
    required this.lastMessage,
    required this.lastSenderName,
    required this.updatedAt,
  });
}

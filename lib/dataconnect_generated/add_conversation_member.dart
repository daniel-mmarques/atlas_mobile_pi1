part of 'atlas.dart';

class AddConversationMemberVariablesBuilder {
  String conversationId;
  String userId;

  final FirebaseDataConnect _dataConnect;
  AddConversationMemberVariablesBuilder(
    this._dataConnect, {
    required this.conversationId,
    required this.userId,
  });
  Deserializer<AddConversationMemberData> dataDeserializer = (dynamic json) =>
      AddConversationMemberData.fromJson(jsonDecode(json));
  Serializer<AddConversationMemberVariables> varsSerializer =
      (AddConversationMemberVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<AddConversationMemberData, AddConversationMemberVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<AddConversationMemberData, AddConversationMemberVariables> ref() {
    AddConversationMemberVariables vars = AddConversationMemberVariables(
      conversationId: conversationId,
      userId: userId,
    );
    return _dataConnect.mutation(
      "AddConversationMember",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class AddConversationMemberConversationMemberUpsert {
  final String conversationId;
  final String userId;
  AddConversationMemberConversationMemberUpsert.fromJson(dynamic json)
    : conversationId = nativeFromJson<String>(json['conversationId']),
      userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AddConversationMemberConversationMemberUpsert otherTyped =
        other as AddConversationMemberConversationMemberUpsert;
    return conversationId == otherTyped.conversationId &&
        userId == otherTyped.userId;
  }

  @override
  int get hashCode =>
      Object.hashAll([conversationId.hashCode, userId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversationId'] = nativeToJson<String>(conversationId);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  const AddConversationMemberConversationMemberUpsert({
    required this.conversationId,
    required this.userId,
  });
}

@immutable
class AddConversationMemberData {
  final AddConversationMemberConversationMemberUpsert conversationMember_upsert;
  AddConversationMemberData.fromJson(dynamic json)
    : conversationMember_upsert =
          AddConversationMemberConversationMemberUpsert.fromJson(
            json['conversationMember_upsert'],
          );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AddConversationMemberData otherTyped =
        other as AddConversationMemberData;
    return conversationMember_upsert == otherTyped.conversationMember_upsert;
  }

  @override
  int get hashCode => conversationMember_upsert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversationMember_upsert'] = conversationMember_upsert.toJson();
    return json;
  }

  const AddConversationMemberData({required this.conversationMember_upsert});
}

@immutable
class AddConversationMemberVariables {
  final String conversationId;
  final String userId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  AddConversationMemberVariables.fromJson(Map<String, dynamic> json)
    : conversationId = nativeFromJson<String>(json['conversationId']),
      userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AddConversationMemberVariables otherTyped =
        other as AddConversationMemberVariables;
    return conversationId == otherTyped.conversationId &&
        userId == otherTyped.userId;
  }

  @override
  int get hashCode =>
      Object.hashAll([conversationId.hashCode, userId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversationId'] = nativeToJson<String>(conversationId);
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  const AddConversationMemberVariables({
    required this.conversationId,
    required this.userId,
  });
}

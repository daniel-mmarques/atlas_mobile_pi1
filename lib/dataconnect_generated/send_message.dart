part of 'atlas.dart';

class SendMessageVariablesBuilder {
  String conversationId;
  String text;
  String senderId;
  String senderName;
  Timestamp createdAt;
  final Optional<Timestamp> _expiresAt = Optional.optional(
    (json) => json['expiresAt'] = Timestamp.fromJson(json['expiresAt']),
    defaultSerializer,
  );

  final FirebaseDataConnect _dataConnect;
  SendMessageVariablesBuilder expiresAt(Timestamp? t) {
    _expiresAt.value = t;
    return this;
  }

  SendMessageVariablesBuilder(
    this._dataConnect, {
    required this.conversationId,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.createdAt,
  });
  Deserializer<SendMessageData> dataDeserializer = (dynamic json) =>
      SendMessageData.fromJson(jsonDecode(json));
  Serializer<SendMessageVariables> varsSerializer =
      (SendMessageVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SendMessageData, SendMessageVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SendMessageData, SendMessageVariables> ref() {
    SendMessageVariables vars = SendMessageVariables(
      conversationId: conversationId,
      text: text,
      senderId: senderId,
      senderName: senderName,
      createdAt: createdAt,
      expiresAt: _expiresAt,
    );
    return _dataConnect.mutation(
      "SendMessage",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class SendMessageMessageInsert {
  final String id;
  SendMessageMessageInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SendMessageMessageInsert otherTyped =
        other as SendMessageMessageInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const SendMessageMessageInsert({required this.id});
}

@immutable
class SendMessageData {
  final SendMessageMessageInsert message_insert;
  SendMessageData.fromJson(dynamic json)
    : message_insert = SendMessageMessageInsert.fromJson(
        json['message_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SendMessageData otherTyped = other as SendMessageData;
    return message_insert == otherTyped.message_insert;
  }

  @override
  int get hashCode => message_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['message_insert'] = message_insert.toJson();
    return json;
  }

  const SendMessageData({required this.message_insert});
}

@immutable
class SendMessageVariables {
  final String conversationId;
  final String text;
  final String senderId;
  final String senderName;
  final Timestamp createdAt;
  late final Optional<Timestamp> expiresAt;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  SendMessageVariables.fromJson(Map<String, dynamic> json)
    : conversationId = nativeFromJson<String>(json['conversationId']),
      text = nativeFromJson<String>(json['text']),
      senderId = nativeFromJson<String>(json['senderId']),
      senderName = nativeFromJson<String>(json['senderName']),
      createdAt = Timestamp.fromJson(json['createdAt']) {
    expiresAt = Optional.optional(
      (json) => json['expiresAt'] = Timestamp.fromJson(json['expiresAt']),
      defaultSerializer,
    );
    expiresAt.value = json['expiresAt'] == null
        ? null
        : Timestamp.fromJson(json['expiresAt']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SendMessageVariables otherTyped = other as SendMessageVariables;
    return conversationId == otherTyped.conversationId &&
        text == otherTyped.text &&
        senderId == otherTyped.senderId &&
        senderName == otherTyped.senderName &&
        createdAt == otherTyped.createdAt &&
        expiresAt == otherTyped.expiresAt;
  }

  @override
  int get hashCode => Object.hashAll([
    conversationId.hashCode,
    text.hashCode,
    senderId.hashCode,
    senderName.hashCode,
    createdAt.hashCode,
    expiresAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['conversationId'] = nativeToJson<String>(conversationId);
    json['text'] = nativeToJson<String>(text);
    json['senderId'] = nativeToJson<String>(senderId);
    json['senderName'] = nativeToJson<String>(senderName);
    json['createdAt'] = createdAt.toJson();
    if (expiresAt.state == OptionalState.set) {
      json['expiresAt'] = expiresAt.toJson();
    }
    return json;
  }

  SendMessageVariables({
    required this.conversationId,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.createdAt,
    required this.expiresAt,
  });
}

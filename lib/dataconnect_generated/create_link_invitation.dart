part of 'atlas.dart';

class CreateLinkInvitationVariablesBuilder {
  String token;
  String creatorId;
  String creatorRole;
  Timestamp expiresAt;

  final FirebaseDataConnect _dataConnect;
  CreateLinkInvitationVariablesBuilder(
    this._dataConnect, {
    required this.token,
    required this.creatorId,
    required this.creatorRole,
    required this.expiresAt,
  });
  Deserializer<CreateLinkInvitationData> dataDeserializer = (dynamic json) =>
      CreateLinkInvitationData.fromJson(jsonDecode(json));
  Serializer<CreateLinkInvitationVariables> varsSerializer =
      (CreateLinkInvitationVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<CreateLinkInvitationData, CreateLinkInvitationVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<CreateLinkInvitationData, CreateLinkInvitationVariables> ref() {
    CreateLinkInvitationVariables vars = CreateLinkInvitationVariables(
      token: token,
      creatorId: creatorId,
      creatorRole: creatorRole,
      expiresAt: expiresAt,
    );
    return _dataConnect.mutation(
      "CreateLinkInvitation",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateLinkInvitationLinkInvitationInsert {
  final String token;
  CreateLinkInvitationLinkInvitationInsert.fromJson(dynamic json)
    : token = nativeFromJson<String>(json['token']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLinkInvitationLinkInvitationInsert otherTyped =
        other as CreateLinkInvitationLinkInvitationInsert;
    return token == otherTyped.token;
  }

  @override
  int get hashCode => token.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['token'] = nativeToJson<String>(token);
    return json;
  }

  const CreateLinkInvitationLinkInvitationInsert({required this.token});
}

@immutable
class CreateLinkInvitationData {
  final CreateLinkInvitationLinkInvitationInsert linkInvitation_insert;
  CreateLinkInvitationData.fromJson(dynamic json)
    : linkInvitation_insert = CreateLinkInvitationLinkInvitationInsert.fromJson(
        json['linkInvitation_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLinkInvitationData otherTyped =
        other as CreateLinkInvitationData;
    return linkInvitation_insert == otherTyped.linkInvitation_insert;
  }

  @override
  int get hashCode => linkInvitation_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['linkInvitation_insert'] = linkInvitation_insert.toJson();
    return json;
  }

  const CreateLinkInvitationData({required this.linkInvitation_insert});
}

@immutable
class CreateLinkInvitationVariables {
  final String token;
  final String creatorId;
  final String creatorRole;
  final Timestamp expiresAt;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreateLinkInvitationVariables.fromJson(Map<String, dynamic> json)
    : token = nativeFromJson<String>(json['token']),
      creatorId = nativeFromJson<String>(json['creatorId']),
      creatorRole = nativeFromJson<String>(json['creatorRole']),
      expiresAt = Timestamp.fromJson(json['expiresAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateLinkInvitationVariables otherTyped =
        other as CreateLinkInvitationVariables;
    return token == otherTyped.token &&
        creatorId == otherTyped.creatorId &&
        creatorRole == otherTyped.creatorRole &&
        expiresAt == otherTyped.expiresAt;
  }

  @override
  int get hashCode => Object.hashAll([
    token.hashCode,
    creatorId.hashCode,
    creatorRole.hashCode,
    expiresAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['token'] = nativeToJson<String>(token);
    json['creatorId'] = nativeToJson<String>(creatorId);
    json['creatorRole'] = nativeToJson<String>(creatorRole);
    json['expiresAt'] = expiresAt.toJson();
    return json;
  }

  const CreateLinkInvitationVariables({
    required this.token,
    required this.creatorId,
    required this.creatorRole,
    required this.expiresAt,
  });
}

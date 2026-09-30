part of 'atlas.dart';

class GetLinkInvitationVariablesBuilder {
  String token;

  final FirebaseDataConnect _dataConnect;
  GetLinkInvitationVariablesBuilder(this._dataConnect, {required this.token});
  Deserializer<GetLinkInvitationData> dataDeserializer = (dynamic json) =>
      GetLinkInvitationData.fromJson(jsonDecode(json));
  Serializer<GetLinkInvitationVariables> varsSerializer =
      (GetLinkInvitationVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetLinkInvitationData, GetLinkInvitationVariables>>
  execute() {
    return ref().execute();
  }

  QueryRef<GetLinkInvitationData, GetLinkInvitationVariables> ref() {
    GetLinkInvitationVariables vars = GetLinkInvitationVariables(token: token);
    return _dataConnect.query(
      "GetLinkInvitation",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetLinkInvitationLinkInvitation {
  final String token;
  final String creatorId;
  final String creatorRole;
  final String status;
  final Timestamp expiresAt;
  final Timestamp createdAt;
  GetLinkInvitationLinkInvitation.fromJson(dynamic json)
    : token = nativeFromJson<String>(json['token']),
      creatorId = nativeFromJson<String>(json['creatorId']),
      creatorRole = nativeFromJson<String>(json['creatorRole']),
      status = nativeFromJson<String>(json['status']),
      expiresAt = Timestamp.fromJson(json['expiresAt']),
      createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetLinkInvitationLinkInvitation otherTyped =
        other as GetLinkInvitationLinkInvitation;
    return token == otherTyped.token &&
        creatorId == otherTyped.creatorId &&
        creatorRole == otherTyped.creatorRole &&
        status == otherTyped.status &&
        expiresAt == otherTyped.expiresAt &&
        createdAt == otherTyped.createdAt;
  }

  @override
  int get hashCode => Object.hashAll([
    token.hashCode,
    creatorId.hashCode,
    creatorRole.hashCode,
    status.hashCode,
    expiresAt.hashCode,
    createdAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['token'] = nativeToJson<String>(token);
    json['creatorId'] = nativeToJson<String>(creatorId);
    json['creatorRole'] = nativeToJson<String>(creatorRole);
    json['status'] = nativeToJson<String>(status);
    json['expiresAt'] = expiresAt.toJson();
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  const GetLinkInvitationLinkInvitation({
    required this.token,
    required this.creatorId,
    required this.creatorRole,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
  });
}

@immutable
class GetLinkInvitationData {
  final GetLinkInvitationLinkInvitation? linkInvitation;
  GetLinkInvitationData.fromJson(dynamic json)
    : linkInvitation = json['linkInvitation'] == null
          ? null
          : GetLinkInvitationLinkInvitation.fromJson(json['linkInvitation']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetLinkInvitationData otherTyped = other as GetLinkInvitationData;
    return linkInvitation == otherTyped.linkInvitation;
  }

  @override
  int get hashCode => linkInvitation.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (linkInvitation != null) {
      json['linkInvitation'] = linkInvitation!.toJson();
    }
    return json;
  }

  const GetLinkInvitationData({this.linkInvitation});
}

@immutable
class GetLinkInvitationVariables {
  final String token;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetLinkInvitationVariables.fromJson(Map<String, dynamic> json)
    : token = nativeFromJson<String>(json['token']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetLinkInvitationVariables otherTyped =
        other as GetLinkInvitationVariables;
    return token == otherTyped.token;
  }

  @override
  int get hashCode => token.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['token'] = nativeToJson<String>(token);
    return json;
  }

  const GetLinkInvitationVariables({required this.token});
}

part of 'atlas.dart';

class UpdateLinkInvitationStatusVariablesBuilder {
  String token;
  String status;

  final FirebaseDataConnect _dataConnect;
  UpdateLinkInvitationStatusVariablesBuilder(
    this._dataConnect, {
    required this.token,
    required this.status,
  });
  Deserializer<UpdateLinkInvitationStatusData> dataDeserializer =
      (dynamic json) =>
          UpdateLinkInvitationStatusData.fromJson(jsonDecode(json));
  Serializer<UpdateLinkInvitationStatusVariables> varsSerializer =
      (UpdateLinkInvitationStatusVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<
      UpdateLinkInvitationStatusData,
      UpdateLinkInvitationStatusVariables
    >
  >
  execute() {
    return ref().execute();
  }

  MutationRef<
    UpdateLinkInvitationStatusData,
    UpdateLinkInvitationStatusVariables
  >
  ref() {
    UpdateLinkInvitationStatusVariables vars =
        UpdateLinkInvitationStatusVariables(token: token, status: status);
    return _dataConnect.mutation(
      "UpdateLinkInvitationStatus",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateLinkInvitationStatusLinkInvitationUpdate {
  final String token;
  UpdateLinkInvitationStatusLinkInvitationUpdate.fromJson(dynamic json)
    : token = nativeFromJson<String>(json['token']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateLinkInvitationStatusLinkInvitationUpdate otherTyped =
        other as UpdateLinkInvitationStatusLinkInvitationUpdate;
    return token == otherTyped.token;
  }

  @override
  int get hashCode => token.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['token'] = nativeToJson<String>(token);
    return json;
  }

  const UpdateLinkInvitationStatusLinkInvitationUpdate({required this.token});
}

@immutable
class UpdateLinkInvitationStatusData {
  final UpdateLinkInvitationStatusLinkInvitationUpdate? linkInvitation_update;
  UpdateLinkInvitationStatusData.fromJson(dynamic json)
    : linkInvitation_update = json['linkInvitation_update'] == null
          ? null
          : UpdateLinkInvitationStatusLinkInvitationUpdate.fromJson(
              json['linkInvitation_update'],
            );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateLinkInvitationStatusData otherTyped =
        other as UpdateLinkInvitationStatusData;
    return linkInvitation_update == otherTyped.linkInvitation_update;
  }

  @override
  int get hashCode => linkInvitation_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (linkInvitation_update != null) {
      json['linkInvitation_update'] = linkInvitation_update!.toJson();
    }
    return json;
  }

  const UpdateLinkInvitationStatusData({this.linkInvitation_update});
}

@immutable
class UpdateLinkInvitationStatusVariables {
  final String token;
  final String status;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateLinkInvitationStatusVariables.fromJson(Map<String, dynamic> json)
    : token = nativeFromJson<String>(json['token']),
      status = nativeFromJson<String>(json['status']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateLinkInvitationStatusVariables otherTyped =
        other as UpdateLinkInvitationStatusVariables;
    return token == otherTyped.token && status == otherTyped.status;
  }

  @override
  int get hashCode => Object.hashAll([token.hashCode, status.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['token'] = nativeToJson<String>(token);
    json['status'] = nativeToJson<String>(status);
    return json;
  }

  const UpdateLinkInvitationStatusVariables({
    required this.token,
    required this.status,
  });
}

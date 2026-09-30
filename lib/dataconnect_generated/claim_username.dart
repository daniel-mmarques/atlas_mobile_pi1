part of 'atlas.dart';

class ClaimUsernameVariablesBuilder {
  String id;
  String username;

  final FirebaseDataConnect _dataConnect;
  ClaimUsernameVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.username,
  });
  Deserializer<ClaimUsernameData> dataDeserializer = (dynamic json) =>
      ClaimUsernameData.fromJson(jsonDecode(json));
  Serializer<ClaimUsernameVariables> varsSerializer =
      (ClaimUsernameVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ClaimUsernameData, ClaimUsernameVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ClaimUsernameData, ClaimUsernameVariables> ref() {
    ClaimUsernameVariables vars = ClaimUsernameVariables(
      id: id,
      username: username,
    );
    return _dataConnect.mutation(
      "ClaimUsername",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ClaimUsernameUserUpdate {
  final String id;
  ClaimUsernameUserUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ClaimUsernameUserUpdate otherTyped = other as ClaimUsernameUserUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const ClaimUsernameUserUpdate({required this.id});
}

@immutable
class ClaimUsernameData {
  final ClaimUsernameUserUpdate? user_update;
  ClaimUsernameData.fromJson(dynamic json)
    : user_update = json['user_update'] == null
          ? null
          : ClaimUsernameUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ClaimUsernameData otherTyped = other as ClaimUsernameData;
    return user_update == otherTyped.user_update;
  }

  @override
  int get hashCode => user_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  const ClaimUsernameData({this.user_update});
}

@immutable
class ClaimUsernameVariables {
  final String id;
  final String username;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ClaimUsernameVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      username = nativeFromJson<String>(json['username']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ClaimUsernameVariables otherTyped = other as ClaimUsernameVariables;
    return id == otherTyped.id && username == otherTyped.username;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, username.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['username'] = nativeToJson<String>(username);
    return json;
  }

  const ClaimUsernameVariables({required this.id, required this.username});
}

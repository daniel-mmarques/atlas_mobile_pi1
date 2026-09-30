part of 'atlas.dart';

class UpdateUserProfileVariablesBuilder {
  String id;
  String name;
  String nameLower;
  String username;
  Timestamp birthDate;
  String gender;
  double height;
  double weight;
  String activityLevel;
  final Optional<String> _photoUrl = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  UpdateUserProfileVariablesBuilder photoUrl(String? t) {
    _photoUrl.value = t;
    return this;
  }

  UpdateUserProfileVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.name,
    required this.nameLower,
    required this.username,
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });
  Deserializer<UpdateUserProfileData> dataDeserializer = (dynamic json) =>
      UpdateUserProfileData.fromJson(jsonDecode(json));
  Serializer<UpdateUserProfileVariables> varsSerializer =
      (UpdateUserProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateUserProfileData, UpdateUserProfileVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateUserProfileData, UpdateUserProfileVariables> ref() {
    UpdateUserProfileVariables vars = UpdateUserProfileVariables(
      id: id,
      name: name,
      nameLower: nameLower,
      username: username,
      birthDate: birthDate,
      gender: gender,
      height: height,
      weight: weight,
      activityLevel: activityLevel,
      photoUrl: _photoUrl,
    );
    return _dataConnect.mutation(
      "UpdateUserProfile",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateUserProfileUserUpdate {
  final String id;
  UpdateUserProfileUserUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserProfileUserUpdate otherTyped =
        other as UpdateUserProfileUserUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdateUserProfileUserUpdate({required this.id});
}

@immutable
class UpdateUserProfileData {
  final UpdateUserProfileUserUpdate? user_update;
  UpdateUserProfileData.fromJson(dynamic json)
    : user_update = json['user_update'] == null
          ? null
          : UpdateUserProfileUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserProfileData otherTyped = other as UpdateUserProfileData;
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

  const UpdateUserProfileData({this.user_update});
}

@immutable
class UpdateUserProfileVariables {
  final String id;
  final String name;
  final String nameLower;
  final String username;
  final Timestamp birthDate;
  final String gender;
  final double height;
  final double weight;
  final String activityLevel;
  late final Optional<String> photoUrl;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateUserProfileVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      name = nativeFromJson<String>(json['name']),
      nameLower = nativeFromJson<String>(json['nameLower']),
      username = nativeFromJson<String>(json['username']),
      birthDate = Timestamp.fromJson(json['birthDate']),
      gender = nativeFromJson<String>(json['gender']),
      height = nativeFromJson<double>(json['height']),
      weight = nativeFromJson<double>(json['weight']),
      activityLevel = nativeFromJson<String>(json['activityLevel']) {
    photoUrl = Optional.optional(nativeFromJson, nativeToJson);
    photoUrl.value = json['photoUrl'] == null
        ? null
        : nativeFromJson<String>(json['photoUrl']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserProfileVariables otherTyped =
        other as UpdateUserProfileVariables;
    return id == otherTyped.id &&
        name == otherTyped.name &&
        nameLower == otherTyped.nameLower &&
        username == otherTyped.username &&
        birthDate == otherTyped.birthDate &&
        gender == otherTyped.gender &&
        height == otherTyped.height &&
        weight == otherTyped.weight &&
        activityLevel == otherTyped.activityLevel &&
        photoUrl == otherTyped.photoUrl;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    name.hashCode,
    nameLower.hashCode,
    username.hashCode,
    birthDate.hashCode,
    gender.hashCode,
    height.hashCode,
    weight.hashCode,
    activityLevel.hashCode,
    photoUrl.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['nameLower'] = nativeToJson<String>(nameLower);
    json['username'] = nativeToJson<String>(username);
    json['birthDate'] = birthDate.toJson();
    json['gender'] = nativeToJson<String>(gender);
    json['height'] = nativeToJson<double>(height);
    json['weight'] = nativeToJson<double>(weight);
    json['activityLevel'] = nativeToJson<String>(activityLevel);
    if (photoUrl.state == OptionalState.set) {
      json['photoUrl'] = photoUrl.toJson();
    }
    return json;
  }

  UpdateUserProfileVariables({
    required this.id,
    required this.name,
    required this.nameLower,
    required this.username,
    required this.birthDate,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.photoUrl,
  });
}

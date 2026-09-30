part of 'atlas.dart';

class CompleteUserProfileVariablesBuilder {
  String id;
  String name;
  String nameLower;
  String username;
  Timestamp birthDate;
  String gender;
  double height;
  double weight;
  String activityLevel;

  final FirebaseDataConnect _dataConnect;
  CompleteUserProfileVariablesBuilder(
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
  Deserializer<CompleteUserProfileData> dataDeserializer = (dynamic json) =>
      CompleteUserProfileData.fromJson(jsonDecode(json));
  Serializer<CompleteUserProfileVariables> varsSerializer =
      (CompleteUserProfileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CompleteUserProfileData, CompleteUserProfileVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<CompleteUserProfileData, CompleteUserProfileVariables> ref() {
    CompleteUserProfileVariables vars = CompleteUserProfileVariables(
      id: id,
      name: name,
      nameLower: nameLower,
      username: username,
      birthDate: birthDate,
      gender: gender,
      height: height,
      weight: weight,
      activityLevel: activityLevel,
    );
    return _dataConnect.mutation(
      "CompleteUserProfile",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CompleteUserProfileUserUpdate {
  final String id;
  CompleteUserProfileUserUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteUserProfileUserUpdate otherTyped =
        other as CompleteUserProfileUserUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CompleteUserProfileUserUpdate({required this.id});
}

@immutable
class CompleteUserProfileData {
  final CompleteUserProfileUserUpdate? user_update;
  CompleteUserProfileData.fromJson(dynamic json)
    : user_update = json['user_update'] == null
          ? null
          : CompleteUserProfileUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteUserProfileData otherTyped = other as CompleteUserProfileData;
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

  const CompleteUserProfileData({this.user_update});
}

@immutable
class CompleteUserProfileVariables {
  final String id;
  final String name;
  final String nameLower;
  final String username;
  final Timestamp birthDate;
  final String gender;
  final double height;
  final double weight;
  final String activityLevel;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CompleteUserProfileVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      name = nativeFromJson<String>(json['name']),
      nameLower = nativeFromJson<String>(json['nameLower']),
      username = nativeFromJson<String>(json['username']),
      birthDate = Timestamp.fromJson(json['birthDate']),
      gender = nativeFromJson<String>(json['gender']),
      height = nativeFromJson<double>(json['height']),
      weight = nativeFromJson<double>(json['weight']),
      activityLevel = nativeFromJson<String>(json['activityLevel']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CompleteUserProfileVariables otherTyped =
        other as CompleteUserProfileVariables;
    return id == otherTyped.id &&
        name == otherTyped.name &&
        nameLower == otherTyped.nameLower &&
        username == otherTyped.username &&
        birthDate == otherTyped.birthDate &&
        gender == otherTyped.gender &&
        height == otherTyped.height &&
        weight == otherTyped.weight &&
        activityLevel == otherTyped.activityLevel;
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
    return json;
  }

  const CompleteUserProfileVariables({
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
}

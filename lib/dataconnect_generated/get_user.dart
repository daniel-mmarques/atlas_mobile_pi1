part of 'atlas.dart';

class GetUserVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetUserVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetUserData> dataDeserializer = (dynamic json) =>
      GetUserData.fromJson(jsonDecode(json));
  Serializer<GetUserVariables> varsSerializer = (GetUserVariables vars) =>
      jsonEncode(vars.toJson());
  Future<QueryResult<GetUserData, GetUserVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetUserData, GetUserVariables> ref() {
    GetUserVariables vars = GetUserVariables(id: id);
    return _dataConnect.query(
      "GetUser",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetUserUser {
  final String id;
  final String email;
  final String? name;
  final String? nameLower;
  final String? username;
  final String? gender;
  final double? height;
  final double? weight;
  final Timestamp? birthDate;
  final String? activityLevel;
  final String role;
  final bool profileCompleted;
  final String? bannerPreset;
  final String? bannerUrl;
  final String? photoUrl;
  final Timestamp createdAt;
  GetUserUser.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      email = nativeFromJson<String>(json['email']),
      name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
      nameLower = json['nameLower'] == null
          ? null
          : nativeFromJson<String>(json['nameLower']),
      username = json['username'] == null
          ? null
          : nativeFromJson<String>(json['username']),
      gender = json['gender'] == null
          ? null
          : nativeFromJson<String>(json['gender']),
      height = json['height'] == null
          ? null
          : nativeFromJson<double>(json['height']),
      weight = json['weight'] == null
          ? null
          : nativeFromJson<double>(json['weight']),
      birthDate = json['birthDate'] == null
          ? null
          : Timestamp.fromJson(json['birthDate']),
      activityLevel = json['activityLevel'] == null
          ? null
          : nativeFromJson<String>(json['activityLevel']),
      role = nativeFromJson<String>(json['role']),
      profileCompleted = nativeFromJson<bool>(json['profileCompleted']),
      bannerPreset = json['bannerPreset'] == null
          ? null
          : nativeFromJson<String>(json['bannerPreset']),
      bannerUrl = json['bannerUrl'] == null
          ? null
          : nativeFromJson<String>(json['bannerUrl']),
      photoUrl = json['photoUrl'] == null
          ? null
          : nativeFromJson<String>(json['photoUrl']),
      createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserUser otherTyped = other as GetUserUser;
    return id == otherTyped.id &&
        email == otherTyped.email &&
        name == otherTyped.name &&
        nameLower == otherTyped.nameLower &&
        username == otherTyped.username &&
        gender == otherTyped.gender &&
        height == otherTyped.height &&
        weight == otherTyped.weight &&
        birthDate == otherTyped.birthDate &&
        activityLevel == otherTyped.activityLevel &&
        role == otherTyped.role &&
        profileCompleted == otherTyped.profileCompleted &&
        bannerPreset == otherTyped.bannerPreset &&
        bannerUrl == otherTyped.bannerUrl &&
        photoUrl == otherTyped.photoUrl &&
        createdAt == otherTyped.createdAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    email.hashCode,
    name.hashCode,
    nameLower.hashCode,
    username.hashCode,
    gender.hashCode,
    height.hashCode,
    weight.hashCode,
    birthDate.hashCode,
    activityLevel.hashCode,
    role.hashCode,
    profileCompleted.hashCode,
    bannerPreset.hashCode,
    bannerUrl.hashCode,
    photoUrl.hashCode,
    createdAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['email'] = nativeToJson<String>(email);
    if (name != null) {
      json['name'] = nativeToJson<String?>(name);
    }
    if (nameLower != null) {
      json['nameLower'] = nativeToJson<String?>(nameLower);
    }
    if (username != null) {
      json['username'] = nativeToJson<String?>(username);
    }
    if (gender != null) {
      json['gender'] = nativeToJson<String?>(gender);
    }
    if (height != null) {
      json['height'] = nativeToJson<double?>(height);
    }
    if (weight != null) {
      json['weight'] = nativeToJson<double?>(weight);
    }
    if (birthDate != null) {
      json['birthDate'] = birthDate!.toJson();
    }
    if (activityLevel != null) {
      json['activityLevel'] = nativeToJson<String?>(activityLevel);
    }
    json['role'] = nativeToJson<String>(role);
    json['profileCompleted'] = nativeToJson<bool>(profileCompleted);
    if (bannerPreset != null) {
      json['bannerPreset'] = nativeToJson<String?>(bannerPreset);
    }
    if (bannerUrl != null) {
      json['bannerUrl'] = nativeToJson<String?>(bannerUrl);
    }
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  const GetUserUser({
    required this.id,
    required this.email,
    this.name,
    this.nameLower,
    this.username,
    this.gender,
    this.height,
    this.weight,
    this.birthDate,
    this.activityLevel,
    required this.role,
    required this.profileCompleted,
    this.bannerPreset,
    this.bannerUrl,
    this.photoUrl,
    required this.createdAt,
  });
}

@immutable
class GetUserData {
  final GetUserUser? user;
  GetUserData.fromJson(dynamic json)
    : user = json['user'] == null ? null : GetUserUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserData otherTyped = other as GetUserData;
    return user == otherTyped.user;
  }

  @override
  int get hashCode => user.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  const GetUserData({this.user});
}

@immutable
class GetUserVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetUserVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserVariables otherTyped = other as GetUserVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetUserVariables({required this.id});
}

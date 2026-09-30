part of 'atlas.dart';

class GetUsersByIdsVariablesBuilder {
  List<String> ids;

  final FirebaseDataConnect _dataConnect;
  GetUsersByIdsVariablesBuilder(this._dataConnect, {required this.ids});
  Deserializer<GetUsersByIdsData> dataDeserializer = (dynamic json) =>
      GetUsersByIdsData.fromJson(jsonDecode(json));
  Serializer<GetUsersByIdsVariables> varsSerializer =
      (GetUsersByIdsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetUsersByIdsData, GetUsersByIdsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetUsersByIdsData, GetUsersByIdsVariables> ref() {
    GetUsersByIdsVariables vars = GetUsersByIdsVariables(ids: ids);
    return _dataConnect.query(
      "GetUsersByIds",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetUsersByIdsUsers {
  final String id;
  final String email;
  final String? name;
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
  GetUsersByIdsUsers.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      email = nativeFromJson<String>(json['email']),
      name = json['name'] == null ? null : nativeFromJson<String>(json['name']),
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

    final GetUsersByIdsUsers otherTyped = other as GetUsersByIdsUsers;
    return id == otherTyped.id &&
        email == otherTyped.email &&
        name == otherTyped.name &&
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

  const GetUsersByIdsUsers({
    required this.id,
    required this.email,
    this.name,
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
class GetUsersByIdsData {
  final List<GetUsersByIdsUsers> users;
  GetUsersByIdsData.fromJson(dynamic json)
    : users = (json['users'] as List<dynamic>)
          .map((e) => GetUsersByIdsUsers.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetUsersByIdsData otherTyped = other as GetUsersByIdsData;
    return users == otherTyped.users;
  }

  @override
  int get hashCode => users.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  const GetUsersByIdsData({required this.users});
}

@immutable
class GetUsersByIdsVariables {
  final List<String> ids;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetUsersByIdsVariables.fromJson(Map<String, dynamic> json)
    : ids = (json['ids'] as List<dynamic>)
          .map((e) => nativeFromJson<String>(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetUsersByIdsVariables otherTyped = other as GetUsersByIdsVariables;
    return ids == otherTyped.ids;
  }

  @override
  int get hashCode => ids.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['ids'] = ids.map((e) => nativeToJson<String>(e)).toList();
    return json;
  }

  const GetUsersByIdsVariables({required this.ids});
}

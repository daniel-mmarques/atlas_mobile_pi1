part of 'atlas.dart';

class GetUserByUsernameVariablesBuilder {
  String username;

  final FirebaseDataConnect _dataConnect;
  GetUserByUsernameVariablesBuilder(
    this._dataConnect, {
    required this.username,
  });
  Deserializer<GetUserByUsernameData> dataDeserializer = (dynamic json) =>
      GetUserByUsernameData.fromJson(jsonDecode(json));
  Serializer<GetUserByUsernameVariables> varsSerializer =
      (GetUserByUsernameVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetUserByUsernameData, GetUserByUsernameVariables>>
  execute() {
    return ref().execute();
  }

  QueryRef<GetUserByUsernameData, GetUserByUsernameVariables> ref() {
    GetUserByUsernameVariables vars = GetUserByUsernameVariables(
      username: username,
    );
    return _dataConnect.query(
      "GetUserByUsername",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetUserByUsernameUsers {
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
  GetUserByUsernameUsers.fromJson(dynamic json)
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

    final GetUserByUsernameUsers otherTyped = other as GetUserByUsernameUsers;
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

  const GetUserByUsernameUsers({
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
class GetUserByUsernameData {
  final List<GetUserByUsernameUsers> users;
  GetUserByUsernameData.fromJson(dynamic json)
    : users = (json['users'] as List<dynamic>)
          .map((e) => GetUserByUsernameUsers.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserByUsernameData otherTyped = other as GetUserByUsernameData;
    return users == otherTyped.users;
  }

  @override
  int get hashCode => users.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  const GetUserByUsernameData({required this.users});
}

@immutable
class GetUserByUsernameVariables {
  final String username;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetUserByUsernameVariables.fromJson(Map<String, dynamic> json)
    : username = nativeFromJson<String>(json['username']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserByUsernameVariables otherTyped =
        other as GetUserByUsernameVariables;
    return username == otherTyped.username;
  }

  @override
  int get hashCode => username.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['username'] = nativeToJson<String>(username);
    return json;
  }

  const GetUserByUsernameVariables({required this.username});
}

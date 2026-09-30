part of 'atlas.dart';

class SearchUsersByUsernameVariablesBuilder {
  String q;
  String end;

  final FirebaseDataConnect _dataConnect;
  SearchUsersByUsernameVariablesBuilder(
    this._dataConnect, {
    required this.q,
    required this.end,
  });
  Deserializer<SearchUsersByUsernameData> dataDeserializer = (dynamic json) =>
      SearchUsersByUsernameData.fromJson(jsonDecode(json));
  Serializer<SearchUsersByUsernameVariables> varsSerializer =
      (SearchUsersByUsernameVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SearchUsersByUsernameData, SearchUsersByUsernameVariables>>
  execute() {
    return ref().execute();
  }

  QueryRef<SearchUsersByUsernameData, SearchUsersByUsernameVariables> ref() {
    SearchUsersByUsernameVariables vars = SearchUsersByUsernameVariables(
      q: q,
      end: end,
    );
    return _dataConnect.query(
      "SearchUsersByUsername",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class SearchUsersByUsernameUsers {
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
  SearchUsersByUsernameUsers.fromJson(dynamic json)
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

    final SearchUsersByUsernameUsers otherTyped =
        other as SearchUsersByUsernameUsers;
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

  const SearchUsersByUsernameUsers({
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
class SearchUsersByUsernameData {
  final List<SearchUsersByUsernameUsers> users;
  SearchUsersByUsernameData.fromJson(dynamic json)
    : users = (json['users'] as List<dynamic>)
          .map((e) => SearchUsersByUsernameUsers.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SearchUsersByUsernameData otherTyped =
        other as SearchUsersByUsernameData;
    return users == otherTyped.users;
  }

  @override
  int get hashCode => users.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  const SearchUsersByUsernameData({required this.users});
}

@immutable
class SearchUsersByUsernameVariables {
  final String q;
  final String end;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  SearchUsersByUsernameVariables.fromJson(Map<String, dynamic> json)
    : q = nativeFromJson<String>(json['q']),
      end = nativeFromJson<String>(json['end']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SearchUsersByUsernameVariables otherTyped =
        other as SearchUsersByUsernameVariables;
    return q == otherTyped.q && end == otherTyped.end;
  }

  @override
  int get hashCode => Object.hashAll([q.hashCode, end.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['q'] = nativeToJson<String>(q);
    json['end'] = nativeToJson<String>(end);
    return json;
  }

  const SearchUsersByUsernameVariables({required this.q, required this.end});
}

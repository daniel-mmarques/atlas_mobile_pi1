part of 'atlas.dart';

class SearchUsersByNameVariablesBuilder {
  String q;
  String end;

  final FirebaseDataConnect _dataConnect;
  SearchUsersByNameVariablesBuilder(
    this._dataConnect, {
    required this.q,
    required this.end,
  });
  Deserializer<SearchUsersByNameData> dataDeserializer = (dynamic json) =>
      SearchUsersByNameData.fromJson(jsonDecode(json));
  Serializer<SearchUsersByNameVariables> varsSerializer =
      (SearchUsersByNameVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<SearchUsersByNameData, SearchUsersByNameVariables>>
  execute() {
    return ref().execute();
  }

  QueryRef<SearchUsersByNameData, SearchUsersByNameVariables> ref() {
    SearchUsersByNameVariables vars = SearchUsersByNameVariables(
      q: q,
      end: end,
    );
    return _dataConnect.query(
      "SearchUsersByName",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class SearchUsersByNameUsers {
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
  SearchUsersByNameUsers.fromJson(dynamic json)
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

    final SearchUsersByNameUsers otherTyped = other as SearchUsersByNameUsers;
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

  const SearchUsersByNameUsers({
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
class SearchUsersByNameData {
  final List<SearchUsersByNameUsers> users;
  SearchUsersByNameData.fromJson(dynamic json)
    : users = (json['users'] as List<dynamic>)
          .map((e) => SearchUsersByNameUsers.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SearchUsersByNameData otherTyped = other as SearchUsersByNameData;
    return users == otherTyped.users;
  }

  @override
  int get hashCode => users.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  const SearchUsersByNameData({required this.users});
}

@immutable
class SearchUsersByNameVariables {
  final String q;
  final String end;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  SearchUsersByNameVariables.fromJson(Map<String, dynamic> json)
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

    final SearchUsersByNameVariables otherTyped =
        other as SearchUsersByNameVariables;
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

  const SearchUsersByNameVariables({required this.q, required this.end});
}

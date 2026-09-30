part of 'atlas.dart';

class UpsertUserVariablesBuilder {
  String id;
  String email;
  final Optional<String> _name = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<String> _nameLower = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<String> _role = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  UpsertUserVariablesBuilder name(String? t) {
    _name.value = t;
    return this;
  }

  UpsertUserVariablesBuilder nameLower(String? t) {
    _nameLower.value = t;
    return this;
  }

  UpsertUserVariablesBuilder role(String? t) {
    _role.value = t;
    return this;
  }

  UpsertUserVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.email,
  });
  Deserializer<UpsertUserData> dataDeserializer = (dynamic json) =>
      UpsertUserData.fromJson(jsonDecode(json));
  Serializer<UpsertUserVariables> varsSerializer = (UpsertUserVariables vars) =>
      jsonEncode(vars.toJson());
  Future<OperationResult<UpsertUserData, UpsertUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertUserData, UpsertUserVariables> ref() {
    UpsertUserVariables vars = UpsertUserVariables(
      id: id,
      email: email,
      name: _name,
      nameLower: _nameLower,
      role: _role,
    );
    return _dataConnect.mutation(
      "UpsertUser",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpsertUserUserUpsert {
  final String id;
  UpsertUserUserUpsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertUserUserUpsert otherTyped = other as UpsertUserUserUpsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpsertUserUserUpsert({required this.id});
}

@immutable
class UpsertUserData {
  final UpsertUserUserUpsert user_upsert;
  UpsertUserData.fromJson(dynamic json)
    : user_upsert = UpsertUserUserUpsert.fromJson(json['user_upsert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertUserData otherTyped = other as UpsertUserData;
    return user_upsert == otherTyped.user_upsert;
  }

  @override
  int get hashCode => user_upsert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user_upsert'] = user_upsert.toJson();
    return json;
  }

  const UpsertUserData({required this.user_upsert});
}

@immutable
class UpsertUserVariables {
  final String id;
  final String email;
  late final Optional<String> name;
  late final Optional<String> nameLower;
  late final Optional<String> role;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpsertUserVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      email = nativeFromJson<String>(json['email']) {
    name = Optional.optional(nativeFromJson, nativeToJson);
    name.value = json['name'] == null
        ? null
        : nativeFromJson<String>(json['name']);

    nameLower = Optional.optional(nativeFromJson, nativeToJson);
    nameLower.value = json['nameLower'] == null
        ? null
        : nativeFromJson<String>(json['nameLower']);

    role = Optional.optional(nativeFromJson, nativeToJson);
    role.value = json['role'] == null
        ? null
        : nativeFromJson<String>(json['role']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertUserVariables otherTyped = other as UpsertUserVariables;
    return id == otherTyped.id &&
        email == otherTyped.email &&
        name == otherTyped.name &&
        nameLower == otherTyped.nameLower &&
        role == otherTyped.role;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    email.hashCode,
    name.hashCode,
    nameLower.hashCode,
    role.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['email'] = nativeToJson<String>(email);
    if (name.state == OptionalState.set) {
      json['name'] = name.toJson();
    }
    if (nameLower.state == OptionalState.set) {
      json['nameLower'] = nameLower.toJson();
    }
    if (role.state == OptionalState.set) {
      json['role'] = role.toJson();
    }
    return json;
  }

  UpsertUserVariables({
    required this.id,
    required this.email,
    required this.name,
    required this.nameLower,
    required this.role,
  });
}

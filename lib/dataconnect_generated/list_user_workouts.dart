part of 'atlas.dart';

class ListUserWorkoutsVariablesBuilder {
  String userId;
  final Optional<int> _limit = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListUserWorkoutsVariablesBuilder limit(int? t) {
    _limit.value = t;
    return this;
  }

  ListUserWorkoutsVariablesBuilder(this._dataConnect, {required this.userId});
  Deserializer<ListUserWorkoutsData> dataDeserializer = (dynamic json) =>
      ListUserWorkoutsData.fromJson(jsonDecode(json));
  Serializer<ListUserWorkoutsVariables> varsSerializer =
      (ListUserWorkoutsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListUserWorkoutsData, ListUserWorkoutsVariables>>
  execute() {
    return ref().execute();
  }

  QueryRef<ListUserWorkoutsData, ListUserWorkoutsVariables> ref() {
    ListUserWorkoutsVariables vars = ListUserWorkoutsVariables(
      userId: userId,
      limit: _limit,
    );
    return _dataConnect.query(
      "ListUserWorkouts",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListUserWorkoutsWorkouts {
  final String id;
  final ListUserWorkoutsWorkoutsUser user;
  final String name;
  final Timestamp? startedAt;
  final Timestamp? finishedAt;
  final AnyValue? exercisesJson;
  final int volume;
  final bool isPublic;
  final String? assignedByCoachId;
  final int source;
  final String? templateId;
  ListUserWorkoutsWorkouts.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      user = ListUserWorkoutsWorkoutsUser.fromJson(json['user']),
      name = nativeFromJson<String>(json['name']),
      startedAt = json['startedAt'] == null
          ? null
          : Timestamp.fromJson(json['startedAt']),
      finishedAt = json['finishedAt'] == null
          ? null
          : Timestamp.fromJson(json['finishedAt']),
      exercisesJson = json['exercisesJson'] == null
          ? null
          : AnyValue.fromJson(json['exercisesJson']),
      volume = nativeFromJson<int>(json['volume']),
      isPublic = nativeFromJson<bool>(json['isPublic']),
      assignedByCoachId = json['assignedByCoachId'] == null
          ? null
          : nativeFromJson<String>(json['assignedByCoachId']),
      source = nativeFromJson<int>(json['source']),
      templateId = json['templateId'] == null
          ? null
          : nativeFromJson<String>(json['templateId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserWorkoutsWorkouts otherTyped =
        other as ListUserWorkoutsWorkouts;
    return id == otherTyped.id &&
        user == otherTyped.user &&
        name == otherTyped.name &&
        startedAt == otherTyped.startedAt &&
        finishedAt == otherTyped.finishedAt &&
        exercisesJson == otherTyped.exercisesJson &&
        volume == otherTyped.volume &&
        isPublic == otherTyped.isPublic &&
        assignedByCoachId == otherTyped.assignedByCoachId &&
        source == otherTyped.source &&
        templateId == otherTyped.templateId;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    user.hashCode,
    name.hashCode,
    startedAt.hashCode,
    finishedAt.hashCode,
    exercisesJson.hashCode,
    volume.hashCode,
    isPublic.hashCode,
    assignedByCoachId.hashCode,
    source.hashCode,
    templateId.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['user'] = user.toJson();
    json['name'] = nativeToJson<String>(name);
    if (startedAt != null) {
      json['startedAt'] = startedAt!.toJson();
    }
    if (finishedAt != null) {
      json['finishedAt'] = finishedAt!.toJson();
    }
    if (exercisesJson != null) {
      json['exercisesJson'] = exercisesJson!.toJson();
    }
    json['volume'] = nativeToJson<int>(volume);
    json['isPublic'] = nativeToJson<bool>(isPublic);
    if (assignedByCoachId != null) {
      json['assignedByCoachId'] = nativeToJson<String?>(assignedByCoachId);
    }
    json['source'] = nativeToJson<int>(source);
    if (templateId != null) {
      json['templateId'] = nativeToJson<String?>(templateId);
    }
    return json;
  }

  const ListUserWorkoutsWorkouts({
    required this.id,
    required this.user,
    required this.name,
    this.startedAt,
    this.finishedAt,
    this.exercisesJson,
    required this.volume,
    required this.isPublic,
    this.assignedByCoachId,
    required this.source,
    this.templateId,
  });
}

@immutable
class ListUserWorkoutsWorkoutsUser {
  final String id;
  ListUserWorkoutsWorkoutsUser.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserWorkoutsWorkoutsUser otherTyped =
        other as ListUserWorkoutsWorkoutsUser;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const ListUserWorkoutsWorkoutsUser({required this.id});
}

@immutable
class ListUserWorkoutsData {
  final List<ListUserWorkoutsWorkouts> workouts;
  ListUserWorkoutsData.fromJson(dynamic json)
    : workouts = (json['workouts'] as List<dynamic>)
          .map((e) => ListUserWorkoutsWorkouts.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserWorkoutsData otherTyped = other as ListUserWorkoutsData;
    return workouts == otherTyped.workouts;
  }

  @override
  int get hashCode => workouts.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['workouts'] = workouts.map((e) => e.toJson()).toList();
    return json;
  }

  const ListUserWorkoutsData({required this.workouts});
}

@immutable
class ListUserWorkoutsVariables {
  final String userId;
  late final Optional<int> limit;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListUserWorkoutsVariables.fromJson(Map<String, dynamic> json)
    : userId = nativeFromJson<String>(json['userId']) {
    limit = Optional.optional(nativeFromJson, nativeToJson);
    limit.value = json['limit'] == null
        ? null
        : nativeFromJson<int>(json['limit']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserWorkoutsVariables otherTyped =
        other as ListUserWorkoutsVariables;
    return userId == otherTyped.userId && limit == otherTyped.limit;
  }

  @override
  int get hashCode => Object.hashAll([userId.hashCode, limit.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    if (limit.state == OptionalState.set) {
      json['limit'] = limit.toJson();
    }
    return json;
  }

  ListUserWorkoutsVariables({required this.userId, required this.limit});
}

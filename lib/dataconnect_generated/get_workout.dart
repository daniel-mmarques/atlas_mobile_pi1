part of 'atlas.dart';

class GetWorkoutVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetWorkoutVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetWorkoutData> dataDeserializer = (dynamic json) =>
      GetWorkoutData.fromJson(jsonDecode(json));
  Serializer<GetWorkoutVariables> varsSerializer = (GetWorkoutVariables vars) =>
      jsonEncode(vars.toJson());
  Future<QueryResult<GetWorkoutData, GetWorkoutVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetWorkoutData, GetWorkoutVariables> ref() {
    GetWorkoutVariables vars = GetWorkoutVariables(id: id);
    return _dataConnect.query(
      "GetWorkout",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetWorkoutWorkout {
  final String id;
  final GetWorkoutWorkoutUser user;
  final String name;
  final Timestamp? startedAt;
  final Timestamp? finishedAt;
  final AnyValue? exercisesJson;
  final int volume;
  final bool isPublic;
  final String? assignedByCoachId;
  final int source;
  final String? templateId;
  GetWorkoutWorkout.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      user = GetWorkoutWorkoutUser.fromJson(json['user']),
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

    final GetWorkoutWorkout otherTyped = other as GetWorkoutWorkout;
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

  const GetWorkoutWorkout({
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
class GetWorkoutWorkoutUser {
  final String id;
  GetWorkoutWorkoutUser.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkoutWorkoutUser otherTyped = other as GetWorkoutWorkoutUser;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetWorkoutWorkoutUser({required this.id});
}

@immutable
class GetWorkoutData {
  final GetWorkoutWorkout? workout;
  GetWorkoutData.fromJson(dynamic json)
    : workout = json['workout'] == null
          ? null
          : GetWorkoutWorkout.fromJson(json['workout']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkoutData otherTyped = other as GetWorkoutData;
    return workout == otherTyped.workout;
  }

  @override
  int get hashCode => workout.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (workout != null) {
      json['workout'] = workout!.toJson();
    }
    return json;
  }

  const GetWorkoutData({this.workout});
}

@immutable
class GetWorkoutVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetWorkoutVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetWorkoutVariables otherTyped = other as GetWorkoutVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetWorkoutVariables({required this.id});
}

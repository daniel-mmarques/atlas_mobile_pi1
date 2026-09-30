part of 'atlas.dart';

class UpsertWorkoutVariablesBuilder {
  String id;
  String userId;
  String name;
  final Optional<Timestamp> _startedAt = Optional.optional(
    (json) => json['startedAt'] = Timestamp.fromJson(json['startedAt']),
    defaultSerializer,
  );
  final Optional<Timestamp> _finishedAt = Optional.optional(
    (json) => json['finishedAt'] = Timestamp.fromJson(json['finishedAt']),
    defaultSerializer,
  );
  final Optional<AnyValue> _exercisesJson = Optional.optional(
    AnyValue.fromJson,
    defaultSerializer,
  );
  int volume;
  bool isPublic;
  final Optional<String> _assignedByCoachId = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  int source;
  final Optional<String> _templateId = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  UpsertWorkoutVariablesBuilder startedAt(Timestamp? t) {
    _startedAt.value = t;
    return this;
  }

  UpsertWorkoutVariablesBuilder finishedAt(Timestamp? t) {
    _finishedAt.value = t;
    return this;
  }

  UpsertWorkoutVariablesBuilder exercisesJson(AnyValue? t) {
    _exercisesJson.value = t;
    return this;
  }

  UpsertWorkoutVariablesBuilder assignedByCoachId(String? t) {
    _assignedByCoachId.value = t;
    return this;
  }

  UpsertWorkoutVariablesBuilder templateId(String? t) {
    _templateId.value = t;
    return this;
  }

  UpsertWorkoutVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.userId,
    required this.name,
    required this.volume,
    required this.isPublic,
    required this.source,
  });
  Deserializer<UpsertWorkoutData> dataDeserializer = (dynamic json) =>
      UpsertWorkoutData.fromJson(jsonDecode(json));
  Serializer<UpsertWorkoutVariables> varsSerializer =
      (UpsertWorkoutVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertWorkoutData, UpsertWorkoutVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertWorkoutData, UpsertWorkoutVariables> ref() {
    UpsertWorkoutVariables vars = UpsertWorkoutVariables(
      id: id,
      userId: userId,
      name: name,
      startedAt: _startedAt,
      finishedAt: _finishedAt,
      exercisesJson: _exercisesJson,
      volume: volume,
      isPublic: isPublic,
      assignedByCoachId: _assignedByCoachId,
      source: source,
      templateId: _templateId,
    );
    return _dataConnect.mutation(
      "UpsertWorkout",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpsertWorkoutWorkoutUpsert {
  final String id;
  UpsertWorkoutWorkoutUpsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertWorkoutWorkoutUpsert otherTyped =
        other as UpsertWorkoutWorkoutUpsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpsertWorkoutWorkoutUpsert({required this.id});
}

@immutable
class UpsertWorkoutData {
  final UpsertWorkoutWorkoutUpsert workout_upsert;
  UpsertWorkoutData.fromJson(dynamic json)
    : workout_upsert = UpsertWorkoutWorkoutUpsert.fromJson(
        json['workout_upsert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertWorkoutData otherTyped = other as UpsertWorkoutData;
    return workout_upsert == otherTyped.workout_upsert;
  }

  @override
  int get hashCode => workout_upsert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['workout_upsert'] = workout_upsert.toJson();
    return json;
  }

  const UpsertWorkoutData({required this.workout_upsert});
}

@immutable
class UpsertWorkoutVariables {
  final String id;
  final String userId;
  final String name;
  late final Optional<Timestamp> startedAt;
  late final Optional<Timestamp> finishedAt;
  late final Optional<AnyValue> exercisesJson;
  final int volume;
  final bool isPublic;
  late final Optional<String> assignedByCoachId;
  final int source;
  late final Optional<String> templateId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpsertWorkoutVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      userId = nativeFromJson<String>(json['userId']),
      name = nativeFromJson<String>(json['name']),
      volume = nativeFromJson<int>(json['volume']),
      isPublic = nativeFromJson<bool>(json['isPublic']),
      source = nativeFromJson<int>(json['source']) {
    startedAt = Optional.optional(
      (json) => json['startedAt'] = Timestamp.fromJson(json['startedAt']),
      defaultSerializer,
    );
    startedAt.value = json['startedAt'] == null
        ? null
        : Timestamp.fromJson(json['startedAt']);

    finishedAt = Optional.optional(
      (json) => json['finishedAt'] = Timestamp.fromJson(json['finishedAt']),
      defaultSerializer,
    );
    finishedAt.value = json['finishedAt'] == null
        ? null
        : Timestamp.fromJson(json['finishedAt']);

    exercisesJson = Optional.optional(AnyValue.fromJson, defaultSerializer);
    exercisesJson.value = json['exercisesJson'] == null
        ? null
        : AnyValue.fromJson(json['exercisesJson']);

    assignedByCoachId = Optional.optional(nativeFromJson, nativeToJson);
    assignedByCoachId.value = json['assignedByCoachId'] == null
        ? null
        : nativeFromJson<String>(json['assignedByCoachId']);

    templateId = Optional.optional(nativeFromJson, nativeToJson);
    templateId.value = json['templateId'] == null
        ? null
        : nativeFromJson<String>(json['templateId']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertWorkoutVariables otherTyped = other as UpsertWorkoutVariables;
    return id == otherTyped.id &&
        userId == otherTyped.userId &&
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
    userId.hashCode,
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
    json['userId'] = nativeToJson<String>(userId);
    json['name'] = nativeToJson<String>(name);
    if (startedAt.state == OptionalState.set) {
      json['startedAt'] = startedAt.toJson();
    }
    if (finishedAt.state == OptionalState.set) {
      json['finishedAt'] = finishedAt.toJson();
    }
    if (exercisesJson.state == OptionalState.set) {
      json['exercisesJson'] = exercisesJson.toJson();
    }
    json['volume'] = nativeToJson<int>(volume);
    json['isPublic'] = nativeToJson<bool>(isPublic);
    if (assignedByCoachId.state == OptionalState.set) {
      json['assignedByCoachId'] = assignedByCoachId.toJson();
    }
    json['source'] = nativeToJson<int>(source);
    if (templateId.state == OptionalState.set) {
      json['templateId'] = templateId.toJson();
    }
    return json;
  }

  UpsertWorkoutVariables({
    required this.id,
    required this.userId,
    required this.name,
    required this.startedAt,
    required this.finishedAt,
    required this.exercisesJson,
    required this.volume,
    required this.isPublic,
    required this.assignedByCoachId,
    required this.source,
    required this.templateId,
  });
}

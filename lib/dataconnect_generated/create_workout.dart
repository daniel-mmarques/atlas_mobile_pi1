part of 'atlas.dart';

class CreateWorkoutVariablesBuilder {
  String id;
  String userId;
  String name;
  final Optional<Timestamp> _startedAt = Optional.optional(
    (json) => json['startedAt'] = Timestamp.fromJson(json['startedAt']),
    defaultSerializer,
  );
  final Optional<AnyValue> _exercisesJson = Optional.optional(
    AnyValue.fromJson,
    defaultSerializer,
  );
  final Optional<int> _volume = Optional.optional(nativeFromJson, nativeToJson);
  final Optional<bool> _isPublic = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<String> _assignedByCoachId = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<int> _source = Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _templateId = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  CreateWorkoutVariablesBuilder startedAt(Timestamp? t) {
    _startedAt.value = t;
    return this;
  }

  CreateWorkoutVariablesBuilder exercisesJson(AnyValue? t) {
    _exercisesJson.value = t;
    return this;
  }

  CreateWorkoutVariablesBuilder volume(int? t) {
    _volume.value = t;
    return this;
  }

  CreateWorkoutVariablesBuilder isPublic(bool? t) {
    _isPublic.value = t;
    return this;
  }

  CreateWorkoutVariablesBuilder assignedByCoachId(String? t) {
    _assignedByCoachId.value = t;
    return this;
  }

  CreateWorkoutVariablesBuilder source(int? t) {
    _source.value = t;
    return this;
  }

  CreateWorkoutVariablesBuilder templateId(String? t) {
    _templateId.value = t;
    return this;
  }

  CreateWorkoutVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.userId,
    required this.name,
  });
  Deserializer<CreateWorkoutData> dataDeserializer = (dynamic json) =>
      CreateWorkoutData.fromJson(jsonDecode(json));
  Serializer<CreateWorkoutVariables> varsSerializer =
      (CreateWorkoutVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateWorkoutData, CreateWorkoutVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateWorkoutData, CreateWorkoutVariables> ref() {
    CreateWorkoutVariables vars = CreateWorkoutVariables(
      id: id,
      userId: userId,
      name: name,
      startedAt: _startedAt,
      exercisesJson: _exercisesJson,
      volume: _volume,
      isPublic: _isPublic,
      assignedByCoachId: _assignedByCoachId,
      source: _source,
      templateId: _templateId,
    );
    return _dataConnect.mutation(
      "CreateWorkout",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateWorkoutWorkoutInsert {
  final String id;
  CreateWorkoutWorkoutInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWorkoutWorkoutInsert otherTyped =
        other as CreateWorkoutWorkoutInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateWorkoutWorkoutInsert({required this.id});
}

@immutable
class CreateWorkoutData {
  final CreateWorkoutWorkoutInsert workout_insert;
  CreateWorkoutData.fromJson(dynamic json)
    : workout_insert = CreateWorkoutWorkoutInsert.fromJson(
        json['workout_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWorkoutData otherTyped = other as CreateWorkoutData;
    return workout_insert == otherTyped.workout_insert;
  }

  @override
  int get hashCode => workout_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['workout_insert'] = workout_insert.toJson();
    return json;
  }

  const CreateWorkoutData({required this.workout_insert});
}

@immutable
class CreateWorkoutVariables {
  final String id;
  final String userId;
  final String name;
  late final Optional<Timestamp> startedAt;
  late final Optional<AnyValue> exercisesJson;
  late final Optional<int> volume;
  late final Optional<bool> isPublic;
  late final Optional<String> assignedByCoachId;
  late final Optional<int> source;
  late final Optional<String> templateId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreateWorkoutVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      userId = nativeFromJson<String>(json['userId']),
      name = nativeFromJson<String>(json['name']) {
    startedAt = Optional.optional(
      (json) => json['startedAt'] = Timestamp.fromJson(json['startedAt']),
      defaultSerializer,
    );
    startedAt.value = json['startedAt'] == null
        ? null
        : Timestamp.fromJson(json['startedAt']);

    exercisesJson = Optional.optional(AnyValue.fromJson, defaultSerializer);
    exercisesJson.value = json['exercisesJson'] == null
        ? null
        : AnyValue.fromJson(json['exercisesJson']);

    volume = Optional.optional(nativeFromJson, nativeToJson);
    volume.value = json['volume'] == null
        ? null
        : nativeFromJson<int>(json['volume']);

    isPublic = Optional.optional(nativeFromJson, nativeToJson);
    isPublic.value = json['isPublic'] == null
        ? null
        : nativeFromJson<bool>(json['isPublic']);

    assignedByCoachId = Optional.optional(nativeFromJson, nativeToJson);
    assignedByCoachId.value = json['assignedByCoachId'] == null
        ? null
        : nativeFromJson<String>(json['assignedByCoachId']);

    source = Optional.optional(nativeFromJson, nativeToJson);
    source.value = json['source'] == null
        ? null
        : nativeFromJson<int>(json['source']);

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

    final CreateWorkoutVariables otherTyped = other as CreateWorkoutVariables;
    return id == otherTyped.id &&
        userId == otherTyped.userId &&
        name == otherTyped.name &&
        startedAt == otherTyped.startedAt &&
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
    if (exercisesJson.state == OptionalState.set) {
      json['exercisesJson'] = exercisesJson.toJson();
    }
    if (volume.state == OptionalState.set) {
      json['volume'] = volume.toJson();
    }
    if (isPublic.state == OptionalState.set) {
      json['isPublic'] = isPublic.toJson();
    }
    if (assignedByCoachId.state == OptionalState.set) {
      json['assignedByCoachId'] = assignedByCoachId.toJson();
    }
    if (source.state == OptionalState.set) {
      json['source'] = source.toJson();
    }
    if (templateId.state == OptionalState.set) {
      json['templateId'] = templateId.toJson();
    }
    return json;
  }

  CreateWorkoutVariables({
    required this.id,
    required this.userId,
    required this.name,
    required this.startedAt,
    required this.exercisesJson,
    required this.volume,
    required this.isPublic,
    required this.assignedByCoachId,
    required this.source,
    required this.templateId,
  });
}

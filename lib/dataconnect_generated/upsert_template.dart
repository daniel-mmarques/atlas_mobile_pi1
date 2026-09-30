part of 'atlas.dart';

class UpsertTemplateVariablesBuilder {
  String id;
  String userId;
  String name;
  final Optional<AnyValue> _exercisesJson = Optional.optional(
    AnyValue.fromJson,
    defaultSerializer,
  );
  String notes;
  int defaultRestSeconds;
  String scheduleMode;
  final Optional<AnyValue> _weekdaysJson = Optional.optional(
    AnyValue.fromJson,
    defaultSerializer,
  );
  final Optional<int> _restDaysBetween = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  Timestamp createdAt;
  Timestamp updatedAt;

  final FirebaseDataConnect _dataConnect;
  UpsertTemplateVariablesBuilder exercisesJson(AnyValue? t) {
    _exercisesJson.value = t;
    return this;
  }

  UpsertTemplateVariablesBuilder weekdaysJson(AnyValue? t) {
    _weekdaysJson.value = t;
    return this;
  }

  UpsertTemplateVariablesBuilder restDaysBetween(int? t) {
    _restDaysBetween.value = t;
    return this;
  }

  UpsertTemplateVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.userId,
    required this.name,
    required this.notes,
    required this.defaultRestSeconds,
    required this.scheduleMode,
    required this.createdAt,
    required this.updatedAt,
  });
  Deserializer<UpsertTemplateData> dataDeserializer = (dynamic json) =>
      UpsertTemplateData.fromJson(jsonDecode(json));
  Serializer<UpsertTemplateVariables> varsSerializer =
      (UpsertTemplateVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertTemplateData, UpsertTemplateVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<UpsertTemplateData, UpsertTemplateVariables> ref() {
    UpsertTemplateVariables vars = UpsertTemplateVariables(
      id: id,
      userId: userId,
      name: name,
      exercisesJson: _exercisesJson,
      notes: notes,
      defaultRestSeconds: defaultRestSeconds,
      scheduleMode: scheduleMode,
      weekdaysJson: _weekdaysJson,
      restDaysBetween: _restDaysBetween,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
    return _dataConnect.mutation(
      "UpsertTemplate",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpsertTemplateTemplateUpsert {
  final String id;
  UpsertTemplateTemplateUpsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTemplateTemplateUpsert otherTyped =
        other as UpsertTemplateTemplateUpsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpsertTemplateTemplateUpsert({required this.id});
}

@immutable
class UpsertTemplateData {
  final UpsertTemplateTemplateUpsert template_upsert;
  UpsertTemplateData.fromJson(dynamic json)
    : template_upsert = UpsertTemplateTemplateUpsert.fromJson(
        json['template_upsert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTemplateData otherTyped = other as UpsertTemplateData;
    return template_upsert == otherTyped.template_upsert;
  }

  @override
  int get hashCode => template_upsert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['template_upsert'] = template_upsert.toJson();
    return json;
  }

  const UpsertTemplateData({required this.template_upsert});
}

@immutable
class UpsertTemplateVariables {
  final String id;
  final String userId;
  final String name;
  late final Optional<AnyValue> exercisesJson;
  final String notes;
  final int defaultRestSeconds;
  final String scheduleMode;
  late final Optional<AnyValue> weekdaysJson;
  late final Optional<int> restDaysBetween;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpsertTemplateVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      userId = nativeFromJson<String>(json['userId']),
      name = nativeFromJson<String>(json['name']),
      notes = nativeFromJson<String>(json['notes']),
      defaultRestSeconds = nativeFromJson<int>(json['defaultRestSeconds']),
      scheduleMode = nativeFromJson<String>(json['scheduleMode']),
      createdAt = Timestamp.fromJson(json['createdAt']),
      updatedAt = Timestamp.fromJson(json['updatedAt']) {
    exercisesJson = Optional.optional(AnyValue.fromJson, defaultSerializer);
    exercisesJson.value = json['exercisesJson'] == null
        ? null
        : AnyValue.fromJson(json['exercisesJson']);

    weekdaysJson = Optional.optional(AnyValue.fromJson, defaultSerializer);
    weekdaysJson.value = json['weekdaysJson'] == null
        ? null
        : AnyValue.fromJson(json['weekdaysJson']);

    restDaysBetween = Optional.optional(nativeFromJson, nativeToJson);
    restDaysBetween.value = json['restDaysBetween'] == null
        ? null
        : nativeFromJson<int>(json['restDaysBetween']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTemplateVariables otherTyped = other as UpsertTemplateVariables;
    return id == otherTyped.id &&
        userId == otherTyped.userId &&
        name == otherTyped.name &&
        exercisesJson == otherTyped.exercisesJson &&
        notes == otherTyped.notes &&
        defaultRestSeconds == otherTyped.defaultRestSeconds &&
        scheduleMode == otherTyped.scheduleMode &&
        weekdaysJson == otherTyped.weekdaysJson &&
        restDaysBetween == otherTyped.restDaysBetween &&
        createdAt == otherTyped.createdAt &&
        updatedAt == otherTyped.updatedAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    userId.hashCode,
    name.hashCode,
    exercisesJson.hashCode,
    notes.hashCode,
    defaultRestSeconds.hashCode,
    scheduleMode.hashCode,
    weekdaysJson.hashCode,
    restDaysBetween.hashCode,
    createdAt.hashCode,
    updatedAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['userId'] = nativeToJson<String>(userId);
    json['name'] = nativeToJson<String>(name);
    if (exercisesJson.state == OptionalState.set) {
      json['exercisesJson'] = exercisesJson.toJson();
    }
    json['notes'] = nativeToJson<String>(notes);
    json['defaultRestSeconds'] = nativeToJson<int>(defaultRestSeconds);
    json['scheduleMode'] = nativeToJson<String>(scheduleMode);
    if (weekdaysJson.state == OptionalState.set) {
      json['weekdaysJson'] = weekdaysJson.toJson();
    }
    if (restDaysBetween.state == OptionalState.set) {
      json['restDaysBetween'] = restDaysBetween.toJson();
    }
    json['createdAt'] = createdAt.toJson();
    json['updatedAt'] = updatedAt.toJson();
    return json;
  }

  UpsertTemplateVariables({
    required this.id,
    required this.userId,
    required this.name,
    required this.exercisesJson,
    required this.notes,
    required this.defaultRestSeconds,
    required this.scheduleMode,
    required this.weekdaysJson,
    required this.restDaysBetween,
    required this.createdAt,
    required this.updatedAt,
  });
}

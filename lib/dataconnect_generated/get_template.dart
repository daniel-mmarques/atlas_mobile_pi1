part of 'atlas.dart';

class GetTemplateVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetTemplateVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetTemplateData> dataDeserializer = (dynamic json) =>
      GetTemplateData.fromJson(jsonDecode(json));
  Serializer<GetTemplateVariables> varsSerializer =
      (GetTemplateVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetTemplateData, GetTemplateVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetTemplateData, GetTemplateVariables> ref() {
    GetTemplateVariables vars = GetTemplateVariables(id: id);
    return _dataConnect.query(
      "GetTemplate",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class GetTemplateTemplate {
  final String id;
  final GetTemplateTemplateUser user;
  final String name;
  final AnyValue? exercisesJson;
  final String notes;
  final int defaultRestSeconds;
  final String scheduleMode;
  final AnyValue? weekdaysJson;
  final int? restDaysBetween;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  GetTemplateTemplate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      user = GetTemplateTemplateUser.fromJson(json['user']),
      name = nativeFromJson<String>(json['name']),
      exercisesJson = json['exercisesJson'] == null
          ? null
          : AnyValue.fromJson(json['exercisesJson']),
      notes = nativeFromJson<String>(json['notes']),
      defaultRestSeconds = nativeFromJson<int>(json['defaultRestSeconds']),
      scheduleMode = nativeFromJson<String>(json['scheduleMode']),
      weekdaysJson = json['weekdaysJson'] == null
          ? null
          : AnyValue.fromJson(json['weekdaysJson']),
      restDaysBetween = json['restDaysBetween'] == null
          ? null
          : nativeFromJson<int>(json['restDaysBetween']),
      createdAt = Timestamp.fromJson(json['createdAt']),
      updatedAt = Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetTemplateTemplate otherTyped = other as GetTemplateTemplate;
    return id == otherTyped.id &&
        user == otherTyped.user &&
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
    user.hashCode,
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
    json['user'] = user.toJson();
    json['name'] = nativeToJson<String>(name);
    if (exercisesJson != null) {
      json['exercisesJson'] = exercisesJson!.toJson();
    }
    json['notes'] = nativeToJson<String>(notes);
    json['defaultRestSeconds'] = nativeToJson<int>(defaultRestSeconds);
    json['scheduleMode'] = nativeToJson<String>(scheduleMode);
    if (weekdaysJson != null) {
      json['weekdaysJson'] = weekdaysJson!.toJson();
    }
    if (restDaysBetween != null) {
      json['restDaysBetween'] = nativeToJson<int?>(restDaysBetween);
    }
    json['createdAt'] = createdAt.toJson();
    json['updatedAt'] = updatedAt.toJson();
    return json;
  }

  const GetTemplateTemplate({
    required this.id,
    required this.user,
    required this.name,
    this.exercisesJson,
    required this.notes,
    required this.defaultRestSeconds,
    required this.scheduleMode,
    this.weekdaysJson,
    this.restDaysBetween,
    required this.createdAt,
    required this.updatedAt,
  });
}

@immutable
class GetTemplateTemplateUser {
  final String id;
  GetTemplateTemplateUser.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetTemplateTemplateUser otherTyped = other as GetTemplateTemplateUser;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetTemplateTemplateUser({required this.id});
}

@immutable
class GetTemplateData {
  final GetTemplateTemplate? template;
  GetTemplateData.fromJson(dynamic json)
    : template = json['template'] == null
          ? null
          : GetTemplateTemplate.fromJson(json['template']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetTemplateData otherTyped = other as GetTemplateData;
    return template == otherTyped.template;
  }

  @override
  int get hashCode => template.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (template != null) {
      json['template'] = template!.toJson();
    }
    return json;
  }

  const GetTemplateData({this.template});
}

@immutable
class GetTemplateVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  GetTemplateVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetTemplateVariables otherTyped = other as GetTemplateVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetTemplateVariables({required this.id});
}

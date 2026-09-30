part of 'atlas.dart';

class ListUserTemplatesVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  ListUserTemplatesVariablesBuilder(this._dataConnect, {required this.userId});
  Deserializer<ListUserTemplatesData> dataDeserializer = (dynamic json) =>
      ListUserTemplatesData.fromJson(jsonDecode(json));
  Serializer<ListUserTemplatesVariables> varsSerializer =
      (ListUserTemplatesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListUserTemplatesData, ListUserTemplatesVariables>>
  execute() {
    return ref().execute();
  }

  QueryRef<ListUserTemplatesData, ListUserTemplatesVariables> ref() {
    ListUserTemplatesVariables vars = ListUserTemplatesVariables(
      userId: userId,
    );
    return _dataConnect.query(
      "ListUserTemplates",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListUserTemplatesTemplates {
  final String id;
  final ListUserTemplatesTemplatesUser user;
  final String name;
  final AnyValue? exercisesJson;
  final String notes;
  final int defaultRestSeconds;
  final String scheduleMode;
  final AnyValue? weekdaysJson;
  final int? restDaysBetween;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  ListUserTemplatesTemplates.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      user = ListUserTemplatesTemplatesUser.fromJson(json['user']),
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

    final ListUserTemplatesTemplates otherTyped =
        other as ListUserTemplatesTemplates;
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

  const ListUserTemplatesTemplates({
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
class ListUserTemplatesTemplatesUser {
  final String id;
  ListUserTemplatesTemplatesUser.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserTemplatesTemplatesUser otherTyped =
        other as ListUserTemplatesTemplatesUser;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const ListUserTemplatesTemplatesUser({required this.id});
}

@immutable
class ListUserTemplatesData {
  final List<ListUserTemplatesTemplates> templates;
  ListUserTemplatesData.fromJson(dynamic json)
    : templates = (json['templates'] as List<dynamic>)
          .map((e) => ListUserTemplatesTemplates.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserTemplatesData otherTyped = other as ListUserTemplatesData;
    return templates == otherTyped.templates;
  }

  @override
  int get hashCode => templates.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['templates'] = templates.map((e) => e.toJson()).toList();
    return json;
  }

  const ListUserTemplatesData({required this.templates});
}

@immutable
class ListUserTemplatesVariables {
  final String userId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListUserTemplatesVariables.fromJson(Map<String, dynamic> json)
    : userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUserTemplatesVariables otherTyped =
        other as ListUserTemplatesVariables;
    return userId == otherTyped.userId;
  }

  @override
  int get hashCode => userId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  const ListUserTemplatesVariables({required this.userId});
}

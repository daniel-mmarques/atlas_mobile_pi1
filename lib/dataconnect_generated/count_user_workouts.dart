part of 'atlas.dart';

class CountUserWorkoutsVariablesBuilder {
  String userId;

  final FirebaseDataConnect _dataConnect;
  CountUserWorkoutsVariablesBuilder(this._dataConnect, {required this.userId});
  Deserializer<CountUserWorkoutsData> dataDeserializer = (dynamic json) =>
      CountUserWorkoutsData.fromJson(jsonDecode(json));
  Serializer<CountUserWorkoutsVariables> varsSerializer =
      (CountUserWorkoutsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<CountUserWorkoutsData, CountUserWorkoutsVariables>>
  execute() {
    return ref().execute();
  }

  QueryRef<CountUserWorkoutsData, CountUserWorkoutsVariables> ref() {
    CountUserWorkoutsVariables vars = CountUserWorkoutsVariables(
      userId: userId,
    );
    return _dataConnect.query(
      "CountUserWorkouts",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CountUserWorkoutsWorkouts {
  final String id;
  final Timestamp? finishedAt;
  CountUserWorkoutsWorkouts.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      finishedAt = json['finishedAt'] == null
          ? null
          : Timestamp.fromJson(json['finishedAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CountUserWorkoutsWorkouts otherTyped =
        other as CountUserWorkoutsWorkouts;
    return id == otherTyped.id && finishedAt == otherTyped.finishedAt;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, finishedAt.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (finishedAt != null) {
      json['finishedAt'] = finishedAt!.toJson();
    }
    return json;
  }

  const CountUserWorkoutsWorkouts({required this.id, this.finishedAt});
}

@immutable
class CountUserWorkoutsData {
  final List<CountUserWorkoutsWorkouts> workouts;
  CountUserWorkoutsData.fromJson(dynamic json)
    : workouts = (json['workouts'] as List<dynamic>)
          .map((e) => CountUserWorkoutsWorkouts.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CountUserWorkoutsData otherTyped = other as CountUserWorkoutsData;
    return workouts == otherTyped.workouts;
  }

  @override
  int get hashCode => workouts.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['workouts'] = workouts.map((e) => e.toJson()).toList();
    return json;
  }

  const CountUserWorkoutsData({required this.workouts});
}

@immutable
class CountUserWorkoutsVariables {
  final String userId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CountUserWorkoutsVariables.fromJson(Map<String, dynamic> json)
    : userId = nativeFromJson<String>(json['userId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CountUserWorkoutsVariables otherTyped =
        other as CountUserWorkoutsVariables;
    return userId == otherTyped.userId;
  }

  @override
  int get hashCode => userId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['userId'] = nativeToJson<String>(userId);
    return json;
  }

  const CountUserWorkoutsVariables({required this.userId});
}

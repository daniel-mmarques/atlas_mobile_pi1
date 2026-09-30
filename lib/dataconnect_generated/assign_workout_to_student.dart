part of 'atlas.dart';

class AssignWorkoutToStudentVariablesBuilder {
  String id;
  String studentId;
  String name;
  Timestamp startedAt;
  String coachId;
  int source;

  final FirebaseDataConnect _dataConnect;
  AssignWorkoutToStudentVariablesBuilder(
    this._dataConnect, {
    required this.id,
    required this.studentId,
    required this.name,
    required this.startedAt,
    required this.coachId,
    required this.source,
  });
  Deserializer<AssignWorkoutToStudentData> dataDeserializer = (dynamic json) =>
      AssignWorkoutToStudentData.fromJson(jsonDecode(json));
  Serializer<AssignWorkoutToStudentVariables> varsSerializer =
      (AssignWorkoutToStudentVariables vars) => jsonEncode(vars.toJson());
  Future<
    OperationResult<AssignWorkoutToStudentData, AssignWorkoutToStudentVariables>
  >
  execute() {
    return ref().execute();
  }

  MutationRef<AssignWorkoutToStudentData, AssignWorkoutToStudentVariables>
  ref() {
    AssignWorkoutToStudentVariables vars = AssignWorkoutToStudentVariables(
      id: id,
      studentId: studentId,
      name: name,
      startedAt: startedAt,
      coachId: coachId,
      source: source,
    );
    return _dataConnect.mutation(
      "AssignWorkoutToStudent",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class AssignWorkoutToStudentWorkoutInsert {
  final String id;
  AssignWorkoutToStudentWorkoutInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AssignWorkoutToStudentWorkoutInsert otherTyped =
        other as AssignWorkoutToStudentWorkoutInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const AssignWorkoutToStudentWorkoutInsert({required this.id});
}

@immutable
class AssignWorkoutToStudentData {
  final AssignWorkoutToStudentWorkoutInsert workout_insert;
  AssignWorkoutToStudentData.fromJson(dynamic json)
    : workout_insert = AssignWorkoutToStudentWorkoutInsert.fromJson(
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

    final AssignWorkoutToStudentData otherTyped =
        other as AssignWorkoutToStudentData;
    return workout_insert == otherTyped.workout_insert;
  }

  @override
  int get hashCode => workout_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['workout_insert'] = workout_insert.toJson();
    return json;
  }

  const AssignWorkoutToStudentData({required this.workout_insert});
}

@immutable
class AssignWorkoutToStudentVariables {
  final String id;
  final String studentId;
  final String name;
  final Timestamp startedAt;
  final String coachId;
  final int source;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  AssignWorkoutToStudentVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']),
      studentId = nativeFromJson<String>(json['studentId']),
      name = nativeFromJson<String>(json['name']),
      startedAt = Timestamp.fromJson(json['startedAt']),
      coachId = nativeFromJson<String>(json['coachId']),
      source = nativeFromJson<int>(json['source']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final AssignWorkoutToStudentVariables otherTyped =
        other as AssignWorkoutToStudentVariables;
    return id == otherTyped.id &&
        studentId == otherTyped.studentId &&
        name == otherTyped.name &&
        startedAt == otherTyped.startedAt &&
        coachId == otherTyped.coachId &&
        source == otherTyped.source;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    studentId.hashCode,
    name.hashCode,
    startedAt.hashCode,
    coachId.hashCode,
    source.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['studentId'] = nativeToJson<String>(studentId);
    json['name'] = nativeToJson<String>(name);
    json['startedAt'] = startedAt.toJson();
    json['coachId'] = nativeToJson<String>(coachId);
    json['source'] = nativeToJson<int>(source);
    return json;
  }

  const AssignWorkoutToStudentVariables({
    required this.id,
    required this.studentId,
    required this.name,
    required this.startedAt,
    required this.coachId,
    required this.source,
  });
}

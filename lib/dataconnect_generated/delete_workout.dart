part of 'atlas.dart';

class DeleteWorkoutVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteWorkoutVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<DeleteWorkoutData> dataDeserializer = (dynamic json) =>
      DeleteWorkoutData.fromJson(jsonDecode(json));
  Serializer<DeleteWorkoutVariables> varsSerializer =
      (DeleteWorkoutVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteWorkoutData, DeleteWorkoutVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteWorkoutData, DeleteWorkoutVariables> ref() {
    DeleteWorkoutVariables vars = DeleteWorkoutVariables(id: id);
    return _dataConnect.mutation(
      "DeleteWorkout",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteWorkoutWorkoutDelete {
  final String id;
  DeleteWorkoutWorkoutDelete.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteWorkoutWorkoutDelete otherTyped =
        other as DeleteWorkoutWorkoutDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteWorkoutWorkoutDelete({required this.id});
}

@immutable
class DeleteWorkoutData {
  final DeleteWorkoutWorkoutDelete? workout_delete;
  DeleteWorkoutData.fromJson(dynamic json)
    : workout_delete = json['workout_delete'] == null
          ? null
          : DeleteWorkoutWorkoutDelete.fromJson(json['workout_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteWorkoutData otherTyped = other as DeleteWorkoutData;
    return workout_delete == otherTyped.workout_delete;
  }

  @override
  int get hashCode => workout_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (workout_delete != null) {
      json['workout_delete'] = workout_delete!.toJson();
    }
    return json;
  }

  const DeleteWorkoutData({this.workout_delete});
}

@immutable
class DeleteWorkoutVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteWorkoutVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteWorkoutVariables otherTyped = other as DeleteWorkoutVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteWorkoutVariables({required this.id});
}

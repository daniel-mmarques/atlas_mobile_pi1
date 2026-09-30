part of 'atlas.dart';

class CreateCoachLinkVariablesBuilder {
  String coachId;
  String studentId;

  final FirebaseDataConnect _dataConnect;
  CreateCoachLinkVariablesBuilder(
    this._dataConnect, {
    required this.coachId,
    required this.studentId,
  });
  Deserializer<CreateCoachLinkData> dataDeserializer = (dynamic json) =>
      CreateCoachLinkData.fromJson(jsonDecode(json));
  Serializer<CreateCoachLinkVariables> varsSerializer =
      (CreateCoachLinkVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateCoachLinkData, CreateCoachLinkVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<CreateCoachLinkData, CreateCoachLinkVariables> ref() {
    CreateCoachLinkVariables vars = CreateCoachLinkVariables(
      coachId: coachId,
      studentId: studentId,
    );
    return _dataConnect.mutation(
      "CreateCoachLink",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class CreateCoachLinkCoachLinkInsert {
  final String id;
  CreateCoachLinkCoachLinkInsert.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCoachLinkCoachLinkInsert otherTyped =
        other as CreateCoachLinkCoachLinkInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateCoachLinkCoachLinkInsert({required this.id});
}

@immutable
class CreateCoachLinkData {
  final CreateCoachLinkCoachLinkInsert coachLink_insert;
  CreateCoachLinkData.fromJson(dynamic json)
    : coachLink_insert = CreateCoachLinkCoachLinkInsert.fromJson(
        json['coachLink_insert'],
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCoachLinkData otherTyped = other as CreateCoachLinkData;
    return coachLink_insert == otherTyped.coachLink_insert;
  }

  @override
  int get hashCode => coachLink_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['coachLink_insert'] = coachLink_insert.toJson();
    return json;
  }

  const CreateCoachLinkData({required this.coachLink_insert});
}

@immutable
class CreateCoachLinkVariables {
  final String coachId;
  final String studentId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  CreateCoachLinkVariables.fromJson(Map<String, dynamic> json)
    : coachId = nativeFromJson<String>(json['coachId']),
      studentId = nativeFromJson<String>(json['studentId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCoachLinkVariables otherTyped =
        other as CreateCoachLinkVariables;
    return coachId == otherTyped.coachId && studentId == otherTyped.studentId;
  }

  @override
  int get hashCode => Object.hashAll([coachId.hashCode, studentId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['coachId'] = nativeToJson<String>(coachId);
    json['studentId'] = nativeToJson<String>(studentId);
    return json;
  }

  const CreateCoachLinkVariables({
    required this.coachId,
    required this.studentId,
  });
}

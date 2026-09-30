part of 'atlas.dart';

class ListCoachLinksByStudentVariablesBuilder {
  String studentId;

  final FirebaseDataConnect _dataConnect;
  ListCoachLinksByStudentVariablesBuilder(
    this._dataConnect, {
    required this.studentId,
  });
  Deserializer<ListCoachLinksByStudentData> dataDeserializer = (dynamic json) =>
      ListCoachLinksByStudentData.fromJson(jsonDecode(json));
  Serializer<ListCoachLinksByStudentVariables> varsSerializer =
      (ListCoachLinksByStudentVariables vars) => jsonEncode(vars.toJson());
  Future<
    QueryResult<ListCoachLinksByStudentData, ListCoachLinksByStudentVariables>
  >
  execute() {
    return ref().execute();
  }

  QueryRef<ListCoachLinksByStudentData, ListCoachLinksByStudentVariables>
  ref() {
    ListCoachLinksByStudentVariables vars = ListCoachLinksByStudentVariables(
      studentId: studentId,
    );
    return _dataConnect.query(
      "ListCoachLinksByStudent",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListCoachLinksByStudentCoachLinks {
  final String id;
  final String coachId;
  final String studentId;
  final String status;
  final Timestamp linkedAt;
  ListCoachLinksByStudentCoachLinks.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']),
      coachId = nativeFromJson<String>(json['coachId']),
      studentId = nativeFromJson<String>(json['studentId']),
      status = nativeFromJson<String>(json['status']),
      linkedAt = Timestamp.fromJson(json['linkedAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListCoachLinksByStudentCoachLinks otherTyped =
        other as ListCoachLinksByStudentCoachLinks;
    return id == otherTyped.id &&
        coachId == otherTyped.coachId &&
        studentId == otherTyped.studentId &&
        status == otherTyped.status &&
        linkedAt == otherTyped.linkedAt;
  }

  @override
  int get hashCode => Object.hashAll([
    id.hashCode,
    coachId.hashCode,
    studentId.hashCode,
    status.hashCode,
    linkedAt.hashCode,
  ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['coachId'] = nativeToJson<String>(coachId);
    json['studentId'] = nativeToJson<String>(studentId);
    json['status'] = nativeToJson<String>(status);
    json['linkedAt'] = linkedAt.toJson();
    return json;
  }

  const ListCoachLinksByStudentCoachLinks({
    required this.id,
    required this.coachId,
    required this.studentId,
    required this.status,
    required this.linkedAt,
  });
}

@immutable
class ListCoachLinksByStudentData {
  final List<ListCoachLinksByStudentCoachLinks> coachLinks;
  ListCoachLinksByStudentData.fromJson(dynamic json)
    : coachLinks = (json['coachLinks'] as List<dynamic>)
          .map((e) => ListCoachLinksByStudentCoachLinks.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListCoachLinksByStudentData otherTyped =
        other as ListCoachLinksByStudentData;
    return coachLinks == otherTyped.coachLinks;
  }

  @override
  int get hashCode => coachLinks.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['coachLinks'] = coachLinks.map((e) => e.toJson()).toList();
    return json;
  }

  const ListCoachLinksByStudentData({required this.coachLinks});
}

@immutable
class ListCoachLinksByStudentVariables {
  final String studentId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListCoachLinksByStudentVariables.fromJson(Map<String, dynamic> json)
    : studentId = nativeFromJson<String>(json['studentId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListCoachLinksByStudentVariables otherTyped =
        other as ListCoachLinksByStudentVariables;
    return studentId == otherTyped.studentId;
  }

  @override
  int get hashCode => studentId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['studentId'] = nativeToJson<String>(studentId);
    return json;
  }

  const ListCoachLinksByStudentVariables({required this.studentId});
}

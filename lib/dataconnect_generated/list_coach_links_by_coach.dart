part of 'atlas.dart';

class ListCoachLinksByCoachVariablesBuilder {
  String coachId;

  final FirebaseDataConnect _dataConnect;
  ListCoachLinksByCoachVariablesBuilder(
    this._dataConnect, {
    required this.coachId,
  });
  Deserializer<ListCoachLinksByCoachData> dataDeserializer = (dynamic json) =>
      ListCoachLinksByCoachData.fromJson(jsonDecode(json));
  Serializer<ListCoachLinksByCoachVariables> varsSerializer =
      (ListCoachLinksByCoachVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListCoachLinksByCoachData, ListCoachLinksByCoachVariables>>
  execute() {
    return ref().execute();
  }

  QueryRef<ListCoachLinksByCoachData, ListCoachLinksByCoachVariables> ref() {
    ListCoachLinksByCoachVariables vars = ListCoachLinksByCoachVariables(
      coachId: coachId,
    );
    return _dataConnect.query(
      "ListCoachLinksByCoach",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListCoachLinksByCoachCoachLinks {
  final String id;
  final String coachId;
  final String studentId;
  final String status;
  final Timestamp linkedAt;
  ListCoachLinksByCoachCoachLinks.fromJson(dynamic json)
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

    final ListCoachLinksByCoachCoachLinks otherTyped =
        other as ListCoachLinksByCoachCoachLinks;
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

  const ListCoachLinksByCoachCoachLinks({
    required this.id,
    required this.coachId,
    required this.studentId,
    required this.status,
    required this.linkedAt,
  });
}

@immutable
class ListCoachLinksByCoachData {
  final List<ListCoachLinksByCoachCoachLinks> coachLinks;
  ListCoachLinksByCoachData.fromJson(dynamic json)
    : coachLinks = (json['coachLinks'] as List<dynamic>)
          .map((e) => ListCoachLinksByCoachCoachLinks.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListCoachLinksByCoachData otherTyped =
        other as ListCoachLinksByCoachData;
    return coachLinks == otherTyped.coachLinks;
  }

  @override
  int get hashCode => coachLinks.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['coachLinks'] = coachLinks.map((e) => e.toJson()).toList();
    return json;
  }

  const ListCoachLinksByCoachData({required this.coachLinks});
}

@immutable
class ListCoachLinksByCoachVariables {
  final String coachId;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListCoachLinksByCoachVariables.fromJson(Map<String, dynamic> json)
    : coachId = nativeFromJson<String>(json['coachId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListCoachLinksByCoachVariables otherTyped =
        other as ListCoachLinksByCoachVariables;
    return coachId == otherTyped.coachId;
  }

  @override
  int get hashCode => coachId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['coachId'] = nativeToJson<String>(coachId);
    return json;
  }

  const ListCoachLinksByCoachVariables({required this.coachId});
}

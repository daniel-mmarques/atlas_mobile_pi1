part of 'atlas.dart';

class DeleteTemplateVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteTemplateVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<DeleteTemplateData> dataDeserializer = (dynamic json) =>
      DeleteTemplateData.fromJson(jsonDecode(json));
  Serializer<DeleteTemplateVariables> varsSerializer =
      (DeleteTemplateVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteTemplateData, DeleteTemplateVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<DeleteTemplateData, DeleteTemplateVariables> ref() {
    DeleteTemplateVariables vars = DeleteTemplateVariables(id: id);
    return _dataConnect.mutation(
      "DeleteTemplate",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class DeleteTemplateTemplateDelete {
  final String id;
  DeleteTemplateTemplateDelete.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteTemplateTemplateDelete otherTyped =
        other as DeleteTemplateTemplateDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteTemplateTemplateDelete({required this.id});
}

@immutable
class DeleteTemplateData {
  final DeleteTemplateTemplateDelete? template_delete;
  DeleteTemplateData.fromJson(dynamic json)
    : template_delete = json['template_delete'] == null
          ? null
          : DeleteTemplateTemplateDelete.fromJson(json['template_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteTemplateData otherTyped = other as DeleteTemplateData;
    return template_delete == otherTyped.template_delete;
  }

  @override
  int get hashCode => template_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (template_delete != null) {
      json['template_delete'] = template_delete!.toJson();
    }
    return json;
  }

  const DeleteTemplateData({this.template_delete});
}

@immutable
class DeleteTemplateVariables {
  final String id;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  DeleteTemplateVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteTemplateVariables otherTyped = other as DeleteTemplateVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteTemplateVariables({required this.id});
}

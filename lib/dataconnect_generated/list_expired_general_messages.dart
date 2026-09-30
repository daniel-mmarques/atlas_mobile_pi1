part of 'atlas.dart';

class ListExpiredGeneralMessagesVariablesBuilder {
  Timestamp cutoff;
  final Optional<int> _limit = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  ListExpiredGeneralMessagesVariablesBuilder limit(int? t) {
    _limit.value = t;
    return this;
  }

  ListExpiredGeneralMessagesVariablesBuilder(
    this._dataConnect, {
    required this.cutoff,
  });
  Deserializer<ListExpiredGeneralMessagesData> dataDeserializer =
      (dynamic json) =>
          ListExpiredGeneralMessagesData.fromJson(jsonDecode(json));
  Serializer<ListExpiredGeneralMessagesVariables> varsSerializer =
      (ListExpiredGeneralMessagesVariables vars) => jsonEncode(vars.toJson());
  Future<
    QueryResult<
      ListExpiredGeneralMessagesData,
      ListExpiredGeneralMessagesVariables
    >
  >
  execute() {
    return ref().execute();
  }

  QueryRef<ListExpiredGeneralMessagesData, ListExpiredGeneralMessagesVariables>
  ref() {
    ListExpiredGeneralMessagesVariables vars =
        ListExpiredGeneralMessagesVariables(cutoff: cutoff, limit: _limit);
    return _dataConnect.query(
      "ListExpiredGeneralMessages",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class ListExpiredGeneralMessagesMessages {
  final String id;
  ListExpiredGeneralMessagesMessages.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListExpiredGeneralMessagesMessages otherTyped =
        other as ListExpiredGeneralMessagesMessages;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const ListExpiredGeneralMessagesMessages({required this.id});
}

@immutable
class ListExpiredGeneralMessagesData {
  final List<ListExpiredGeneralMessagesMessages> messages;
  ListExpiredGeneralMessagesData.fromJson(dynamic json)
    : messages = (json['messages'] as List<dynamic>)
          .map((e) => ListExpiredGeneralMessagesMessages.fromJson(e))
          .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListExpiredGeneralMessagesData otherTyped =
        other as ListExpiredGeneralMessagesData;
    return messages == otherTyped.messages;
  }

  @override
  int get hashCode => messages.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['messages'] = messages.map((e) => e.toJson()).toList();
    return json;
  }

  const ListExpiredGeneralMessagesData({required this.messages});
}

@immutable
class ListExpiredGeneralMessagesVariables {
  final Timestamp cutoff;
  late final Optional<int> limit;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  ListExpiredGeneralMessagesVariables.fromJson(Map<String, dynamic> json)
    : cutoff = Timestamp.fromJson(json['cutoff']) {
    limit = Optional.optional(nativeFromJson, nativeToJson);
    limit.value = json['limit'] == null
        ? null
        : nativeFromJson<int>(json['limit']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListExpiredGeneralMessagesVariables otherTyped =
        other as ListExpiredGeneralMessagesVariables;
    return cutoff == otherTyped.cutoff && limit == otherTyped.limit;
  }

  @override
  int get hashCode => Object.hashAll([cutoff.hashCode, limit.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['cutoff'] = cutoff.toJson();
    if (limit.state == OptionalState.set) {
      json['limit'] = limit.toJson();
    }
    return json;
  }

  ListExpiredGeneralMessagesVariables({
    required this.cutoff,
    required this.limit,
  });
}

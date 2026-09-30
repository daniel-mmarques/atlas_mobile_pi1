part of 'atlas.dart';

class UpdateUserBannerVariablesBuilder {
  String id;
  final Optional<String> _bannerPreset = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );
  final Optional<String> _bannerUrl = Optional.optional(
    nativeFromJson,
    nativeToJson,
  );

  final FirebaseDataConnect _dataConnect;
  UpdateUserBannerVariablesBuilder bannerPreset(String? t) {
    _bannerPreset.value = t;
    return this;
  }

  UpdateUserBannerVariablesBuilder bannerUrl(String? t) {
    _bannerUrl.value = t;
    return this;
  }

  UpdateUserBannerVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<UpdateUserBannerData> dataDeserializer = (dynamic json) =>
      UpdateUserBannerData.fromJson(jsonDecode(json));
  Serializer<UpdateUserBannerVariables> varsSerializer =
      (UpdateUserBannerVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateUserBannerData, UpdateUserBannerVariables>>
  execute() {
    return ref().execute();
  }

  MutationRef<UpdateUserBannerData, UpdateUserBannerVariables> ref() {
    UpdateUserBannerVariables vars = UpdateUserBannerVariables(
      id: id,
      bannerPreset: _bannerPreset,
      bannerUrl: _bannerUrl,
    );
    return _dataConnect.mutation(
      "UpdateUserBanner",
      dataDeserializer,
      varsSerializer,
      vars,
    );
  }
}

@immutable
class UpdateUserBannerUserUpdate {
  final String id;
  UpdateUserBannerUserUpdate.fromJson(dynamic json)
    : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserBannerUserUpdate otherTyped =
        other as UpdateUserBannerUserUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdateUserBannerUserUpdate({required this.id});
}

@immutable
class UpdateUserBannerData {
  final UpdateUserBannerUserUpdate? user_update;
  UpdateUserBannerData.fromJson(dynamic json)
    : user_update = json['user_update'] == null
          ? null
          : UpdateUserBannerUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserBannerData otherTyped = other as UpdateUserBannerData;
    return user_update == otherTyped.user_update;
  }

  @override
  int get hashCode => user_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  const UpdateUserBannerData({this.user_update});
}

@immutable
class UpdateUserBannerVariables {
  final String id;
  late final Optional<String> bannerPreset;
  late final Optional<String> bannerUrl;
  @Deprecated(
    'fromJson is deprecated for Variable classes as they are no longer required for deserialization.',
  )
  UpdateUserBannerVariables.fromJson(Map<String, dynamic> json)
    : id = nativeFromJson<String>(json['id']) {
    bannerPreset = Optional.optional(nativeFromJson, nativeToJson);
    bannerPreset.value = json['bannerPreset'] == null
        ? null
        : nativeFromJson<String>(json['bannerPreset']);

    bannerUrl = Optional.optional(nativeFromJson, nativeToJson);
    bannerUrl.value = json['bannerUrl'] == null
        ? null
        : nativeFromJson<String>(json['bannerUrl']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserBannerVariables otherTyped =
        other as UpdateUserBannerVariables;
    return id == otherTyped.id &&
        bannerPreset == otherTyped.bannerPreset &&
        bannerUrl == otherTyped.bannerUrl;
  }

  @override
  int get hashCode =>
      Object.hashAll([id.hashCode, bannerPreset.hashCode, bannerUrl.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (bannerPreset.state == OptionalState.set) {
      json['bannerPreset'] = bannerPreset.toJson();
    }
    if (bannerUrl.state == OptionalState.set) {
      json['bannerUrl'] = bannerUrl.toJson();
    }
    return json;
  }

  UpdateUserBannerVariables({
    required this.id,
    required this.bannerPreset,
    required this.bannerUrl,
  });
}

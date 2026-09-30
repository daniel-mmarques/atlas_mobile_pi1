import 'package:atlas_mobile_pi1/core/dataconnect/dc_helpers.dart';
import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/dataconnect_generated/atlas.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/user_role.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/username.dart';
import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/widgets.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({AtlasConnector? connector})
      : _dc = connector ?? AtlasConnector.instance;

  final AtlasConnector _dc;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(const Locale('pt'));

  AppUser _mapUser({
    required String id,
    required String email,
    String? name,
    String? username,
    String? gender,
    double? height,
    double? weight,
    Timestamp? birthDate,
    String? activityLevel,
    required String role,
    required bool profileCompleted,
    String? bannerPreset,
    String? bannerUrl,
    String? photoUrl,
    Timestamp? createdAt,
  }) {
    return AppUser(
      id: id,
      email: email,
      name: name,
      username: username,
      gender: Gender.fromStorage(gender),
      height: height,
      weight: weight,
      birthDate: fromDcTimestamp(birthDate),
      activityLevel: ActivityLevel.fromStorage(activityLevel),
      role: UserRoleStorage.fromStorage(role),
      profileCompleted: profileCompleted,
      bannerPreset: bannerPreset,
      bannerUrl: (bannerUrl == null || bannerUrl.trim().isEmpty)
          ? null
          : bannerUrl,
      photoUrl: (photoUrl == null || photoUrl.trim().isEmpty) ? null : photoUrl,
      createdAt: fromDcTimestamp(createdAt),
    );
  }

  AppUser _fromGetUser(GetUserUser u) => _mapUser(
        id: u.id,
        email: u.email,
        name: u.name,
        username: u.username,
        gender: u.gender,
        height: u.height,
        weight: u.weight,
        birthDate: u.birthDate,
        activityLevel: u.activityLevel,
        role: u.role,
        profileCompleted: u.profileCompleted,
        bannerPreset: u.bannerPreset,
        bannerUrl: u.bannerUrl,
        photoUrl: u.photoUrl,
        createdAt: u.createdAt,
      );

  @override
  Future<void> createUserIfNotExists(
    String uid,
    String email, {
    String? name,
  }) async {
    final existing = await getUser(uid);
    if (existing == null) {
      final builder = _dc.upsertUser(id: uid, email: email);
      if (name != null && name.trim().isNotEmpty) {
        builder.name(name.trim()).nameLower(name.trim().toLowerCase());
      }
      builder.role(UserRole.student.storageName);
      await builder.execute();
      return;
    }

    if (name != null &&
        name.trim().isNotEmpty &&
        (existing.name == null || existing.name!.trim().isEmpty)) {
      await _dc
          .updateUserName(
            id: uid,
            name: name.trim(),
            nameLower: name.trim().toLowerCase(),
          )
          .execute();
    }
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    final result = await _dc.getUser(id: uid).execute();
    final user = result.data.user;
    if (user == null) return null;
    return _fromGetUser(user);
  }

  @override
  Stream<AppUser?> watchUser(String uid) {
    return subscribeMapped(
      () => _dc.getUser(id: uid).ref(),
      (GetUserData data) {
        final user = data.user;
        if (user == null) return null;
        return _fromGetUser(user);
      },
    );
  }

  @override
  Future<bool> isUsernameAvailable(
    String username, {
    String? excludeUid,
  }) async {
    final normalized = Username.normalize(username);
    if (normalized.isEmpty) return false;

    final result =
        await _dc.getUserByUsername(username: normalized).execute();
    final users = result.data.users;
    if (users.isEmpty) return true;
    return excludeUid != null && users.first.id == excludeUid;
  }

  @override
  Future<void> claimUsername({
    required String uid,
    required String username,
  }) async {
    final normalized = Username.normalize(username);
    final formatError = Username.validateFormat(normalized);
    if (formatError != null) {
      throw AuthException(formatError);
    }

    final current = await getUser(uid);
    if (current?.username != null &&
        current!.username!.isNotEmpty &&
        current.username != normalized) {
      throw AuthException(_l10n.authUsernameAlreadyOwned);
    }

    final available =
        await isUsernameAvailable(normalized, excludeUid: uid);
    if (!available) {
      throw AuthException(_l10n.validationUsernameTaken);
    }

    try {
      await _dc
          .claimUsername(
            id: uid,
            username: normalized,
          )
          .execute();
    } on DataConnectError {
      throw AuthException(_l10n.authUsernameReserveFailed);
    }
  }

  @override
  Future<void> completeProfile({
    required String uid,
    required String name,
    required String username,
    required DateTime birthDate,
    required Gender gender,
    required double height,
    required double weight,
    required ActivityLevel activityLevel,
  }) async {
    final normalized = Username.normalize(username);
    final formatError = Username.validateFormat(normalized);
    if (formatError != null) {
      throw AuthException(formatError);
    }

    final available =
        await isUsernameAvailable(normalized, excludeUid: uid);
    if (!available) {
      throw AuthException(_l10n.validationUsernameTaken);
    }

    try {
      await _dc
          .completeUserProfile(
            id: uid,
            name: name.trim(),
            nameLower: name.trim().toLowerCase(),
            username: normalized,
            birthDate: toDcTimestamp(birthDate),
            gender: gender.name,
            height: height,
            weight: weight,
            activityLevel: activityLevel.name,
          )
          .execute();
    } on DataConnectError {
      throw AuthException(_l10n.authUsernameReserveFailed);
    }
  }

  @override
  Future<void> updateRole(String uid, UserRole role) async {
    await _dc
        .updateUserRole(id: uid, role: role.storageName)
        .execute();
  }

  @override
  Future<void> updateBanner({
    required String uid,
    String? bannerPreset,
    String? bannerUrl,
    bool clearBannerUrl = false,
  }) async {
    final builder = _dc.updateUserBanner(id: uid);
    if (bannerPreset != null) {
      builder.bannerPreset(bannerPreset);
    }
    if (clearBannerUrl) {
      builder.bannerUrl('');
    } else if (bannerUrl != null) {
      builder.bannerUrl(bannerUrl);
    }
    await builder.execute();
  }

  @override
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String username,
    required DateTime birthDate,
    required Gender gender,
    required double height,
    required double weight,
    required ActivityLevel activityLevel,
    String? photoUrl,
  }) async {
    final normalized = Username.normalize(username);
    final formatError = Username.validateFormat(normalized);
    if (formatError != null) {
      throw AuthException(formatError);
    }

    final available =
        await isUsernameAvailable(normalized, excludeUid: uid);
    if (!available) {
      throw AuthException(_l10n.validationUsernameTaken);
    }

    try {
      final builder = _dc.updateUserProfile(
        id: uid,
        name: name.trim(),
        nameLower: name.trim().toLowerCase(),
        username: normalized,
        birthDate: toDcTimestamp(birthDate),
        gender: gender.name,
        height: height,
        weight: weight,
        activityLevel: activityLevel.name,
      );
      if (photoUrl != null) {
        builder.photoUrl(photoUrl);
      }
      await builder.execute();
    } on DataConnectError {
      throw AuthException(_l10n.authUsernameReserveFailed);
    }
  }
}

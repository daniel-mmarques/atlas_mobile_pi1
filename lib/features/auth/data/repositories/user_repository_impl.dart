import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/core/firestore/firestore_paths.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/user_role.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/username.dart';
import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  /// Temporary fallback until locale can be injected from PreferencesService.
  AppLocalizations get _l10n =>
      lookupAppLocalizations(const Locale('pt'));

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection(FirestorePaths.users);

  CollectionReference<Map<String, dynamic>> get _usernames =>
      _db.collection(FirestorePaths.usernames);

  @override
  Future<void> createUserIfNotExists(
    String uid,
    String email, {
    String? name,
  }) async {
    final doc = _users.doc(uid);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        'uid': uid,
        'email': email,
        'name': name,
        'nameLower': name?.trim().toLowerCase(),
        'username': null,
        'usernameLower': null,
        'gender': null,
        'height': null,
        'weight': null,
        'birthDate': null,
        'activityLevel': null,
        'role': UserRole.student.storageName,
        'profileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else if (name != null && name.trim().isNotEmpty) {
      final data = snapshot.data();
      final existingName = data?['name'] as String?;
      if (existingName == null || existingName.trim().isEmpty) {
        await doc.set(
          {
            'name': name.trim(),
            'nameLower': name.trim().toLowerCase(),
          },
          SetOptions(merge: true),
        );
      }
    }
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    final snapshot = await _users.doc(uid).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return AppUser.fromMap(uid, snapshot.data()!);
  }

  @override
  Stream<AppUser?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return AppUser.fromMap(uid, snapshot.data()!);
    });
  }

  @override
  Future<bool> isUsernameAvailable(
    String username, {
    String? excludeUid,
  }) async {
    final normalized = Username.normalize(username);
    if (normalized.isEmpty) return false;

    final snap = await _usernames.doc(normalized).get();
    if (!snap.exists) return true;
    final owner = snap.data()?['uid'] as String?;
    return excludeUid != null && owner == excludeUid;
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

    try {
      await _db.runTransaction((tx) async {
        final unameRef = _usernames.doc(normalized);
        final userRef = _users.doc(uid);
        final unameSnap = await tx.get(unameRef);
        final userSnap = await tx.get(userRef);

        final currentUsername = userSnap.data()?['username'] as String?;
        if (currentUsername != null &&
            currentUsername.isNotEmpty &&
            currentUsername != normalized) {
          throw AuthException(_l10n.authUsernameAlreadyOwned);
        }

        if (unameSnap.exists) {
          final owner = unameSnap.data()?['uid'] as String?;
          if (owner != uid) {
            throw AuthException(_l10n.validationUsernameTaken);
          }
        } else {
          tx.set(unameRef, {
            'uid': uid,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        tx.set(
          userRef,
          {
            'username': normalized,
            'usernameLower': normalized,
          },
          SetOptions(merge: true),
        );
      });
    } on AuthException {
      rethrow;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw AuthException(_l10n.authUsernameSaveFailed);
      }
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

    try {
      await _db.runTransaction((tx) async {
        final unameRef = _usernames.doc(normalized);
        final userRef = _users.doc(uid);
        final unameSnap = await tx.get(unameRef);

        if (unameSnap.exists) {
          final owner = unameSnap.data()?['uid'] as String?;
          if (owner != uid) {
            throw AuthException(_l10n.validationUsernameTaken);
          }
        } else {
          tx.set(unameRef, {
            'uid': uid,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        tx.set(
          userRef,
          {
            'uid': uid,
            'name': name.trim(),
            'nameLower': name.trim().toLowerCase(),
            'username': normalized,
            'usernameLower': normalized,
            'birthDate': Timestamp.fromDate(birthDate),
            'gender': gender.name,
            'height': height,
            'weight': weight,
            'activityLevel': activityLevel.name,
            'profileCompleted': true,
          },
          SetOptions(merge: true),
        );
      });
    } on AuthException {
      rethrow;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw AuthException(_l10n.authUsernameSaveFailed);
      }
      throw AuthException(_l10n.authUsernameReserveFailed);
    }
  }

  @override
  Future<void> updateRole(String uid, UserRole role) async {
    await _users.doc(uid).set(
      {'role': role.storageName},
      SetOptions(merge: true),
    );
  }
}

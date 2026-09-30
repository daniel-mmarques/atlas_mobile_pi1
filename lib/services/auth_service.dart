import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/data/datasources/local/preferences/repository_preferences.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/user_role.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService extends ChangeNotifier {
  AuthService({
    firebase_auth.FirebaseAuth? auth,
    required UserRepository usersRepository,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _usersRepository = usersRepository,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final firebase_auth.FirebaseAuth _auth;
  final UserRepository _usersRepository;
  final GoogleSignIn _googleSignIn;

  firebase_auth.User? user;
  AppUser? appUser;
  bool isLoading = true;
  bool pendingProfileSetup = false;
  bool _googleReady = false;

  StreamSubscription<firebase_auth.User?>? _authSub;
  StreamSubscription<AppUser?>? _userSub;

  bool get isLogged => user != null;
  bool get isProfileCompleted => appUser?.profileCompleted ?? false;
  bool get needsProfileSetup => pendingProfileSetup && !isProfileCompleted;
  bool get isCoach => appUser?.isCoach ?? false;

  bool get needsEmailVerification {
    final current = user;
    if (current == null || current.emailVerified) return false;
    return current.providerData.any((info) => info.providerId == 'password');
  }

  AuthService listen() {
    _authSub = _auth.authStateChanges().listen((newUser) async {
      user = newUser;
      await _watchAppUser(newUser?.uid);
      isLoading = false;
      notifyListeners();
    });
    unawaited(_ensureGoogleInitialized());
    return this;
  }

  Future<void> _ensureGoogleInitialized() async {
    if (_googleReady || kIsWeb) return;
    try {
      await _googleSignIn.initialize();
      _googleReady = true;
    } catch (_) {
      // Continua; tentamos initialize de novo no login.
    }
  }

  Future<void> _watchAppUser(String? uid) async {
    await _userSub?.cancel();
    if (uid == null) {
      appUser = null;
      return;
    }

    _userSub = _usersRepository.watchUser(uid).listen((profile) {
      appUser = profile;
      if (profile?.profileCompleted == true) {
        pendingProfileSetup = false;
      }
      notifyListeners();
    });
  }

  void _refreshCurrentUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> _ensureUserProfile({
    required firebase_auth.User firebaseUser,
    bool requireProfileSetupIfIncomplete = false,
    String? fallbackName,
  }) async {
    await _usersRepository.createUserIfNotExists(
      firebaseUser.uid,
      firebaseUser.email ?? '',
      name: fallbackName ?? firebaseUser.displayName,
    );

    if (requireProfileSetupIfIncomplete) {
      final profile = await _usersRepository.getUser(firebaseUser.uid);
      if (profile == null || !profile.profileCompleted) {
        pendingProfileSetup = true;
      } else {
        pendingProfileSetup = false;
      }
    }
  }

  Future<void> register(String email, String password) async {
    pendingProfileSetup = true;
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = cred.user;
      if (firebaseUser != null) {
        await _usersRepository.createUserIfNotExists(
          firebaseUser.uid,
          firebaseUser.email ?? email.trim(),
        );
        try {
          await firebaseUser.sendEmailVerification();
        } on firebase_auth.FirebaseAuthException {
          // Conta já criada; o usuário pode reenviar na tela de verificação.
        }
      }

      _refreshCurrentUser();
    } on firebase_auth.FirebaseAuthException catch (e) {
      pendingProfileSetup = false;
      throw _mapAuthError(e);
    } catch (_) {
      pendingProfileSetup = false;
      throw AuthException(_l10n.authGenericError);
    }
  }

  Future<void> login(String email, String password) async {
    pendingProfileSetup = false;
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = cred.user;
      if (firebaseUser != null) {
        await _usersRepository.createUserIfNotExists(
          firebaseUser.uid,
          firebaseUser.email ?? email.trim(),
        );
      }

      _refreshCurrentUser();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    } catch (_) {
      throw AuthException(_l10n.authGenericError);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await _ensureGoogleInitialized();
      if (!_googleReady && !kIsWeb) {
        await _googleSignIn.initialize();
        _googleReady = true;
      }

      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw AuthException(_l10n.authGoogleFailed);
      }

      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw AuthException(_l10n.authGoogleFailed);
      }

      await _ensureUserProfile(
        firebaseUser: firebaseUser,
        requireProfileSetupIfIncomplete: true,
        fallbackName: googleUser.displayName,
      );
      _refreshCurrentUser();
    } on AuthException {
      rethrow;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return;
      }
      throw AuthException(_l10n.authGoogleCancelled);
    } catch (_) {
      throw AuthException(_l10n.authGoogleFailed);
    }
  }

  Future<void> loginWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final idToken = appleCredential.identityToken;
      if (idToken == null) {
        throw AuthException(_l10n.authAppleTokenFailed);
      }

      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: idToken,
        rawNonce: rawNonce,
      );

      final cred = await _auth.signInWithCredential(oauthCredential);
      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw AuthException(_l10n.authAppleFailed);
      }

      final fullName = [
        appleCredential.givenName,
        appleCredential.familyName,
      ].whereType<String>().where((p) => p.trim().isNotEmpty).join(' ');

      await _ensureUserProfile(
        firebaseUser: firebaseUser,
        requireProfileSetupIfIncomplete: true,
        fallbackName: fullName.isEmpty ? null : fullName,
      );
      _refreshCurrentUser();
    } on AuthException {
      rethrow;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return;
      }
      throw AuthException(_l10n.authAppleUnavailable);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    } catch (_) {
      throw AuthException(
        'Não foi possível entrar com Apple. Ative o provedor no Firebase e a capability no iOS.',
      );
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    } catch (_) {
      throw AuthException(_l10n.authGenericError);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final current = _auth.currentUser;
      if (current == null) {
        throw AuthException(_l10n.authGenericError);
      }
      await current.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    } catch (_) {
      throw AuthException(_l10n.authGenericError);
    }
  }

  Future<void> reloadCurrentUser() async {
    try {
      await _auth.currentUser?.reload();
      _refreshCurrentUser();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    } catch (_) {
      throw AuthException(_l10n.authGenericError);
    }
  }

  Future<void> logout() async {
    pendingProfileSetup = false;
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
    appUser = null;
    _refreshCurrentUser();
  }

  Future<void> setRole(UserRole role) async {
    final uid = user?.uid;
    if (uid == null) return;
    await _usersRepository.updateRole(uid, role);
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  AppLocalizations get _l10n =>
      lookupAppLocalizations(PreferencesRepository.instance.getUserLanguage());

  AuthException _mapAuthError(firebase_auth.FirebaseAuthException e) {
    final l10n = _l10n;
    switch (e.code) {
      case 'weak-password':
        return AuthException(l10n.authWeakPassword);
      case 'email-already-in-use':
        return AuthException(l10n.authEmailInUse);
      case 'user-not-found':
        return AuthException(l10n.authUserNotFound);
      case 'wrong-password':
        return AuthException(l10n.authWrongPassword);
      case 'invalid-credential':
        return AuthException(l10n.authInvalidCredential);
      case 'invalid-email':
        return AuthException(l10n.authInvalidEmail);
      case 'user-disabled':
        return AuthException(l10n.authUserDisabled);
      case 'too-many-requests':
        return AuthException(l10n.authTooManyRequests);
      case 'network-request-failed':
        return AuthException(l10n.authNetworkFailed);
      case 'account-exists-with-different-credential':
        return AuthException(l10n.authAccountExistsDifferent);
      default:
        return AuthException(l10n.authGenericError);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _userSub?.cancel();
    super.dispose();
  }
}

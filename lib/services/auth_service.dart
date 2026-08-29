import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/user_role.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
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

  Future<void> _ensureFirestoreProfile({
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
      }

      _refreshCurrentUser();
    } on firebase_auth.FirebaseAuthException catch (e) {
      pendingProfileSetup = false;
      throw _mapAuthError(e);
    } catch (_) {
      pendingProfileSetup = false;
      throw AuthException(
        'Não foi possível concluir o cadastro. Tente novamente.',
      );
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
      throw AuthException(
        'Não foi possível fazer login. Verifique sua conexão e tente novamente.',
      );
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
        throw AuthException(
          'Não foi possível obter credenciais do Google. Verifique o SHA-1 no Firebase.',
        );
      }

      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw AuthException('Falha no login com Google.');
      }

      await _ensureFirestoreProfile(
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
      throw AuthException('Login com Google cancelado ou indisponível.');
    } catch (_) {
      throw AuthException(
        'Não foi possível entrar com Google. Ative o provedor no Firebase e confira o SHA-1.',
      );
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
        throw AuthException('Não foi possível obter o token da Apple.');
      }

      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: idToken,
        rawNonce: rawNonce,
      );

      final cred = await _auth.signInWithCredential(oauthCredential);
      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw AuthException('Falha no login com Apple.');
      }

      final fullName = [
        appleCredential.givenName,
        appleCredential.familyName,
      ].whereType<String>().where((p) => p.trim().isNotEmpty).join(' ');

      await _ensureFirestoreProfile(
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
      throw AuthException('Login com Apple indisponível neste dispositivo.');
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthError(e);
    } catch (_) {
      throw AuthException(
        'Não foi possível entrar com Apple. Ative o provedor no Firebase e a capability no iOS.',
      );
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

  AuthException _mapAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return AuthException('A senha é muito fraca!');
      case 'email-already-in-use':
        return AuthException('Este email já está cadastrado');
      case 'user-not-found':
        return AuthException('Email não encontrado. Cadastre-se.');
      case 'wrong-password':
        return AuthException('Senha incorreta. Tente novamente');
      case 'invalid-credential':
        return AuthException('Email ou senha incorretos.');
      case 'invalid-email':
        return AuthException('Email inválido');
      case 'user-disabled':
        return AuthException('Esta conta foi desabilitada.');
      case 'too-many-requests':
        return AuthException('Muitas tentativas. Tente mais tarde.');
      case 'network-request-failed':
        return AuthException(
          'Sem conexão com a internet. Verifique sua rede e tente novamente.',
        );
      case 'account-exists-with-different-credential':
        return AuthException(
          'Já existe uma conta com este email usando outro método de login.',
        );
      default:
        return AuthException('Erro de autenticação. Tente novamente.');
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _userSub?.cancel();
    super.dispose();
  }
}

import 'dart:async';

import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  AuthService({
    firebase_auth.FirebaseAuth? auth,
    required UserRepository usersRepository,
  })  : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _usersRepository = usersRepository;

  final firebase_auth.FirebaseAuth _auth;
  final UserRepository _usersRepository;

  firebase_auth.User? user;
  AppUser? appUser;
  bool isLoading = true;

  StreamSubscription<firebase_auth.User?>? _authSub;
  StreamSubscription<AppUser?>? _userSub;

  bool get isLogged => user != null;
  bool get isProfileCompleted => appUser?.profileCompleted ?? false;

  AuthService listen() {
    _authSub = _auth.authStateChanges().listen((newUser) async {
      user = newUser;
      await _watchAppUser(newUser?.uid);
      isLoading = false;
      notifyListeners();
    });
    return this;
  }

  Future<void> _watchAppUser(String? uid) async {
    await _userSub?.cancel();
    if (uid == null) {
      appUser = null;
      return;
    }

    _userSub = _usersRepository.watchUser(uid).listen((profile) {
      appUser = profile;
      notifyListeners();
    });
  }

  void _refreshCurrentUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
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
      throw _mapAuthError(e);
    } catch (_) {
      throw AuthException(
        'Não foi possível concluir o cadastro. Tente novamente.',
      );
    }
  }

  Future<void> login(String email, String password) async {
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

  Future<void> logout() async {
    await _auth.signOut();
    appUser = null;
    _refreshCurrentUser();
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

import 'package:atlas_mobile_pi1/app.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_router.dart';
import 'package:atlas_mobile_pi1/features/auth/data/repositories/user_repository_impl.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/firebase_options.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final UserRepository usersRepository = UserRepositoryImpl();
  final authService = AuthService(usersRepository: usersRepository).listen();
  final router = createAppRouter(
    authService: authService,
    usersRepository: usersRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: usersRepository),
        ChangeNotifierProvider<AuthService>.value(value: authService),
      ],
      child: AtlasApp(router: router),
    ),
  );
}

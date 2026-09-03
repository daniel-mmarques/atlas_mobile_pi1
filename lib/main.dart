import 'package:atlas_mobile_pi1/core/navigation/app_router.dart';
import 'package:atlas_mobile_pi1/data/datasources/local/preferences/repository_preferences.dart';
import 'package:atlas_mobile_pi1/features/auth/data/repositories/user_repository_impl.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/coach/data/coach_repository.dart';
import 'package:atlas_mobile_pi1/features/messages/data/conversations_repository.dart';
import 'package:atlas_mobile_pi1/features/feed/data/posts_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/templates_repository.dart';
import 'package:atlas_mobile_pi1/features/workouts/data/workouts_repository.dart';
import 'package:atlas_mobile_pi1/firebase_options.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/services/preferences_service.dart';
import 'package:atlas_mobile_pi1/services/workout_service.dart';
import 'package:atlas_mobile_pi1/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PreferencesRepository.init();

  final UserRepository usersRepository = UserRepositoryImpl();
  final workoutsRepository = WorkoutsRepositoryImpl();
  final templatesRepository = TemplatesRepositoryImpl();
  final postsRepository = PostsRepositoryImpl();
  final conversationsRepository = ConversationsRepositoryImpl();
  final coachRepository = CoachRepositoryImpl();
  final workoutService = WorkoutService(workoutsRepository);
  final preferencesService = PreferencesService(PreferencesRepository.instance);

  final authService = AuthService(usersRepository: usersRepository).listen();
  final router = createAppRouter(
    authService: authService,
    usersRepository: usersRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: usersRepository),
        Provider<WorkoutsRepository>.value(value: workoutsRepository),
        Provider<TemplatesRepository>.value(value: templatesRepository),
        Provider<PostsRepository>.value(value: postsRepository),
        Provider<ConversationsRepository>.value(value: conversationsRepository),
        Provider<CoachRepository>.value(value: coachRepository),
        Provider<WorkoutService>.value(value: workoutService),
        ChangeNotifierProvider<PreferencesService>.value(
          value: preferencesService,
        ),
        ChangeNotifierProvider<AuthService>.value(value: authService),
      ],
      child: AtlasApp(router: router),
    ),
  );
}

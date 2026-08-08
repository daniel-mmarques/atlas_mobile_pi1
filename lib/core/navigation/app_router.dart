import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/pages/home_page.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/pages/onboarding_page.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/pages/sign_in_page.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/pages/sign_up_page.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter({
  required AuthService authService,
  required UserRepository usersRepository,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: authService,
    redirect: (context, state) {
      final isLoading = authService.isLoading;
      final isLogged = authService.isLogged;
      final profileCompleted = authService.isProfileCompleted;
      final location = state.matchedLocation;

      if (isLoading) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isPublicAuthRoute =
          location == AppRoutes.onboarding || location == AppRoutes.login;

      if (!isLogged) {
        return isPublicAuthRoute ? null : AppRoutes.onboarding;
      }

      // Logged in but profile incomplete → stay on / force signup.
      if (!profileCompleted) {
        return location == AppRoutes.signup ? null : AppRoutes.signup;
      }

      if (isPublicAuthRoute ||
          location == AppRoutes.signup ||
          location == AppRoutes.splash) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (_, _) {
          final uid = authService.user?.uid;
          if (uid == null) {
            return const SignInPage();
          }
          return SignUpPage(
            uid: uid,
            usersRepository: usersRepository,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, _) => const HomePage(),
      ),
    ],
  );
}

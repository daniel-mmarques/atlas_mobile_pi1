import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/pages/onboarding_page.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/pages/sign_in_page.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/pages/sign_up_page.dart';
import 'package:atlas_mobile_pi1/features/calendar/presentation/pages/calendar_history_page.dart';
import 'package:atlas_mobile_pi1/features/coach/presentation/pages/coach_dashboard_page.dart';
import 'package:atlas_mobile_pi1/features/coach/presentation/pages/student_detail_page.dart';
import 'package:atlas_mobile_pi1/features/feed/presentation/pages/feed_page.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/pages/home_page.dart';
import 'package:atlas_mobile_pi1/features/messages/presentation/pages/chat_room_page.dart';
import 'package:atlas_mobile_pi1/features/messages/presentation/pages/messages_page.dart';
import 'package:atlas_mobile_pi1/features/messages/presentation/pages/messages_scan_page.dart';
import 'package:atlas_mobile_pi1/features/messages/presentation/pages/messages_search_page.dart';
import 'package:atlas_mobile_pi1/features/messages/presentation/pages/new_community_page.dart';
import 'package:atlas_mobile_pi1/features/profile/presentation/pages/share_profile_page.dart';
import 'package:atlas_mobile_pi1/features/workouts/domain/entities/workout.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/pages/transition_page.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/pages/workout_details_page.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/pages/workout_page.dart';
import 'package:atlas_mobile_pi1/features/workouts/presentation/pages/workout_session_page.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/pages/navigation_page.dart';
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
      final needsProfileSetup = authService.needsProfileSetup;
      final location = state.matchedLocation;

      if (isLoading) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isPublicAuthRoute = location == AppRoutes.onboarding;

      if (!isLogged) {
        return isPublicAuthRoute ? null : AppRoutes.onboarding;
      }

      if (needsProfileSetup) {
        return location == AppRoutes.signup ? null : AppRoutes.signup;
      }

      if (isPublicAuthRoute ||
          location == AppRoutes.signup ||
          location == AppRoutes.splash) {
        return AppRoutes.home;
      }

      if (location.startsWith('/coach') && !authService.isCoach) {
        // Scan pode ser usado por aluno para aceitar convite.
        if (location == AppRoutes.coachScan) return null;
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavigationPage(shell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.calendar,
                builder: (_, _) => const CalendarHistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workouts,
                builder: (_, _) => const WorkoutPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.feed,
                builder: (_, _) => const FeedPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.messages,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const MessagesPage(),
      ),
      GoRoute(
        path: AppRoutes.messagesSearch,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const MessagesSearchPage(),
      ),
      GoRoute(
        path: AppRoutes.messagesNewCommunity,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const NewCommunityPage(),
      ),
      GoRoute(
        path: AppRoutes.messagesScan,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const MessagesScanPage(),
      ),
      GoRoute(
        path: '/messages/chat/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return ChatRoomPage(conversationId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.profileShare,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const ShareProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.coach,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const CoachDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.coachLink,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const CoachLinkPage(),
      ),
      GoRoute(
        path: AppRoutes.coachScan,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const MessagesScanPage(),
      ),
      GoRoute(
        path: '/coach/student/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          final student = state.extra as AppUser?;
          if (student == null) {
            return const Scaffold(
              body: Center(child: Text('Aluno não encontrado')),
            );
          }
          return StudentDetailPage(student: student);
        },
      ),
      GoRoute(
        path: '/workout/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final workout = state.extra as Workout?;
          if (workout == null) {
            return Scaffold(
              body: Center(child: Text(context.l10n.workoutsNotFound)),
            );
          }
          return WorkoutDetailsPage(workout: workout);
        },
      ),
      GoRoute(
        path: '/workout/:id/session',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final workout = state.extra as Workout?;
          if (workout == null) {
            return Scaffold(
              body: Center(child: Text(context.l10n.workoutsNotFound)),
            );
          }
          return WorkoutSessionPage(workout: workout);
        },
      ),
      GoRoute(
        path: '/workout/:id/transition',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final workout = state.extra as Workout?;
          if (workout == null) {
            return Scaffold(
              body: Center(child: Text(context.l10n.workoutsNotFound)),
            );
          }
          return TransitionPage(workout: workout);
        },
      ),
    ],
  );
}

abstract class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const calendar = '/calendar';
  static const workouts = '/workouts';
  static const feed = '/feed';
  static const messages = '/messages';
  static const messagesSearch = '/messages/search';
  static const messagesNewCommunity = '/messages/new-community';
  static const messagesScan = '/messages/scan';
  static const profile = '/profile';
  static const settings = '/settings';
  static const exerciseSearch = '/exercise/search';
  static const routineNew = '/routine/new';
  static const profileShare = '/profile/share';
  static const coach = '/coach';
  static const coachLink = '/coach/link';
  static const coachScan = '/coach/scan';

  static String coachStudent(String id) => '/coach/student/$id';
  static String workoutDetails(String id) => '/workout/$id';
  static String workoutSession(String id) => '/workout/$id/session';
  static String workoutTransition(String id) => '/workout/$id/transition';
  static String exerciseDetails(String id) => '/exercise/$id';
  static String messagesChat(String id) => '/messages/chat/$id';
}

import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/auth/presentation/login/screens/login_screen.dart';
import 'package:durbar_physics/features/auth/presentation/signup/screens/sign_up_screen.dart';
import 'package:durbar_physics/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:durbar_physics/features/home/presentation/screens/home_screen.dart';
import 'package:durbar_physics/features/home/presentation/screens/saved_screen.dart';
import 'package:durbar_physics/features/live_classes/presentation/screens/live_classes_list_screen.dart';
import 'package:durbar_physics/features/live_classes/presentation/screens/zoom_web_view_screen.dart';
import 'package:durbar_physics/features/on_boarding/presentation/screens/on_boarding_screen.dart';
import 'package:durbar_physics/features/profile/profile_screen.dart';
import 'package:durbar_physics/features/settings/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: NavigationService.navigationKey,
  initialLocation: Hive.box('authBox').get('accessToken') != null
      ? RoutePath.home
      : RoutePath.login,
  routes: [
    GoRoute(
      path: RoutePath.onBoarding,
      name: RouteName.onBoarding,
      builder: (context, state) => OnBoardingScreen(),
    ),

    GoRoute(
      path: RoutePath.signUp,
      name: RouteName.signUp,
      builder: (context, index) => SignUpScreen(),
    ),

    GoRoute(
      path: RoutePath.login,
      name: RouteName.login,
      builder: (context, index) => LoginScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.home,
              name: RouteName.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.saved,
              name: RouteName.saved,
              builder: (context, state) => const SavedScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.play,
              name: RouteName.play,
              builder: (context, state) =>
                  const LiveClassesListScreen(), // Placeholder
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.setting,
              name: RouteName.setting,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RoutePath.profile,
      name: RouteName.profile,
      builder: (context, state) => const ProfileScreen(),
    ),

    GoRoute(
      path: RoutePath.liveClassesList,
      name: RouteName.liveClassesList,
      builder: (context, state) => const LiveClassesListScreen(),
    ),
    GoRoute(
      path: RoutePath.zoomWebView,
      name: RouteName.zoomWebView,
      builder: (context, state) => const ZoomWebViewScreen(
        url:
            'https://us04web.zoom.us/j/3117772972?pwd=oQOKC681rjGaeyA8ZiixJe8T2sW9pN.1',
      ),
    ),
  ],
);

import 'package:dubar_physics/core/routing/navigation_service.dart';
import 'package:dubar_physics/core/routing/route_name.dart';
import 'package:dubar_physics/features/auth/presentation/login/screens/login_screen.dart';
import 'package:dubar_physics/features/auth/presentation/signUp/screens/sign_up_screen.dart';
import 'package:dubar_physics/features/on_boarding/presentation/screens/on_boarding_screen.dart';

import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: NavigationService.navigationKey,
  // initialLocation: Hive.box('authBox').get('isLoggedIn', defaultValue: false)
  //     ? RoutePath.newsPage
  //     : RoutePath.login,
  initialLocation: RoutePath.onBoarding,
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
  ],
);

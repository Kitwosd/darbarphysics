import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigationKey =
      GlobalKey<NavigatorState>();
  static void pushNamed(String routeName, {Object? extra}) {
    navigationKey.currentContext?.pushNamed(routeName, extra: extra);
  }

  static void pushNamedReplacement(String routeName, {Object? extra}) {
    navigationKey.currentContext?.pushReplacementNamed(routeName, extra: extra);
  }

  static void goNamed(String routeName, {Object? extra}) {
    navigationKey.currentContext?.goNamed(routeName, extra: extra);
  }

  static void pop() {
    navigationKey.currentContext?.pop();
  }
}

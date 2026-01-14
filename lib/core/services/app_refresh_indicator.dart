import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final bool isEnabled;
  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) {
      return child;
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: appColors.primary,
      child: child,
    );
  }
}

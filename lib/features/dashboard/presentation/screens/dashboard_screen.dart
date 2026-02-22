import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar:
          MediaQuery.of(context).orientation == Orientation.landscape
          ? null
          : Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withValues(alpha: .1),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 8.h,
                  ),
                  child: GNav(
                    rippleColor: appColors.primary,
                    // Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8.w,
                    activeColor: Colors.blueAccent, // Or your primary color
                    iconSize: 24.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.blueAccent.withValues(
                      alpha: 0.1,
                    ),
                    color: Theme.of(context).colorScheme.onSurface,
                    tabs: const [
                      GButton(icon: Icons.home_rounded, text: 'Home'),
                      GButton(
                        icon: Icons.bookmark_border_rounded,
                        text: 'Saved',
                      ),
                      GButton(
                        icon: Icons.play_circle_outline_rounded,
                        text: 'Enrolled',
                      ),
                      GButton(icon: Icons.settings, text: 'Setting'),
                    ],
                    selectedIndex: navigationShell.currentIndex,
                    onTabChange: (index) {
                      navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}

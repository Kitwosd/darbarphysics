import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/user_avatar_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/hive_services/services/hive_course_service.dart';
import 'package:durbar_physics/core/hive_services/services/hive_video_service.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/theme/theme_extension.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_bloc.dart'; // ADDED: import for course bookmark bloc
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/videos_bookmark/videos_bookmark_bloc.dart'; // ADDED: import for video bookmark bloc
import 'package:durbar_physics/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:durbar_physics/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: TextWidget(
            word: "Settings",
            weight: FontWeight.bold,
            size: 24,
            textColor:
                Theme.of(context).appBarTheme.titleTextStyle?.color ??
                Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              context.toggleTheme();
            },
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                context.isDark ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ApiDataStatus.success &&
              state.error.isEmpty &&
              !state.justUpdated) {
            // This is likely after a successful delete account call
            // We need to double check if we really want to logout here
            // But since getProfile also sets success, we need to be careful.
            // However, after deleteAccount, we set status success and justUpdated false.
            // Let's assume for now.
          }
          if (state.status == ApiDataStatus.error && state.error.isNotEmpty) {
            OverlayToastWidget.show(
              message: state.error,
              bgColor: Colors.red.shade400,
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Avatar
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(
                            0xFFFFF3CA,
                          ), // Light yellow bg from image
                          shape: BoxShape.circle,
                        ),
                        child: BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            if (state.profile != null) {
                              final profile = state.profile!;
                              return UserAvatarWidget(
                                name: profile.username,
                                imageUrl: profile.profilePicture,

                                radius: 60,
                              );
                            }
                            return const CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg',
                              ), // Placeholder 3D avatar
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                20.verticalSpace,

                // Menu Items
                _buildSettingItem(
                  context,
                  Icons.person,
                  'View Profile',
                  () => NavigationService.pushNamed(RouteName.profile),
                ),

                _buildSettingItemWithToggle(
                  context,
                  Icons.dark_mode,
                  'Dark Mode',
                ),
                _buildSettingItem(
                  context,
                  Icons.grid_view,
                  'Reset Password',
                  () => NavigationService.pushNamed(RouteName.resetPassword),
                ),
                _buildSettingItem(
                  context,
                  Icons.policy_outlined,
                  'Privacy Policy',
                  () => NavigationService.pushNamed(RouteName.privacyPolicy),
                ),
                _buildSettingItem(
                  context,
                  Icons.person_remove_outlined,
                  'Delete Account',
                  () => _showDeleteAccountDialog(context),
                ),
                _buildSettingItem(
                  context,
                  Icons.analytics,
                  'Terms & Conditions',
                  () =>
                      NavigationService.pushNamed(RouteName.termsAndConditions),
                ),
                // _buildSettingItem(
                //   context,
                //   Icons.headset_mic,
                //   'Help Center',
                //   null,
                // ),
                // _buildSettingItem(context, Icons.send, 'Invite Friends', null),
                _buildSettingItem(context, Icons.logout, 'Logout', () async {
                  logger.d('Button Pressed');
                  await _handleLogout(context);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _darkModeToggle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // color: color.withOpacity(0.1), // Optional: if we want colored bg for icon
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.dark_mode, size: 28),
          ),
          const SizedBox(width: 16),
          Text(
            'Dark Mode',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          CupertinoSwitch(value: true, onChanged: (value) {}),
        ],
      ),
    );
  }

  Widget _buildSettingItemWithToggle(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          CupertinoSwitch(
            value: context.isDark,
            onChanged: (value) {
              context.toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action is irreversible and all your data will be permanently deleted.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await context.read<ProfileCubit>().deleteAccount();
              if (context.mounted) {
                await _handleLogout(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authBox = Hive.box('authBox');
    await authBox.delete('accessToken');
    await authBox.delete('refreshToken');

    ApiClient().clearAccessToken();

    final hiveCourseService = getIt<HiveCourseService>();
    final hiveVideoService = getIt<HiveVideoService>();

    await hiveCourseService.clearAll();
    await hiveVideoService.clearAll();

    // Dispatch clear events to reset BLoC state
    if (context.mounted) {
      context.read<CourseBookmarkBloc>().add(ClearAllCoursesBookmarkEvent());
      context.read<VideosBookmarkBloc>().add(ClearAllVideosBookmarkEvent());
      NavigationService.pushNamedReplacement(RouteName.login);
    }
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback? navigateTo,
  ) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // color: color.withOpacity(0.1), // Optional: if we want colored bg for icon
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 28),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_sharp, size: 16.h),
          ],
        ),
      ),
      onTap: () {
        if (navigateTo != null) {
          return navigateTo();
        }
      },
    );
  }
}

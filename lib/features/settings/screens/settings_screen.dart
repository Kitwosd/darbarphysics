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
import 'package:durbar_physics/features/practise/basic_webview_screen.dart';
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
      body: SingleChildScrollView(
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
                        color: Color(0xFFFFF3CA), // Light yellow bg from image
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
                'Edit Profile',
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
                null,
              ),
              _buildSettingItem(
                context,
                Icons.analytics,
                'Terms & Conditions',
                null,
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
                final authBox = Hive.box('authBox');
                await authBox.delete('accessToken');
                await authBox.delete('refreshToken');

                ApiClient().clearAccessToken();

                final hiveCourseService = getIt<HiveCourseService>();
                final hiveVideoService = getIt<HiveVideoService>();

                await hiveCourseService.clearAll();
                await hiveVideoService.clearAll();

                NavigationService.pushNamedReplacement(RouteName.login);
              }),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback?
    navigateTo, //TODO: Just for remembering void Function()? navigateTo = VoidCallback()
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


import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/user_avatar_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:durbar_physics/features/profile/presentation/cubit/profile_state.dart';
import 'package:durbar_physics/features/profile/presentation/widget/profile_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getAcademicLevels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ApiDataStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ApiDataStatus.error) {
            return Center(
              child: Text(state.error, style: TextStyle(color: Colors.white)),
            );
          } else if (state.profile != null) {
            final profile = state.profile!;

            //convert academic level id to real name

            String academicLevelDisplay = 'Not provided';

            if (profile.academicLevel != null) {
              // user helper method to get name from the id
              final academicName = state.getAcademicNameById(
                profile.academicLevel,
              );
              academicLevelDisplay = academicName ?? 'Unknown Grade';
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: 300.h,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                    Column(
                      children: [
                        50.verticalSpace,
                        // Header with title
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        30.verticalSpace,

                        // White container with rounded top corners
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32.r),
                            // borderRadius: BorderRadius.only(

                            //   topLeft: Radius.circular(30.r),
                            //   topRight: Radius.circular(30.r),
                            // ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              50.verticalSpace,
                              // Name
                              Text(
                                profile.username,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              // Email
                              Text(
                                profile.email,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                ),
                              ),

                              24.verticalSpace,

                              // Profile information list
                              Column(
                                children: [
                                  ProfileListTileWidget(
                                    icon: Icons.phone_outlined,
                                    title: 'Phone Number',
                                    subTitle: profile.phone,
                                    onTap: () {},
                                  ),
                                  ProfileListTileWidget(
                                    icon: Icons.school_outlined,
                                    title: 'Academic Level',
                                    subTitle: academicLevelDisplay,
                                    onTap: () {},
                                  ),
                                  if (profile.role != null)
                                    ProfileListTileWidget(
                                      icon: Icons.workspace_premium_outlined,
                                      title: 'Role',
                                      subTitle: profile.role ?? '-',
                                      onTap: () {},
                                    ),
                                  ProfileListTileWidget(
                                    icon: Icons.info_outline,
                                    title: 'Bio',
                                    subTitle: profile.bio ?? 'No bio available',
                                    onTap: () {},
                                  ),
                                ],
                              ),

                              20.verticalSpace,
                              // Save button at bottom
                              Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Row(
                                  children: [
                                    // Back button
                                    Container(
                                      height: 50.h,
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.arrow_back),
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    // Save button
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          NavigationService.pushNamed(
                                            RouteName.editProfile,
                                            extra: profile,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15.h,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          'EDIT PROFILE',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 150.w,
                      top: 70.h,
                      child: UserAvatarWidget(
                        imageUrl: profile.profilePicture,
                        name: profile.username,
                        radius: 70.r,
                        fontSize: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

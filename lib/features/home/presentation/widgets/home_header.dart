import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/user_avatar_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:durbar_physics/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SizedBox(
              width: 32.w,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo_with_name.png', // TODO: crop the image as there is invisible padding around it.
                    color: Color(0xFF1877F2),
                    colorBlendMode: BlendMode.srcATop,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              TextWidget(
                word: 'Hi, Dev Subedi',
                size: 16.sp,
                weight: FontWeight.bold,
                textColor: Theme.of(context).textTheme.titleLarge?.color,
              ),
              SizedBox(width: 5.w),
              Text('👋', style: TextStyle(fontSize: 16.sp)),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.profile != null) {
                  return InkWell(
                    onTap: () => NavigationService.pushNamed(RouteName.profile),
                    child: UserAvatarWidget(
                      imageUrl: state.profile!.profilePicture,
                      name: state.profile!.username,
                      radius: 20.r,
                      fontSize: 14.sp,
                    ),
                  );
                }
                return InkWell(
                  onTap: () => NavigationService.pushNamed(RouteName.profile),
                  child: Icon(Icons.person_outline, size: 24.sp),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

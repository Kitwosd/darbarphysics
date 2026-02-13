import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_Widget.dart';
import 'package:durbar_physics/common/widgets/elevated_button_widget.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_field_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/settings/bloc/reset_password_cubit/reset_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWidget(title: 'Reset Password'),
      body: BlocProvider(
        create: (context) => getIt<ResetPasswordCubit>(),
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state.status == ApiDataStatus.success) {
              OverlayToastWidget.show(
                message: state.successMessage,
                bgColor: Colors.green.shade400,
              );
              context.read<ResetPasswordCubit>().resetStatus();

              Future.microtask(NavigationService.pop);
            }
            if (state.status == ApiDataStatus.error &&
                state.generalError.isNotEmpty) {
              OverlayToastWidget.show(
                message: state.generalError,
                bgColor: Colors.red.shade400,
              );
              context.read<ResetPasswordCubit>().resetStatus();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    60.verticalSpace,
                    Container(
                      height: 80.h,
                      width: 70.w,

                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        color: appColors.primary,
                        size: 40.sp,
                      ),
                    ),
                    20.verticalSpace,
                    TextWidget(
                      word: 'Reset Your Password ',
                      size: 28,
                      align: TextAlign.center,
                      weight: FontWeight.w600,
                    ),
                    15.verticalSpace,
                    30.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            10.horizontalSpace,
                            TextWidget(
                              word: 'Current Password : ',
                              weight: FontWeight.w700,
                              align: TextAlign.start,
                            ),
                          ],
                        ),

                        TextFieldWidget(
                          label: '',
                          borderRadius: 16.r,
                          hintText: 'Enter your current password',
                          borderColor: Colors.grey.shade400,
                          borderWidth: 1,
                          obscureIcon: true,
                          obscureText: true,
                          onChanged: (value) => context
                              .read<ResetPasswordCubit>()
                              .getOldPassword(value),

                          errorText: state.oldPasswordError.isEmpty
                              ? null
                              : state.oldPasswordError,
                        ),
                        10.verticalSpace,

                        Row(
                          children: [
                            10.horizontalSpace,
                            TextWidget(
                              word: 'New Password : ',
                              weight: FontWeight.w700,
                              align: TextAlign.start,
                            ),
                          ],
                        ),

                        TextFieldWidget(
                          label: '',
                          borderRadius: 16.r,
                          hintText: 'Enter your new password',
                          borderColor: Colors.grey.shade400,
                          borderWidth: 1,
                          obscureIcon: true,
                          obscureText: true,
                          onChanged: (value) => context
                              .read<ResetPasswordCubit>()
                              .getNewPasswordOne(value),
                          errorText: state.newPasswordOneError.isEmpty
                              ? null
                              : state.newPasswordOneError,
                        ),
                        10.verticalSpace,

                        Row(
                          children: [
                            10.horizontalSpace,
                            TextWidget(
                              word: 'Confirm Password : ',
                              weight: FontWeight.w700,
                              align: TextAlign.start,
                            ),
                          ],
                        ),
                        TextFieldWidget(
                          label: '',
                          borderRadius: 16.r,
                          hintText: 'Confirm your password',
                          borderColor: Colors.grey.shade400,
                          borderWidth: 1,
                          obscureIcon: true,
                          obscureText: true,
                          onChanged: (value) => context
                              .read<ResetPasswordCubit>()
                              .getNewPasswordTwo(value),
                          errorText: state.newPasswordTwoError.isEmpty
                              ? null
                              : state.newPasswordTwoError,
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    ElevatedButtonWidget(
                      borderRadius: 32.r,
                      onPressed: () {
                        context.read<ResetPasswordCubit>().resetPassword();
                      },

                      child: state.status == ApiDataStatus.loading
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                              color: customColors.blackWhite,
                            )
                          : TextWidget(
                              word: 'Reset',
                              size: 18,
                              weight: FontWeight.w500,
                              textColor: customColors.whiteBlack,
                            ),
                    ),
                    16.verticalSpace,
                    ElevatedButtonWidget(
                      bgColor: Theme.of(context).cardColor,
                      borderRadius: 32.r,
                      onPressed: () {
                        NavigationService.pop();
                      },

                      child: TextWidget(
                        word: 'Cancel',
                        size: 18,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

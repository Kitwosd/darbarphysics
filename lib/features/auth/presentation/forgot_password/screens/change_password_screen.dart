import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_widget.dart';
import 'package:durbar_physics/common/widgets/elevated_button_widget.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_field_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/auth/presentation/forgot_password/cubit/change_password/change_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatelessWidget {
  final String token;
  const ChangePasswordScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChangePasswordCubit>(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ApiDataStatus.success) {
            OverlayToastWidget.show(
              message: state.successMessage,
              bgColor: Colors.green.shade400,
            );
            Future.microtask(() {
              NavigationService.pushNamedReplacement(RouteName.login);
            });
          }
          if (state.status == ApiDataStatus.error &&
              state.generalError.isNotEmpty) {
            OverlayToastWidget.show(
              message: state.generalError,
              bgColor: Colors.red.shade400,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppbarWidget(title: 'Dubar Physics'),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    90.verticalSpace,
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
                      word: 'Reset Your Password to \n Access Durbar Physics',
                      size: 28,
                      align: TextAlign.center,
                      weight: FontWeight.w600,
                    ),
                    15.verticalSpace,
                    30.verticalSpace,
                    TextFieldWidget(
                      label: 'Enter your new password',
                      borderRadius: 16.r,
                      hintText: 'Enter your password',
                      borderColor: Colors.grey.shade400,
                      borderWidth: 1,
                      obscureIcon: true,
                      obscureText: true,
                      onChanged: (value) => context
                          .read<ChangePasswordCubit>()
                          .getPasswordOne(value),
                      errorText: state.passOneError.isEmpty
                          ? null
                          : state.passOneError,
                      // errorText: '',
                    ),
                    TextFieldWidget(
                      label: 'Enter your new password',
                      borderRadius: 16.r,
                      hintText: 'Confirm your password',
                      borderColor: Colors.grey.shade400,
                      borderWidth: 1,
                      obscureIcon: true,
                      obscureText: true,
                      onChanged: (value) => context
                          .read<ChangePasswordCubit>()
                          .getPasswordTwo(value),
                      errorText: state.passTwoError.isEmpty
                          ? null
                          : state.passTwoError,
                    ),
                    20.verticalSpace,
                    ElevatedButtonWidget(
                      borderRadius: 32.r,
                      onPressed: () {
                        context.read<ChangePasswordCubit>().sentPasswords(
                          token,
                        );
                      },

                      child: state.status == ApiDataStatus.loading
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                              color: customColors.blackWhite,
                            )
                          : TextWidget(
                              word: 'Continue',
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
                        // NavigationService.pushNamedReplacement(RouteName.login);
                      },

                      child: 2 / 2 == 3
                          ? CircularProgressIndicator(strokeWidth: 2)
                          : TextWidget(
                              word: 'Cancel',
                              size: 18,
                              weight: FontWeight.w500,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_widget.dart';
import 'package:durbar_physics/common/widgets/elevated_button_widget.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_field_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/auth/presentation/forgot_password/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordCubit>(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ApiDataStatus.success) {
            OverlayToastWidget.show(
              message: state.message,
              bgColor: Colors.green.shade400,
            );
            Future.delayed(Duration(milliseconds: 500), () {
              if (context.mounted) {
                context.pushNamed(RouteName.otpScreen, extra: context.read<ForgotPasswordCubit>());
              }
              // NavigationService.pushNamed(RouteName.otpScreen);
            });
          }
          if (state.status == ApiDataStatus.error && state.emailError.isEmpty) {
            OverlayToastWidget.show(
              message: state.message,
              bgColor: Colors.red.shade400,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppbarWidget(title: 'Dubar Physics'),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          Icons.fingerprint,
                          color: appColors.primary,
                          size: 40.sp,
                        ),
                      ),
                      20.verticalSpace,
                      TextWidget(
                        word: 'Forgot Your Password \n Email ? ',
                        size: 28,
                        align: TextAlign.center,
                        weight: FontWeight.w600,
                      ),
                      30.verticalSpace,
                      TextFieldWidget(
                        label: 'Enter your email',
                        borderRadius: 16.r,
                        hintText: 'Enter your email',
                        borderColor: Colors.grey.shade400,
                        borderWidth: 1,

                        errorText: state.emailError.isEmpty
                            ? null
                            : state.emailError,
                        onChanged: (value) {
                          context.read<ForgotPasswordCubit>().getEmail(value);
                        },
                      ),

                      24.verticalSpace,
                      ElevatedButtonWidget(
                        borderRadius: 32.r,
                        onPressed: state.status == ApiDataStatus.loading
                            ? null
                            : () {
                                context
                                    .read<ForgotPasswordCubit>()
                                    .submitEmail();
                              },
                        child: state.status == ApiDataStatus.loading
                            ? CircularProgressIndicator(strokeWidth: 2)
                            : TextWidget(
                                word: 'Submit now',
                                textColor: customColors.whiteBlack,
                              ),
                      ),
                      24.verticalSpace,
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.keyboard_backspace, size: 24),
                              8.horizontalSpace,
                              TextWidget(word: 'back to Login'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

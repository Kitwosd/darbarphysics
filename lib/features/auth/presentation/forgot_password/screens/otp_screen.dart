import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_widget.dart';
import 'package:durbar_physics/common/widgets/elevated_button_widget.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/auth/presentation/forgot_password/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:durbar_physics/features/auth/presentation/forgot_password/cubit/otp/otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = context.read<ForgotPasswordCubit>().state.email;
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: appColors.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Color(0xFFE3F2FD),
        border: Border.all(color: appColors.primary),
      ),
    );
    return BlocProvider(
      create: (context) => getIt<OtpCubit>(),
      child: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state.status == ApiDataStatus.success) {
            OverlayToastWidget.show(
              message: 'OTP autheticated !',
              bgColor: Colors.green.shade400,
            );
            Future.microtask(() {
              if (context.mounted) {
                context.pushNamed(
                  RouteName.changePasswordScreen,
                  extra: state.token,
                );
              }
            });
          }
          if (state.status == ApiDataStatus.error &&
              state.errorMessage.isNotEmpty) {
            OverlayToastWidget.show(
              message: state.errorMessage,
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
                          Icons.email_outlined,
                          color: appColors.primary,
                          size: 40.sp,
                        ),
                      ),
                      20.verticalSpace,
                      TextWidget(
                        word: 'Verify Your Email to Begin \n Password Change',
                        size: 28,
                        align: TextAlign.center,
                        weight: FontWeight.w600,
                      ),
                      15.verticalSpace,
                      TextWidget(
                        word: 'Enter the 6-digit verification code',

                        align: TextAlign.center,
                        weight: FontWeight.w300,
                      ),
                      30.verticalSpace,
                      Pinput(
                        controller: _pinController,
                        focusNode: _focusNode,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        onCompleted: (pin) =>
                            context.read<OtpCubit>().getOtp(pin),
                      ),
                      24.verticalSpace,
                      ElevatedButtonWidget(
                        borderRadius: 32.r,
                        onPressed: () {
                          context.read<OtpCubit>().verifyOtp(email);
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

                      24.verticalSpace,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            word: "Didn't you receive any code? ",
                            size: 14,
                          ),

                          InkWell(
                            onTap: () {
                              context.read<ForgotPasswordCubit>().submitEmail();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextWidget(
                                word: 'Resend Code',
                                size: 14,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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

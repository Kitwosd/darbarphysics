import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/elevated_button_widget.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_field_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/title_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/auth/presentation/signup/cubit/sign_up_cubit.dart';
import 'package:durbar_physics/features/auth/presentation/signup/cubit/sign_up_state.dart';
import 'package:durbar_physics/features/auth/presentation/signup/widgets/sign_up_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignUpCubit>(),
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.signupStatus == ApiDataStatus.success) {
            OverlayToastWidget.show(
              message: state.statusMessage,
              bgColor: Colors.green,
            );

            Future.delayed(Duration(milliseconds: 600), () {
              NavigationService.pushNamedReplacement(RouteName.login);
            });
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleWidget(title: 'Sign Up'),
                      20.verticalSpace,
                      TextWidget(
                        word: 'Enter your details below and free sign up',

                        textColor: Colors.grey[700],
                      ),
                      10.verticalSpace,

                      /// Name Field
                      SignUpTextfieldWidget(title: "Name"),
                      BlocSelector<SignUpCubit, SignUpState, String>(
                        selector: (state) => state.nameStatus,
                        builder: (context, nameError) {
                          return TextFieldWidget(
                            label: "Name",
                            onChanged: (v) =>
                                context.read<SignUpCubit>().getName(v),
                            errorText: nameError.isEmpty ? null : nameError,
                            hintText: 'Enter Your Full Name',
                          );
                        },
                      ),
                      12.verticalSpace,

                      /// Email Field
                      SignUpTextfieldWidget(title: "Email"),
                      BlocSelector<SignUpCubit, SignUpState, String>(
                        selector: (state) => state.emailStatus,
                        builder: (context, emailError) {
                          return TextFieldWidget(
                            label: "Email",
                            inputType: TextInputType.emailAddress,
                            onChanged: (v) =>
                                context.read<SignUpCubit>().getEmail(v),
                            errorText: emailError.isEmpty ? null : emailError,
                            hintText: 'example@gmail.com',
                          );
                        },
                      ),
                      12.verticalSpace,

                      /// Password Field
                      SignUpTextfieldWidget(title: "Password"),
                      BlocSelector<SignUpCubit, SignUpState, String>(
                        selector: (state) => state.passwordStatus,
                        builder: (context, passwordError) {
                          return TextFieldWidget(
                            label: "Password",
                            obscureIcon: true,
                            obscureText: true,
                            onChanged: (v) =>
                                context.read<SignUpCubit>().getPassword(v),
                            errorText: passwordError.isEmpty
                                ? null
                                : passwordError,
                            hintText: '********',
                          );
                        },
                      ),
                      12.verticalSpace,
                      SignUpTextfieldWidget(title: "Retype Password"),
                      BlocSelector<SignUpCubit, SignUpState, String>(
                        selector: (state) => state.retypedPasswordStatus,
                        builder: (context, retypedPasswordError) {
                          return TextFieldWidget(
                            label: "Retype Password",
                            obscureIcon: true,
                            obscureText: true,
                            onChanged: (v) => context
                                .read<SignUpCubit>()
                                .getRetypedPassword(v),
                            errorText: retypedPasswordError.isEmpty
                                ? null
                                : retypedPasswordError,
                            hintText: '********',
                          );
                        },
                      ),
                      12.verticalSpace,

                      /// Phone Field
                      SignUpTextfieldWidget(title: "Phone"),
                      BlocSelector<SignUpCubit, SignUpState, String>(
                        selector: (state) => state.phoneStatus,
                        builder: (context, phoneError) {
                          return TextFieldWidget(
                            label: "Phone (Nepal)",
                            inputType: TextInputType.phone,
                            onChanged: (v) =>
                                context.read<SignUpCubit>().getPhone(v),
                            errorText: phoneError.isEmpty ? null : phoneError,
                            hintText: '977-XXXXXXXXXX',
                          );
                        },
                      ),
                      12.verticalSpace,

                      /// Age Field
                      // SignUpTextfieldWidget(title: "Age"),
                      // BlocSelector<SignUpCubit, SignUpState, String>(
                      //   selector: (state) => state.ageStatus,
                      //   builder: (context, ageError) {
                      //     return TextFieldWidget(
                      //       label: "Age",
                      //       inputType: TextInputType.number,
                      //       onChanged: (v) => context.read<SignUpCubit>().getAge(v),
                      //       errorText: ageError.isEmpty ? null : ageError,
                      //       hintText: 'Enter Your Age',
                      //     );
                      //   },
                      // ),
                      20.verticalSpace,

                      /// Signup Button
                      Center(
                        child: SizedBox(
                          width: 300.w,
                          height: 60.h,
                          child: BlocBuilder<SignUpCubit, SignUpState>(
                            builder: (context, state) {
                              return ElevatedButtonWidget(
                                child:
                                    state.signupStatus == ApiDataStatus.loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : TextWidget(
                                        word: "Sign Up",
                                        size: 18,
                                        textColor: Colors.white,
                                        weight: FontWeight.w600,
                                      ),
                                onPressed: () =>
                                    context.read<SignUpCubit>().signupPressed(),
                              );

                              // ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: Theme.of(
                              //       context,
                              //     ).colorScheme.primary,

                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(8.h),
                              //     ),
                              //   ),

                              //   onPressed: () =>
                              //       context.read<SignUpCubit>().signupPressed(),
                              //   child: state.signupStatus == ApiDataStatus.loading
                              //       ? const CircularProgressIndicator(
                              //           color: Colors.white,
                              //         )
                              //       : TextWidget(
                              //           word: "Sign Up",
                              //           size: 18,
                              //           textColor: Colors.white,
                              //           weight: FontWeight.w600,
                              //         ),
                              // );
                            },
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(word: 'Already have an account ?'),
                            TextButton(
                              onPressed: () {
                                NavigationService.pushNamedReplacement(
                                  RouteName.login,
                                );
                              },
                              child: TextWidget(
                                word: 'Login',
                                textColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                weight: FontWeight.w600,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

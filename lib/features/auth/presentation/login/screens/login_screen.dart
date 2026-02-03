import 'package:durbar_physics/common/enums/enums.dart'; // Added for ApiDataStatus
import 'package:durbar_physics/common/widgets/change_language_widget.dart';
import 'package:durbar_physics/common/widgets/elevated_button_widget.dart';
import 'package:durbar_physics/common/widgets/text_field_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/title_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/localization/l10_service.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart' hide l10;
import 'package:durbar_physics/core/theme/theme_extension.dart';
import 'package:durbar_physics/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:durbar_physics/features/auth/presentation/login/cubit/login_state.dart';
import 'package:durbar_physics/features/auth/presentation/signup/widgets/sign_up_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<LoginCubit, LoginState>(
            listenWhen: (previous, current) =>
                previous.loginStatus != current.loginStatus,
            listener: (context, state) {
              if (state.loginStatus == ApiDataStatus.success) {
                // Navigate to home only on success
                NavigationService.pushNamedReplacement(RouteName.home);
              }
            },
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(title: l10.login),
                          Center(
                            child: SizedBox(
                              width: 220.w,
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
                          Center(
                            child: TextWidget(
                              word: 'Durbar Physics',
                              size: 32,
                              weight: FontWeight.w800,
                              textColor: Color(0xFF1877F2),
                            ),
                          ),

                          TextWidget(
                            word: 'Enter your credentials: ',
                            size: 20,
                            weight: FontWeight.w500,
                          ),
                          10.verticalSpace,
                          SignUpTextfieldWidget(title: l10.email),
                          BlocSelector<LoginCubit, LoginState, String>(
                            selector: (state) => state.emailStatus,

                            builder: (BuildContext context, state) {
                              return TextFieldWidget(
                                label: 'Email',
                                onChanged: (value) =>
                                    context.read<LoginCubit>().getEmail(value),
                                errorText: state.isEmpty ? null : state,
                                hintText: 'example@gmail.com',
                              );
                            },
                          ),

                          8.verticalSpace,
                          SignUpTextfieldWidget(title: l10.password),
                          BlocSelector<LoginCubit, LoginState, String>(
                            selector: (state) => state.passwordStatus,
                            builder: (BuildContext context, state) {
                              return TextFieldWidget(
                                label: l10.password,
                                obscureIcon: true,
                                errorText: state.isEmpty ? null : state,
                                hintText: "***********",
                                obscureText: true,

                                onChanged: (value) => context
                                    .read<LoginCubit>()
                                    .getPassword(value),
                              );
                            },
                          ),
                          5.verticalSpace,
                          BlocSelector<LoginCubit, LoginState, bool>(
                            selector: (state) => state.rememberMe,
                            builder: (context, rememberMe) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: rememberMe,
                                        activeColor: Theme.of(
                                          context,
                                        ).primaryColor,
                                        onChanged: (value) {
                                          context
                                              .read<LoginCubit>()
                                              .toggleRememberMe(value);
                                        },
                                      ),
                                      TextWidget(
                                        word: "Remember Me",
                                        size: 14,
                                        weight: FontWeight.w500,
                                      ),
                                    ],
                                  ),

                                  InkWell(
                                    child: TextWidget(
                                      word: 'Forgot Password ? ',
                                      size: 16,
                                      textColor: appColors.primary,
                                      weight: FontWeight.w600,
                                    ),
                                    onTap: () => NavigationService.pushNamed(
                                      RouteName.forgotPassword,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          10.verticalSpace,
                          Center(
                            child: SizedBox(
                              height: 60.h,
                              width: 300.w,
                              child: BlocSelector<LoginCubit, LoginState, ApiDataStatus>(
                                selector: (state) => state.loginStatus,
                                builder: (context, loginStatus) {
                                  return ElevatedButtonWidget(
                                    child: loginStatus == ApiDataStatus.loading
                                        ? SizedBox(
                                            height: 30.h,
                                            width: 30.h,
                                            child:
                                                const CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                          )
                                        : TextWidget(
                                            word: l10.login,
                                            size: 18,
                                            textColor: Colors.white,
                                            weight: FontWeight.w600,
                                          ),
                                    onPressed: () =>
                                        context.read<LoginCubit>().login(),
                                  );

                                  // ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Theme.of(
                                  //       context,
                                  //     ).colorScheme.primary,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(
                                  //         8.h,
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   onPressed: () {
                                  //     context.read<LoginCubit>().login();
                                  //   },
                                  //   child:
                                  //       loginStatus == ApiDataStatus.loading
                                  //       ? SizedBox(
                                  //           height: 30.h,
                                  //           width: 30.h,
                                  //           child:
                                  //               const CircularProgressIndicator(
                                  //                 color: Colors.white,
                                  //               ),
                                  //         )
                                  //       : TextWidget(
                                  //           word: l10.login,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextWidget(word: l10.loginScreentext3),
                              TextButton(
                                onPressed: () {
                                  NavigationService.pushNamed(RouteName.signUp);
                                },
                                child: TextWidget(
                                  word: l10.signup,
                                  weight: FontWeight.w500,

                                  size: 22.sp,
                                  textColor: appColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ChangeLanguageWidget(),
                              Spacer(),
                              InkWell(
                                child: TextWidget(word: 'Theme'),
                                onTap: () => context.toggleTheme(),
                              ),
                              IconButton(
                                icon: Icon(
                                  context.isDark
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                ),
                                onPressed: () {
                                  context.toggleTheme();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

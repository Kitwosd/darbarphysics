import 'package:dubar_physics/common/widgets/button_widget.dart';
import 'package:dubar_physics/common/widgets/change_language_widget.dart';
import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/common/widgets/title_widget.dart';
import 'package:dubar_physics/core/localization/l10_service.dart';
import 'package:dubar_physics/core/routing/navigation_service.dart';
import 'package:dubar_physics/core/routing/route_name.dart';
import 'package:dubar_physics/core/theme/app_theme.dart';
import 'package:dubar_physics/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:dubar_physics/features/auth/presentation/login/cubit/login_state.dart';
import 'package:dubar_physics/common/widgets/text_field_widget.dart';
import 'package:dubar_physics/features/auth/presentation/signup/widgets/sign_up_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
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
                        width: 330.w,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/logo_with_name.png', // TODO: crop the image as there is invisible padding around it.
                              color: AppColors.primary,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                      ),
                    ),

                    TextWidget(
                      word: 'Enter your credentials: ',
                      size: 20.h,
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

                          onChanged: (value) =>
                              context.read<LoginCubit>().getPassword(value),
                        );
                      },
                    ),
                    10.verticalSpace,
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                        ),
                        onPressed: () {},
                        // context.read<LoginCubit>().validateAndSignup(),
                        child: TextWidget(
                          word: l10.login,
                          size: 18,
                          textColor: Colors.white,
                          weight: FontWeight.w600,
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
                            size: 22.h,
                            textColor: Color(0xFF1877F2),
                          ),
                        ),
                      ],
                    ),
                    Center(child: ChangeLanguageWidget()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

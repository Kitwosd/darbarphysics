import 'package:durbar_physics/common/enums/enums.dart';

class LoginState {
  final String email;
  final String emailStatus;

  final String password;
  final String passwordStatus;

  final ApiDataStatus loginStatus;
  final String message;
  final bool rememberMe;

  LoginState({
    this.email = '',
    this.emailStatus = '',
    this.password = '',
    this.passwordStatus = '',
    this.loginStatus = ApiDataStatus.initial,
    this.message = '',
    this.rememberMe = true, // Default true
  });

  LoginState copyWith({
    String? email,
    String? emailStatus,
    String? password,
    String? passwordStatus,
    ApiDataStatus? loginStatus,
    String? message,
    bool? rememberMe,
  }) {
    return LoginState(
      email: email ?? this.email,
      emailStatus: emailStatus ?? this.emailStatus,
      password: password ?? this.password,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      message: message ?? this.message,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

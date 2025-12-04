class LoginState {
  final String email;
  final String emailStatus;

  final String password;
  final String passwordStatus;

  final String loginStatus;

  LoginState({
    this.email = '',
    this.emailStatus = '',
    this.password = '',
    this.passwordStatus = '',
    this.loginStatus = '',
  });

  LoginState copyWith({
    String? email,
    String? emailStatus,
    String? password,
    String? passwordStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      emailStatus: emailStatus ?? this.emailStatus,
      password: password ?? this.password,
      passwordStatus: passwordStatus ?? this.passwordStatus,
    );
  }
}

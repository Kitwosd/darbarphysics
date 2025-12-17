import 'package:durbar_physics/features/auth/presentation/login/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void getEmail(String email) {
    String? error;
    if (email.isEmpty || !email.contains("@")) error = "Enter a valid email";
    emit(state.copyWith(email: email, emailStatus: error ?? ""));
  }

  void getPassword(String password) {
    String? error;
    if (password.length < 8) error = "Your Password is less that 8 characters ";
    emit(state.copyWith(password: password, passwordStatus: error ?? ""));
  }
}

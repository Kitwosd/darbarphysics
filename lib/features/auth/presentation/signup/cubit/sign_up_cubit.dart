import 'dart:developer';
import 'package:dubar_physics/features/auth/presentation/signup/cubit/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  void getName(String name) {
    String? error;
    if (name.trim().isEmpty) error = "Please enter your name";
    emit(state.copyWith(name: name, nameStatus: error ?? ""));
  }

  void getEmail(String email) {
    String? error;
    if (email.isEmpty || !email.contains("@")) error = "Enter a valid email";
    emit(state.copyWith(email: email, emailStatus: error ?? ""));
  }

  void getPassword(String password) {
    String? error;
    if (password.length < 6) error = "Password must be 6+ chars";
    emit(state.copyWith(password: password, passwordStatus: error ?? ""));
  }

  void getPhone(String phone) {
    String? error;
    if (phone.length != 10) error = "Enter valid 10-digit phone";
    emit(state.copyWith(phone: phone, phoneStatus: error ?? ""));
  }

  void getAge(String age) {
    String? error;
    if (int.tryParse(age) == null || int.parse(age) < 10) {
      error = "Enter valid age";
    }
    emit(state.copyWith(age: age, ageStatus: error ?? ""));
  }

  void getGender(String gender) => emit(state.copyWith(gender: gender));

  /// Final validation on signup button
  void validateAndSignup() {
    // Re-check all fields
    if (state.nameStatus.isNotEmpty ||
        state.emailStatus.isNotEmpty ||
        state.passwordStatus.isNotEmpty ||
        state.phoneStatus.isNotEmpty ||
        state.ageStatus.isNotEmpty) {
      // Already has errors, stop
      return;
    }

    signupPressed();
  }

  Future<void> signupPressed() async {
    emit(state.copyWith(signupStatus: "loading"));

    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(signupStatus: "success"));
    } catch (e) {
      log("Signup error: $e");
      emit(state.copyWith(signupStatus: "error"));
    }
  }
}

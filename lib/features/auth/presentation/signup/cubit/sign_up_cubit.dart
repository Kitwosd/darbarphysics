import 'dart:developer';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/features/auth/presentation/signup/cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final ApiClient apiClient;
  SignUpCubit(this.apiClient) : super(const SignUpState());

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

  void getRetypedPassword(String retypedPassword) {
    String? error;
    if (retypedPassword != state.password) error = "Password doesn't match";
    emit(
      state.copyWith(
        retypedPassword: retypedPassword,
        retypedPasswordStatus: error ?? '',
      ),
    );
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
        // state.ageStatus.isNotEmpty ||
        state.retypedPasswordStatus.isNotEmpty) {
      // Already has errors, stop
      return;
    }

    if (state.name.isEmpty ||
        state.email.isEmpty ||
        state.password.isEmpty ||
        state.phone.isEmpty ||
        state.retypedPassword.isEmpty) {
      return;
    }

    signupPressed();
  }

  Future<void> signupPressed() async {
    emit(state.copyWith(signupStatus: "loading"));

    try {
      final data = {
        'full_name': state.name,
        'email': state.email,
        'password': state.password,
        'phone_number': state.phone,
        'age': state.age,
        'gender': state.gender,
      };

      final response = await apiClient.request(
        path: 'auth/signup/',
        method: ApiMethod.post,
        data: data,
      );

      log("Signup Response: $response");

      final message = response['message'] ?? "Signup Successful";
      OverlayToastWidget.show(message: message, bgColor: Colors.green);

      emit(state.copyWith(signupStatus: "success"));
    } catch (e) {
      log("Signup error: $e");

      OverlayToastWidget.show(
        message: "Signup Failed: ${e.toString()}",
        bgColor: Colors.red,
      );

      emit(state.copyWith(signupStatus: "error"));
    }
  }
}

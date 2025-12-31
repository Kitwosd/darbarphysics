import 'dart:developer';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/features/auth/presentation/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final ApiClient apiClient;
  LoginCubit(this.apiClient) : super(LoginState());

  void getEmail(String email) {
    String? error;
    if (email.isEmpty || !email.contains("@")) error = "Enter a valid email";
    emit(state.copyWith(email: email, emailStatus: error ?? ""));
  }

  void getPassword(String password) {
    String? error;
    if (password.length < 5) error = "Your Password is less that 5 characters ";
    emit(state.copyWith(password: password, passwordStatus: error ?? ""));
  }

  void toggleRememberMe(bool? value) {
    emit(state.copyWith(rememberMe: value ?? true));
  }

  void login() async {
    // Basic validation check before API call
    if (state.emailStatus.isNotEmpty || state.passwordStatus.isNotEmpty) return;
    if (state.email.isEmpty || state.password.isEmpty) {
      OverlayToastWidget.show(
        message: "Please fill all fields",
        bgColor: Colors.red,
      );
      return;
    }

    emit(state.copyWith(loginStatus: ApiDataStatus.loading));

    try {
      final response = await apiClient.request(
        path: 'auth/login/',
        method: ApiMethod.post,
        data: {'email': state.email, 'password': state.password},
      );

      // Log response for debugging
      log("Login Response: $response");

      // Check if 'access' token exists
      if (response['access'] != null) {
        final accessToken = response['access'];
        final message = response['message'] ?? "Login successful";

        // Update ApiClient with new token for current session
        apiClient.updateAccessToken(accessToken);

        // Save token to Hive only if Remember Me is checked
        if (state.rememberMe) {
          var box = Hive.box('authBox');
          await box.put('accessToken', accessToken);
        }

        // Show Success Toast
        OverlayToastWidget.show(message: message, bgColor: Colors.green);

        emit(state.copyWith(loginStatus: ApiDataStatus.success));
      } else {
        throw Exception("Invalid response: Token missing");
      }
    } catch (e) {
      log("Login Error: $e");
      String errorMessage = "Login failed";

      // Try to extract message from ApiClient exception if structured
      if (e.toString().contains("message")) {
        errorMessage = e.toString();
      }

      OverlayToastWidget.show(message: errorMessage, bgColor: Colors.red);

      emit(state.copyWith(loginStatus: ApiDataStatus.error));
    }
  }
}

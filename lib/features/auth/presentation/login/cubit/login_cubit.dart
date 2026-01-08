import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
import 'package:durbar_physics/features/auth/presentation/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final ApiClient apiClient;
  LoginCubit(this.apiClient) : super(LoginState());

  String _extractError(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return value.first.toString();
    }
    return value.toString();
  }

  void getEmail(String email) {
    emit(state.copyWith(email: email, emailStatus: ''));
  }

  void getPassword(String password) {
    emit(state.copyWith(password: password, passwordStatus: ''));
  }

  void toggleRememberMe(bool? value) {
    emit(state.copyWith(rememberMe: value ?? true));
  }

  void login() async {
    emit(
      state.copyWith(
        loginStatus: ApiDataStatus.loading,
        emailStatus: '',
        passwordStatus: '',
      ),
    );

    try {
      final response = await apiClient.request(
        path: 'auth/login/',
        method: ApiMethod.post,
        data: {'email': state.email, 'password': state.password},
      );

      // Log response for debugging
      logger.d("Login Response: $response");

      final accessToken = response['access'];
      final refreshToken = response['refresh'];

      // Check if 'access' token exists
      if (accessToken != null) {
        final accessToken = response['access'];
        final message = response['message'] ?? "Login successful";

        // Update ApiClient with new token for current session
        apiClient.updateAccessToken(accessToken);

        // Save tokens to Hive only if Remember Me is checked
        if (state.rememberMe) {
          var box = Hive.box('authBox');
          await box.put('accessToken', accessToken);
          if (refreshToken != null) {
            await box.put('refreshToken', refreshToken);
          }
        }

        // Show Success Toast
        OverlayToastWidget.show(message: message, bgColor: Colors.green);

        emit(state.copyWith(loginStatus: ApiDataStatus.success));
      } else {
        throw Exception("Invalid response: Token missing");
      }
    } catch (e) {
      logger.e("Login Error: $e");

      String errorMessage = "Login failed";

      String emailError = '';
      String passwordError = '';

      if (e is ApiException && e.response is Map<String, dynamic>) {
        final data = e.response as Map<String, dynamic>;
        logger.e(data);
        if (data.containsKey('email')) {
          emailError = _extractError(data['email']);
        }
        if (data.containsKey('password')) {
          passwordError = _extractError(data['password']);
        }
        // Backend might send a general 'detail' or 'message'
        if (data.containsKey('non_field_errors')) {
          errorMessage = _extractError(data['non_field_errors']);
        }
      }
      if (emailError.isEmpty && passwordError.isEmpty) {
        OverlayToastWidget.show(message: errorMessage, bgColor: Colors.red);
      }

      emit(
        state.copyWith(
          loginStatus: ApiDataStatus.error,
          emailStatus: emailError,
          passwordStatus: passwordError,
          message: errorMessage,
        ),
      );
    }
  }
}

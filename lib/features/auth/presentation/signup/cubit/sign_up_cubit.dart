import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/network/api_exception.dart'; // Added
import 'package:durbar_physics/features/auth/presentation/signup/cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final ApiClient apiClient;
  SignUpCubit(this.apiClient) : super(const SignUpState());

  void getName(String name) {
    emit(state.copyWith(name: name, nameStatus: ''));
  }

  void getEmail(String email) {
    emit(state.copyWith(email: email, emailStatus: ""));
  }

  void getPassword(String password) {
    emit(state.copyWith(password: password, passwordStatus: ""));
  }

  void getRetypedPassword(String retypedPassword) {
    emit(
      state.copyWith(
        retypedPassword: retypedPassword,
        retypedPasswordStatus: '',
      ),
    );
  }

  void getPhone(String phone) {
    emit(state.copyWith(phone: phone, phoneStatus: ""));
  }

  void getAge(String age) {
    emit(state.copyWith(age: age, ageStatus: ""));
  }

  void getGender(String gender) => emit(state.copyWith(gender: gender));

  // /// Final validation on signup button
  // void validateAndSignup() {
  //   // Re-check all fields
  //   if (state.nameStatus.isNotEmpty ||
  //       state.emailStatus.isNotEmpty ||
  //       state.passwordStatus.isNotEmpty ||
  //       state.phoneStatus.isNotEmpty ||
  //       // state.ageStatus.isNotEmpty ||
  //       state.retypedPasswordStatus.isNotEmpty) {
  //     // Already has errors, stop
  //     return;
  //   }

  //   if (state.name.isEmpty ||
  //       state.email.isEmpty ||
  //       state.password.isEmpty ||
  //       state.phone.isEmpty ||
  //       state.retypedPassword.isEmpty) {
  //     return;
  //   }

  //   signupPressed();
  // }

  String _extractError(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return value.first.toString();
    }
    return value.toString();
  }

  Future<void> signupPressed() async {
    emit(
      state.copyWith(
        signupStatus: ApiDataStatus.loading,
        nameStatus: '',
        emailStatus: '',
        passwordStatus: '',
        phoneStatus: '',
        ageStatus: '',
      ),
    );

    try {
      final data = {
        'name': state.name,
        'email': state.email,
        'phone': state.phone,
        'password': state.password,
        'password2': state.retypedPassword,
      };

      final response = await apiClient.request(
        path: 'auth/signup/',
        method: ApiMethod.post,
        data: data,
      );

      logger.d("Signup Response: $response");

      final message = response['message'] ?? "Signup Successful";
      // OverlayToastWidget.show(message: message, bgColor: Colors.green);

      emit(
        state.copyWith(
          signupStatus: ApiDataStatus.success,
          statusMessage: message,
        ),
      );
    } catch (e) {
      logger.e("Signup error: $e");
      String errorMessage = "Signup Failed";

      String nameError = '';
      String emailError = '';
      String passwordError = '';
      String retypePasswordError = '';
      String phoneError = '';

      if (e is ApiException && e.response is Map<String, dynamic>) {
        final data = e.response as Map<String, dynamic>;

        if (data.containsKey('name')) {
          nameError = _extractError(data['name']);
        }
        if (data.containsKey('email')) {
          emailError = _extractError(data['email']);
        }
        if (data.containsKey('password')) {
          passwordError = _extractError(data['password']);
        }
        if (data.containsKey('phone')) {
          phoneError = _extractError(data['phone']);
        }
        if (data.containsKey('password2')) {
          retypePasswordError = _extractError(data['password2']);
        }
        if (data.containsKey('detail')) {
          errorMessage = _extractError(data['detail']);
        }
      } else {
        errorMessage = e.toString();
      }

      // Show toast only when there are no field-specific errors
      if (nameError.isEmpty &&
          emailError.isEmpty &&
          passwordError.isEmpty &&
          phoneError.isEmpty &&
          retypePasswordError.isEmpty) {
        OverlayToastWidget.show(message: errorMessage, bgColor: Colors.red);
      }

      emit(
        state.copyWith(
          signupStatus: ApiDataStatus.error,
          nameStatus: nameError,
          emailStatus: emailError,
          passwordStatus: passwordError,
          phoneStatus: phoneError,
          retypedPasswordStatus: retypePasswordError,
        ),
      );
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
import 'package:durbar_physics/features/auth/domain/repo/forgot_password_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'change_password_state.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ForgotPasswordRepo repo;
  ChangePasswordCubit(this.repo) : super(ChangePasswordState());

  void getPasswordOne(String password) {
    emit(state.copyWith(passwordOne: password, passOneError: ''));
  }

  void getPasswordTwo(String password) {
    emit(state.copyWith(passwordTwo: password, passTwoError: ''));
  }

  Future<void> sentPasswords(String token) async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final successMessage = await repo.resetPassword(
        state.passwordOne,
        state.passwordTwo,
        token,
      );
      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          successMessage: successMessage,
        ),
      );
    } catch (e, s) {
      String generalErrorMessage = '';
      String passwordOneError = '';
      String passwordTwoError = '';

      if (e is ApiException) {
        if (e.response is Map<String, dynamic>) {
          final data = e.response as Map<String, dynamic>;

          //handle non_field_error
          if (data.containsKey('non_field_errors')) {
            final error = data['non_field_errors'];
            //backend might give the response in list
            if (error is List && error.isNotEmpty) {
              passwordTwoError = error.first.toString();
            } else {
              passwordTwoError = error.toString();
            }
          }

          //handle invalid token
         

          //handle password specific password one errors
          if (data.containsKey('password')) {
            final error = data['password'];
            if (error is List && error.isNotEmpty) {
              passwordOneError = error.first.toString();
            } else {
              passwordOneError = error.toString();
            }
          }

          //handle specific password two errors
          if (data.containsKey('password2')) {
            final error = data['password2'];
            if (error is List && error.isNotEmpty) {
              passwordTwoError = error.first.toString();
            } else {
              passwordTwoError = error.toString();
            }
          }
        } else {
          generalErrorMessage = e.toString();
        }
      } else {
        generalErrorMessage = e.toString();
      }
      emit(
        state.copyWith(
          status: ApiDataStatus.error,
          passOneError: passwordOneError,
          passTwoError: passwordTwoError,
          generalError: generalErrorMessage,
        ),
      );
    }
  }
}

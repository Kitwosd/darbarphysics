import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
import 'package:durbar_physics/features/settings/data/models/reset_password_model.dart';
import 'package:durbar_physics/features/settings/domain/rep/reset_password_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepo repo;
  ResetPasswordCubit(this.repo) : super(ResetPasswordState());

  void getOldPassword(String oldPassword) {
    emit(state.copyWith(oldPassword: oldPassword, oldPasswordError: ''));
  }

  void getNewPasswordOne(String newPasswordOne) {
    emit(
      state.copyWith(newPasswordOne: newPasswordOne, newPasswordOneError: ''),
    );
  }

  void getNewPasswordTwo(String newPasswordTwo) {
    emit(
      state.copyWith(newPasswordTwo: newPasswordTwo, newPasswordTwoError: ''),
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: ApiDataStatus.initial));
  }

  Future<void> resetPassword() async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    ResetPasswordModel model = ResetPasswordModel(
      oldPassword: state.oldPassword,
      newPasswordOne: state.newPasswordOne,
      newPasswordTwo: state.newPasswordTwo,
    );
    try {
      final successMessage = await repo.resetPassword(model);
      emit(
        state.copyWith(
          successMessage: successMessage,
          status: ApiDataStatus.success,
          oldPasswordError: '',
          newPasswordOneError: '',
          newPasswordTwoError: '',
        ),
      );
    } catch (e) {
      String generalErrorMessage = '';
      String oldPasswordError = '';
      String newPasswordOneError = '';
      String newPasswordTwoError = '';

      if (e is ApiException) {
        if (e.response is Map<String, dynamic>) {
          final data = e.response as Map<String, dynamic>;
         

          //handle non_field_error (the general ones comes in this)
          if (data.containsKey('non_field_errors')) {
            final error = data['non_field_errors'];

            if (error is List && error.isNotEmpty) {
              generalErrorMessage = error.first.toString();
            } else {
              generalErrorMessage = error.toString();
            }
          }

          //handle password specific errors
          if (data.containsKey('old_password')) {
            final error = data['old_password'];

            if (error is List && error.isNotEmpty) {
              oldPasswordError = error.first.toString();
            } else {
              oldPasswordError = error.toString();
            }
          }

          if (data.containsKey('new_password')) {
            final error = data['new_password'];
            if (error is List && error.isNotEmpty) {
              newPasswordOneError = error.first.toString();
            } else {
              newPasswordOneError = error.toString();
            }
          }

          if (data.containsKey('new_password2')) {
            final error = data['new_password2'];
            if (error is List && error.isNotEmpty) {
              newPasswordTwoError = error.first.toString();
            } else {
              newPasswordTwoError = error.toString();
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
          generalError: generalErrorMessage,
          oldPasswordError: oldPasswordError,
          newPasswordOneError: newPasswordOneError,
          newPasswordTwoError: newPasswordTwoError,
        ),
      );
    }
  }
}

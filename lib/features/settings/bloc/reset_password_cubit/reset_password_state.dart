// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'reset_password_cubit.dart';

class ResetPasswordState extends Equatable {
  final String generalError;
  final String oldPasswordError;
  final String newPasswordOneError;
  final String newPasswordTwoError;
  final String oldPassword;
  final String newPasswordOne;
  final String newPasswordTwo;
  final ApiDataStatus status;
  final String successMessage;
  const ResetPasswordState({
    this.generalError = '',
    this.oldPasswordError = '',
    this.newPasswordOneError = '',
    this.newPasswordTwoError = '',
    this.oldPassword = '',
    this.newPasswordOne = '',
    this.newPasswordTwo = '',
    this.status = ApiDataStatus.initial,
    this.successMessage = '',
  });

  @override
  List<Object> get props {
    return [
      generalError,
      oldPasswordError,
      newPasswordOneError,
      newPasswordTwoError,
      oldPassword,
      newPasswordOne,
      newPasswordTwo,
      status,
      successMessage,
    ];
  }

  ResetPasswordState copyWith({
    String? generalError,
    String? oldPasswordError,
    String? newPasswordOneError,
    String? newPasswordTwoError,
    String? oldPassword,
    String? newPasswordOne,
    String? newPasswordTwo,
    ApiDataStatus? status,
    String? successMessage,
  }) {
    return ResetPasswordState(
      generalError: generalError ?? this.generalError,
      oldPasswordError: oldPasswordError ?? this.oldPasswordError,
      newPasswordOneError: newPasswordOneError ?? this.newPasswordOneError,
      newPasswordTwoError: newPasswordTwoError ?? this.newPasswordTwoError,
      oldPassword: oldPassword ?? this.oldPassword,
      newPasswordOne: newPasswordOne ?? this.newPasswordOne,
      newPasswordTwo: newPasswordTwo ?? this.newPasswordTwo,
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

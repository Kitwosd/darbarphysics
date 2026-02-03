part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  final String passwordOne;
  final String passwordTwo;
  final String passOneError;
  final String passTwoError;
  final String generalError;
  final ApiDataStatus status;
  final String token;
  final String successMessage;

  const ChangePasswordState({
    this.passwordOne = '',
    this.passwordTwo = '',
    this.passOneError = '',
    this.passTwoError = '',
    this.generalError = '',
    this.status = ApiDataStatus.initial,
    this.token = '',
    this.successMessage = '',
  });

  ChangePasswordState copyWith({
    String? passwordOne,
    String? passwordTwo,
    String? passOneError,
    String? passTwoError,
    String? generalError,
    ApiDataStatus? status,
    String? token,
    String? successMessage,
  }) {
    return ChangePasswordState(
      passwordOne: passwordOne ?? this.passwordOne,
      passwordTwo: passwordTwo ?? this.passwordTwo,
      passOneError: passOneError ?? this.passOneError,
      passTwoError: passTwoError ?? this.passTwoError,
      generalError: generalError ?? this.generalError,
      status: status ?? this.status,
      token: token ?? this.token,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object> get props {
    return [
      passwordOne,
      passwordTwo,
      passOneError,
      passTwoError,
      generalError,
      status,
      token,
      successMessage,
    ];
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final String emailError;
  final String message;
  final ApiDataStatus status;


  const ForgotPasswordState({
    this.message = '',
    this.status = ApiDataStatus.initial,
    this.email = '',
    this.emailError = '',
    
  });

  ForgotPasswordState copyWith({
    String? email,
    String? emailError,
    String? message,
    ApiDataStatus? status,
   
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError ?? this.emailError,
      message: message ?? this.message,
      status: status ?? this.status,
     
    );
  }

  @override
  List<Object> get props => [email, emailError, message, status, ];
}

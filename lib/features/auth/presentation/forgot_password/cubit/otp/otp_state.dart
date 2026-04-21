part of 'otp_cubit.dart';

class OtpState extends Equatable {
  final String otp;
  final ApiDataStatus status;
  final String errorMessage;
  final String email;
  final String? token;

  const OtpState({
    this.otp = '',
    this.status = ApiDataStatus.initial,
    this.errorMessage = '',
    this.email = '',
    this.token,
  });

  OtpState copyWith({
    String? otp,
    ApiDataStatus? status,
    String? errorMessage,
    String? email,
    String? token,
  }) {
    return OtpState(
      otp: otp ?? this.otp,

      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  @override
  List<Object> get props => [otp, status, errorMessage, email];
}

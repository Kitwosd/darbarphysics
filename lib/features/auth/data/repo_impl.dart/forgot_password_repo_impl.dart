import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/features/auth/domain/repo/forgot_password_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ForgotPasswordRepo)
class ForgotPasswordRepoImpl implements ForgotPasswordRepo {
  ApiClient apiClient;

  ForgotPasswordRepoImpl(this.apiClient);
  @override
  Future<String> sendEmail(String email) async {
    final response = await apiClient.request(
      path: 'password-reset/request/',
      method: ApiMethod.post,
      data: {'email': email},
    );
    return response['message']?.toString() ?? 'OTP has been sent';
  }

  @override
  Future<String> verifyOtp(String otp, String email) async {
    final response = await apiClient.request(
      path: 'password-reset/verify/',
      method: ApiMethod.post,
      data: {'email': email, 'otp': otp},
    );
    return response['token'].toString();
  }

  @override
  Future<String> resetPassword(
    String passwordOne,
    String passwordTwo,
    String token,
  ) async {
    final response = await apiClient.request(
      path: 'password-reset/confirm/',
      method: ApiMethod.post,
      data: {'token': token, 'password': passwordOne, 'password2': passwordTwo},
    );
    return response['message'].toString();
  }
}

abstract class ForgotPasswordRepo {
  Future<String> sendEmail(String email);

  Future<String> verifyOtp(String otp, String email);

  Future<String> resetPassword(
    String passwordOne,
    String passwordTwo,
    String token,
  );
}

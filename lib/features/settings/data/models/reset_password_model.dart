class ResetPasswordModel {
  String oldPassword;
  String newPasswordOne;
  String newPasswordTwo;
  ResetPasswordModel({
    required this.oldPassword,
    required this.newPasswordOne,
    required this.newPasswordTwo,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'old_password': oldPassword,
      'new_password': newPasswordOne,
      'new_password2': newPasswordTwo,
    };
  }
}

class LoginValidateModel {
  final String? emailStatus;
  final String? passwordStatus;

  const LoginValidateModel({this.emailStatus, this.passwordStatus});

  factory LoginValidateModel.fromJson(Map<String, dynamic> json) {
    return LoginValidateModel(
      emailStatus: json['email'],
      passwordStatus: json['password'],
    );
  }
}

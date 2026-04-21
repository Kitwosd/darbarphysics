class EmailValidateModel {
  final String? emailStatus;

  const EmailValidateModel({this.emailStatus});

  factory EmailValidateModel.fromJson(Map<String, dynamic> json) {
    return EmailValidateModel(emailStatus: json['email']);
  }
}

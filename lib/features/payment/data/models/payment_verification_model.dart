// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaymentVerificationModel {
  final bool isSucess;
  final String? status;
  final String? course;
  final String? errorMessage;
  const PaymentVerificationModel({
    required this.isSucess,
    this.status,
    this.course,
    this.errorMessage,
  });
  factory PaymentVerificationModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      return PaymentVerificationModel(
        isSucess: false,
        errorMessage: json['error'],
      );
    }
    if (json.containsKey('detail')) {
      return PaymentVerificationModel(
        isSucess: false,
        errorMessage: json['detail'],
      );
    }

    return PaymentVerificationModel(
      isSucess: true,
      course: json['course'],
      status: json['status'],
    );
  }
}

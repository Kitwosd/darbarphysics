// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaymentVerificationModel {
  final bool isSucess;
  final String? status;
  final String? course;
  final String? packageName;
  final String? errorMessage;
  final bool isPending;
  const PaymentVerificationModel({
    required this.isSucess,
    this.status,
    this.course,
    this.packageName,
    this.errorMessage,
    this.isPending = false,
  });
  factory PaymentVerificationModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      // generic error
      return PaymentVerificationModel(
        isSucess: false,
        errorMessage: json['error'],
      );
    }
    if (json.containsKey('detail')) {
      return PaymentVerificationModel(
        isSucess: false,
        errorMessage: json['detail'],
        isPending: false, //Don't retry if the pidx is wrong or empty
      );
    }
    //success: payment sucessful

    if (json['status'] == 'success' || json['status'] == 'already_completed') {
      return PaymentVerificationModel(
        isSucess: true,
        course: json['course'],
        packageName: json['package'],
        status: json['status'],
      );
    }

    //Pending: payment processing (should retry)
    if (json['status'] == 'failed' && json['reason'] == 'Pending') {
      return PaymentVerificationModel(
        isSucess: false,
        isPending: true, // tell the app to retry
        status: 'Pending',
        errorMessage: 'Payment is being verified by khalti',
      );
    }

    // Real failures(expired, refunded etc)
    return PaymentVerificationModel(
      isSucess: false,
      errorMessage: json['reason'] ?? 'Payment verification failed',
      status: json['status'],
    );
  }
}

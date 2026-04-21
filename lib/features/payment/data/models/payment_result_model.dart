

class PaymentResultModel {
  final bool success;
  final String? pidx;
  final String? transactionId;
  final int? amount;
  final String? status;
  final String? errorMessage;
  PaymentResultModel({
    required this.success,
    this.pidx,
    this.transactionId,
    this.amount,
    this.status,
    this.errorMessage,
  });

  factory PaymentResultModel.success({
    required String pidx,
    required String transactionId,
    required int amount,
    required String status,
  }) {
    return PaymentResultModel(
      success: true,
      pidx: pidx,
      transactionId: transactionId,
      amount: amount,
      status: status,
    );
  }

  factory PaymentResultModel.failure({required String errorMessage}) {
    return PaymentResultModel(success: false, errorMessage: errorMessage);
  }

  factory PaymentResultModel.cancelled() {
    return PaymentResultModel(
      success: false,
      errorMessage: 'Payment Cancelled by User',
    );
  }
}

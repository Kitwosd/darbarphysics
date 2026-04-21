import 'package:equatable/equatable.dart';

class PaymentInitiateResponseModel extends Equatable {
  final bool success;
  final String? pidx;
  final String? errorMessage;
  final String? paymentUrl;
  const PaymentInitiateResponseModel({
    required this.success,
    this.pidx,
    this.errorMessage,
    this.paymentUrl,
  });

  factory PaymentInitiateResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      return PaymentInitiateResponseModel(
        success: false,
        errorMessage: json['error'],
      );
    }
    if (json.containsKey('detail')) {
      return PaymentInitiateResponseModel(
        success: false,
        errorMessage: json['detail'],
      );
    }
    return PaymentInitiateResponseModel(
      success: true,
      pidx: json['pidx'],
      paymentUrl: json['payment_url'],
    );
  }

  @override
  List<Object> get props => [success];
}

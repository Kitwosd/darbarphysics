// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PaymentInitiateResponseModel extends Equatable {
  final bool success;
  final String? pidx;
  final String? errorMessage;
  const PaymentInitiateResponseModel({
    required this.success,
    this.pidx,
    this.errorMessage,
  });

  factory PaymentInitiateResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentInitiateResponseModel(
      success: json['success'] ?? false,
      pidx: json['pidx'],
      errorMessage: json['errorMessage'],
    );
  }
//[Mock]
  factory PaymentInitiateResponseModel.mock() {
    return PaymentInitiateResponseModel(
      success: true,
      pidx: 'mock_pidx_${DateTime.now().microsecondsSinceEpoch}',
    );
  }

  @override
  List<Object> get props => [success];
}

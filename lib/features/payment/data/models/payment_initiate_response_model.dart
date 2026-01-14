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
// import 'package:equatable/equatable.dart';

// class PaymentInitiateResponseModel extends Equatable {
//   final bool success;
//   final String? pidx;
//   final String? errorMessage;
//   final String? paymentUrl;
//   const PaymentInitiateResponseModel({
//     required this.success,
//     this.pidx,
//     this.errorMessage,
//     this.paymentUrl,
//   });

//   factory PaymentInitiateResponseModel.fromJson(Map<String, dynamic> json) {
//     if (json.containsKey('error')) {
//       return PaymentInitiateResponseModel(
//         success: false,
//         errorMessage: json['error'],
//       );
//     }
//     return PaymentInitiateResponseModel(
//       success: true,
//       pidx: json['pidx'],
//       paymentUrl: json['payment_url'],
//     );
//   }

//   @override
//   List<Object> get props => [success];
// }

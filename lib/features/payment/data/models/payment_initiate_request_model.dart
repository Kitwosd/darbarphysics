// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PaymentInitiateRequestModel extends Equatable {
  final String returnUrl;
  final String websiteUrl;
  final int amount;
  final String purchaseOrderId;
  final String purchaseOrderName;
  final CustomerInfo customerInfo;

  const PaymentInitiateRequestModel({
    required this.returnUrl,
    required this.websiteUrl,
    required this.amount,
    required this.purchaseOrderId,
    required this.purchaseOrderName,
    required this.customerInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'return_url': returnUrl,
      'website_url': websiteUrl,
      'amount': amount,
      'purchase_order_id': purchaseOrderId,
      'purchase_order_name': purchaseOrderName,
      'customer_info': customerInfo.toJson(),
    };
  }

  //create from course enrollment

  factory PaymentInitiateRequestModel.fromCourse({
    required String courseId,
    required String courseName,
    required String userId,
    required double priceInRupees,
    required String userName,
    required String userEmail,
    required String userPhone,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return PaymentInitiateRequestModel(
      returnUrl: 'https://yourapp.com/payment/return/',
      websiteUrl: 'https://yourapp.com/',
      amount: (priceInRupees * 100).toInt(),
      purchaseOrderId: 'course_${courseId}_user_${userId}_$timestamp',
      purchaseOrderName: courseName,
      customerInfo: CustomerInfo(
        name: userName,
        email: userEmail,
        phone: userPhone,
      ),
    );
  }

  @override
  List<Object> get props {
    return [
      returnUrl,
      websiteUrl,
      amount,
      purchaseOrderId,
      purchaseOrderName,
      customerInfo,
    ];
  }
}

class CustomerInfo extends Equatable {
  final String name;
  final String email;
  final String phone;

  const CustomerInfo({
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone};
  }

  @override
  List<Object> get props => [name, email, phone];
}

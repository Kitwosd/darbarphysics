// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PaymentInitiateRequestModel extends Equatable {
  final String returnUrl; //as name says it
  final String websiteUrl; // yo chai hamro app link or mainly web link types re just for verification for the khalti that we are genuine re we can just send app.com re
  final int amount; // must be in paisa
  final String purchaseOrderId; //yo chai created by the backend not frontend
  final String purchaseOrderName; //just the name of course in human readable format
  final CustomerInfo customerInfo; //customer ko info vaihalyo. 

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

// class PaymentInitiateModel {
//   final int courseId;
//   const PaymentInitiateModel({required this.courseId});

//   Map<String, dynamic> toJson() {
//     return {'course_id': courseId};
//   }
// }
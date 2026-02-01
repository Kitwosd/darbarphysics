class PaymentInitiateRequestModel {
  final int courseId;
  const PaymentInitiateRequestModel({required this.courseId});

  Map<String, dynamic> toJson() {
    return {'course_id': courseId};
  }
}

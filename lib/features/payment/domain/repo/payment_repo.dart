import 'package:durbar_physics/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:durbar_physics/features/payment/data/models/payment_verification_model.dart';

abstract class PaymentRepo {
  Future<PaymentInitiateResponseModel> getPidx(int courseId);
  Future<PaymentVerificationModel> verifyPayment(String pidx);
}




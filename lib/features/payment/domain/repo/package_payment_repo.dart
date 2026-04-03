import 'package:durbar_physics/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:durbar_physics/features/payment/data/models/payment_verification_model.dart';

abstract class PackagePaymentRepo {
  Future<PaymentInitiateResponseModel> getPackagePidx(int packageId);
  Future<PaymentVerificationModel> verifyPackagePayment(String pidx);
}

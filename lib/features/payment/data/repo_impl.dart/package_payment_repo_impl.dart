import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
import 'package:durbar_physics/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:durbar_physics/features/payment/data/models/payment_verification_model.dart';
import 'package:durbar_physics/features/payment/domain/repo/package_payment_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/logger/app_logger.dart';

@Injectable(as: PackagePaymentRepo)
class PackagePaymentRepoImpl implements PackagePaymentRepo {
  final ApiClient client;
  const PackagePaymentRepoImpl(this.client);

  @override
  Future<PaymentInitiateResponseModel> getPackagePidx(int packageId) async {
    try {
      final response = await client.request(
        path: 'package/pay/',
        method: ApiMethod.post,
        data: {'package_id': packageId},
      );
      logger.i(response);
      return PaymentInitiateResponseModel.fromJson(response);
    } catch (e) {
      if (e is ApiException && e.response != null) {
        return PaymentInitiateResponseModel.fromJson(e.response);
      }
      rethrow;
    }
  }

  @override
  Future<PaymentVerificationModel> verifyPackagePayment(String pidx) async {
    try {
      final response = await client.request(
        path: 'package/verify/',
        method: ApiMethod.get,
        queryParameters: {'pidx': pidx},
      );
      return PaymentVerificationModel.fromJson(response);
    } catch (e) {
      if (e is ApiException && e.response != null) {
        return PaymentVerificationModel.fromJson(e.response);
      }
      rethrow;
    }
  }
}

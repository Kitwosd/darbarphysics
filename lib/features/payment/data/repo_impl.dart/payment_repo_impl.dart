import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
import 'package:durbar_physics/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:durbar_physics/features/payment/data/models/payment_verification_model.dart';
import 'package:durbar_physics/features/payment/domain/repo/payment_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/logger/app_logger.dart';

@Injectable(as: PaymentRepo)
class PaymentRepoImpl implements PaymentRepo {
  final ApiClient client;
  const PaymentRepoImpl(this.client);
  @override
  Future<PaymentInitiateResponseModel> getPidx(int courseId) async {
    try {
      final response = await client.request(
        path: 'khalti/pay/',
        method: ApiMethod.post,
        data: {'course_id': courseId},
      );
      logger.i(response);
      return PaymentInitiateResponseModel.fromJson(response);
    } catch (e) {
      // Check if it's an ApiException (which wraps DioException)
      if (e is ApiException && e.response != null) {
        return PaymentInitiateResponseModel.fromJson(e.response);
      }
      rethrow;
    }
  }

  @override
  Future<PaymentVerificationModel> verifyPayment(String pidx) async {
    try {
      final response = await client.request(
        path: 'khalti/verify/',
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

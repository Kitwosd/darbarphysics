import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:durbar_physics/features/payment/data/models/payment_result_model.dart';
import 'package:durbar_physics/features/payment/data/models/payment_verification_model.dart';
import 'package:durbar_physics/features/payment/domain/repo/payment_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart' as khalti;

@injectable
class KhaltiPaymentService {
  final PaymentRepo repo;

  KhaltiPaymentService(this.repo);

  //method to call the backend and get the pidx
  Future<PaymentInitiateResponseModel> initializePayment({
    required int courseId,
  }) async {
    // try {
    logger.i('courseId: $courseId');
    final response = await repo.getPidx(courseId);
    logger.i('response: $response');
    return response;

    // } catch (e, stack) {
    //   logger.e('InitializePayment error: $e, $stack, ');
    //   return PaymentInitiateResponseModel(
    //     success: false,
    //     errorMessage: 'InitializePayment error: $e',
    //   );
    // }
  }

  //Process payment with khalti
  Future<PaymentResultModel> processPayment({
    required BuildContext context,
    required String pidx,
  }) async {
    try {
      final publicKey = dotenv.env['KHALTI_PUBLIC_KEY_TEST'] ?? '';
      if (publicKey.isEmpty) {
        return PaymentResultModel.failure(
          errorMessage: 'Khalti public key not found',
        );
      }

      //configure payment

      final payConfig = khalti.KhaltiPayConfig(
        publicKey: publicKey,
        pidx: pidx,
        environment: khalti.Environment.test, // Change to prod for live
      );

      PaymentResultModel? result;

      //Initiate khalti
      final khaltiInstance = await khalti.Khalti.init(
        enableDebugging: true,
        payConfig: payConfig,

        //called on successful payment
        onPaymentResult: (paymentResult, khaltiInstance) {
          result = PaymentResultModel.success(
            pidx: paymentResult.payload?.pidx ?? '',
            transactionId: paymentResult.payload?.transactionId ?? '',
            amount: paymentResult.payload?.totalAmount ?? 0,
            status: paymentResult.payload?.status ?? '',
          );
        },

        //called for message on errors
        onMessage:
            (
              khaltiInstance, {
              description,
              statusCode,
              event,
              needsPaymentConfirmation,
            }) {
              if (event == khalti.KhaltiEvent.kpgDisposed) {
                result ??= PaymentResultModel.cancelled();
              } else if (event == khalti.KhaltiEvent.networkFailure) {
                result = PaymentResultModel.failure(
                  errorMessage: 'Network Error: $description',
                );
              } else {
                result = PaymentResultModel.failure(
                  errorMessage: 'Payment Failed: $description',
                );
              }
            },

        onReturn: () {
          // Optional: it is triggered when return url loads
        },
      );

      if (!context.mounted) {
        return PaymentResultModel.failure(errorMessage: 'Context not mounted');
      }

      //Open khalti payment page
      khaltiInstance.open(context);

      // wait for callback result

      while (result == null && context.mounted) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      return result ??
          PaymentResultModel.failure(errorMessage: 'Payment Result not Found');
    } catch (e) {
      return PaymentResultModel.failure(errorMessage: 'Error: $e');
    }
  }

  Future<PaymentVerificationModel> verifyPaymentOnBackend({
    required String pidx,
  }) async {
    try {
      final responseData = await repo.verifyPayment(pidx);
      logger.d('Verification Response Data: $responseData');
      return responseData;
    } catch (e) {
      logger.e('Backend Verification error: $e');
      return PaymentVerificationModel(
        isSucess: false,
        errorMessage: 'Something went wrong during verification.:  $e',
      );
    }
  }
}

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
          environment: khalti.Environment.test, //TODO: Change to prod for live
        );

        PaymentResultModel? result;
        bool paymentCompleted = false;

        //Initiate khalti
        final khaltiInstance = await khalti.Khalti.init(
          enableDebugging: true,
          payConfig: payConfig,

          //called on successful payment
          onPaymentResult: (paymentResult, khaltiInstance) {
            logger.i('✅ Payment successful: ${paymentResult.payload?.pidx}');
            result = PaymentResultModel.success(
              pidx: paymentResult.payload?.pidx ?? '',
              transactionId: paymentResult.payload?.transactionId ?? '',
              amount: paymentResult.payload?.totalAmount ?? 0,
              status: paymentResult.payload?.status ?? '',
            );
            paymentCompleted = true;

            // close the khalti webview after successful paymetn
            khaltiInstance.close(context);
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
                logger.w('Khalti event: $event, description: $description');
                if (event == khalti.KhaltiEvent.kpgDisposed) {
                  //user closed the payment dialog
                  // ignore: prefer_conditional_assignment
                  if (result == null) {
                    result = PaymentResultModel.cancelled();
                  }
                  paymentCompleted = true;
                } else if (event == khalti.KhaltiEvent.networkFailure) {
                  result = PaymentResultModel.failure(
                    errorMessage: 'Network Error: $description',
                  );
                  paymentCompleted = true;
                } else {
                  result = PaymentResultModel.failure(
                    errorMessage: 'Payment Failed: $description',
                  );
                  paymentCompleted = true;
                }
              },

          onReturn: () {
            // Optional: it is triggered when return url loads
            logger.i('Return URL triggered - ignoring');
            // We don't need to do anything here
            // Payment confirmation comes via onPaymentResult
          },
        );

        if (!context.mounted) {
          return PaymentResultModel.failure(errorMessage: 'Context not mounted');
        }

        //Open khalti payment page
        khaltiInstance.open(context);

        // wait for callback result
        // Wait for payment to complete (with timeout)
        final timeout = DateTime.now().add(const Duration(minutes: 5));

        while (!paymentCompleted &&
            context.mounted &&
            DateTime.now().isBefore(timeout)) {
          await Future.delayed(const Duration(milliseconds: 500));
        }

        if (!paymentCompleted) {
          return PaymentResultModel.failure(
            errorMessage: 'Payment timeout - please try again',
          );
        }

        return result ?? PaymentResultModel.cancelled();
      } catch (e, stack) {
        logger.e('Payment processing error: $e', stackTrace: stack);
        return PaymentResultModel.failure(errorMessage: 'Error: $e');
      }
    }

    Future<PaymentVerificationModel> verifyPaymentOnBackend({
      required String pidx,
    }) async {
      // like khalti ko verification milairako
      const int maxAttempts = 5;
      const Duration initialDelay = Duration(seconds: 2); //wait for 2s first time
      const Duration retryDelay = Duration(seconds: 3);

      //wait a bit before first check (let khalti process)
      await Future.delayed(initialDelay);

      //Retry looop
      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        try {
          logger.d(
            '🔍 Verification attempt $attempt/$maxAttempts for pidx: $pidx',
          );
          final responseData = await repo.verifyPayment(pidx);
          logger.d('Verification Response Data: $responseData');

          // ✅ SUCCESS - Payment is completed!
          if (responseData.isSucess) {
            logger.i('✅ Payment verified successfully on attempt $attempt');

            return responseData;
          }

          // ⏳ PENDING - Khalti still processing, retry
          if (responseData.isPending) {
            if (attempt < maxAttempts) {
              logger.w(
                'Payment status is pending, '
                'waiting ${retryDelay.inSeconds}s before try $attempt/$maxAttempts',
              );
              await Future.delayed(retryDelay);
              continue;
            } else {
              //Timeout after max attempts
              logger.e('Verification timeout after $maxAttempts attempts');

              return PaymentVerificationModel(
                isSucess: false,
                errorMessage:
                    'Payment verification is taking longer than expected. '
                    'Please check "My Courses" in a few minutes or contact support.',
              );
            }
          }

          // ❌ FAILED - Real failure (not pending)
          logger.e('❌ Payment verification failed: ${responseData.errorMessage}');
          return responseData;
        } catch (e, stack) {
          logger.e(
            'Error during verification attempt $attempt: $e',
            stackTrace: stack,
          );

          //If last attempt return error

          if (attempt >= maxAttempts) {
            return PaymentVerificationModel(
              isSucess: false,
              errorMessage:
                  'Verification failed after $maxAttempts attemps. Error: $e',
            );
          }
          // Otherwise, retry
          logger.w('Retrying after error...');
          await Future.delayed(retryDelay);
        }
      }
      // Should never reach here, but just in case
      return PaymentVerificationModel(
        isSucess: false,
        errorMessage: 'Verification timeout. Please contact support.',
      );
    }
  }

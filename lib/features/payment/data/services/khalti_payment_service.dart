import 'package:dio/dio.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/features/payment/data/models/payment_initiate_request_model.dart';
import 'package:durbar_physics/features/payment/data/models/payment_initiate_response_model.dart';
import 'package:durbar_physics/features/payment/data/models/payment_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart' as khalti;

@injectable
class KhaltiPaymentService {
  final Dio _dio = Dio();

  /// Initialize payment by calling Khalti API directly
  /// This gets a real pidx from Khalti that can be used for actual payment
  Future<PaymentInitiateResponseModel> initializePayment({
    required PaymentInitiateRequestModel request,
    bool useMock = false, // Changed default to false
  }) async {
    try {
      if (useMock) {
        logger.d(
          '[Mock] Using mock pidx for testing (won\'t work with real Khalti)',
        );
        await Future.delayed(const Duration(seconds: 1));
        return PaymentInitiateResponseModel.mock();
      }

      // Get secret key from environment (NOT the public key!)
      final secretKey = dotenv.env['KHALTI_SECRET_KEY'] ?? '';
      if (secretKey.isEmpty) {
        return PaymentInitiateResponseModel(
          success: false,
          errorMessage:
              'Khalti secret key not found in .env file. Please add KHALTI_SECRET_KEY to your .env',
        );
      }

      logger.d('Calling Khalti API to get real pidx...');
      logger.d(
        'Secret Key loaded: ${secretKey.substring(0, 10)}... (${secretKey.length} chars)',
      );

      // Determine API base URL based on environment
      // For sandbox/test: use dev.khalti.com
      // For production: use a.khalti.com
      final apiBaseUrl = 'https://dev.khalti.com'; // Using sandbox URL

      logger.d('Using API URL: $apiBaseUrl/api/v2/epayment/initiate/');

      // Call Khalti's initiate payment API
      final response = await _dio.post(
        '$apiBaseUrl/api/v2/epayment/initiate/',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Key $secretKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      logger.d('Khalti API Response: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final pidx = response.data['pidx'] as String?;

        if (pidx != null && pidx.isNotEmpty) {
          return PaymentInitiateResponseModel(success: true, pidx: pidx);
        }
      }

      return PaymentInitiateResponseModel(
        success: false,
        errorMessage: 'Failed to get pidx from Khalti',
      );
    } on DioException catch (e) {
      logger.e('Khalti API Error: ${e.response?.data ?? e.message}');
      return PaymentInitiateResponseModel(
        success: false,
        errorMessage: 'API Error: ${e.response?.data?['detail'] ?? e.message}',
      );
    } catch (e) {
      logger.e('InitializePayment error: $e');
      return PaymentInitiateResponseModel(
        success: false,
        errorMessage: e.toString(),
      );
    }
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

  // ==========================================
  // BACKEND INTEGRATION SECTION (FOR FUTURE)
  // ==========================================
  /// Verify payment on backend
  /// TODO: Implement when backend is ready
  Future<bool> verifyPaymentOnBackend({required String pidx}) async {
    try {
      //When backend is ready uncomment below things and rectify the endpoints
      // final response = await apiClient.post(
      //   '/api/khalti/verify_payment',
      //   data: {'pidx': pidx},
      // );
      // return response.data['success'] ?? false;

      logger.d('Backend Verification called (not implemented yet)');
      logger.d('pidx: $pidx');

      return true; // mock success for now
    } catch (e) {
      logger.e('Backend Verification error: $e');
      return false;
    }
  }

  ///Grant Course
  ///Implement when backend is ready
  Future<bool> grantCourseAccess({
    required String courseId,
    required String userId,
  }) async {
    try {
      /// Todo: call your backend to grant access
      /// But i don't how the work flow works as hamle video haru ma lock rakheko ko xam with boolean,
      /// so may be hamle course lai refresh gardiye paxi aru video haru ko access milxa hola just a overview for future

      /// final response = await apiClient.post()
      /// '/api/courses/enroll',
      /// data: {
      /// 'course_id': courseId,
      /// 'user_id': userId,
      /// }
      /// );
      ///

      logger.d('Grant access called (not implemented yet)');
      logger.d('Course: $courseId, User: $userId');

      return true; //mock success for now
    } catch (e) {
      logger.d('Grant access error: $e');
      return false;
    }
  }
}

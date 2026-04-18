import 'dart:async';

import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart' as khalti;

/// Responsible only for opening Khalti SDK
/// and returning the pidx if payment was successful
/// Returns null if cancelled or failed

@injectable
class KhaltiService {
  Future<String?> openPayment({
    required BuildContext context,
    required String pidx,
  }) async {
    final publicKey = dotenv.env['KHALTI_PUBLIC_KEY_TEST'] ?? '';

    if (publicKey.isEmpty) {
      logger.e('Khalti public key not found in .env');
      return null;
    }

    final payConfig = khalti.KhaltiPayConfig(
      publicKey: publicKey,
      pidx: pidx,
      environment: khalti.Environment.test, // TODO: (Khalti) Change to prod for live
    );

    // Completer waits for the result
    final completer = Completer<String?>();
    bool resultHandled = false;
    khalti.Khalti? khaltiInstance;

    khaltiInstance = await khalti.Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,

      // ✅ THIS IS IDEAL - Payment successful
      // But doesn't always fire due to Khalti SDK quirk
      onPaymentResult: (paymentResult, khaltiInstance) {
        if (resultHandled) return;

        final resultPidx = paymentResult.payload?.pidx ?? '';
        logger.i('✅ onPaymentResult fired: pidx=$resultPidx');

        // Close Khalti WebView
        khaltiInstance.close(context);
        resultHandled = true;

        // Return pidx
        if (!completer.isCompleted) {
          completer.complete(resultPidx);
        }
      },

      // ✅ All events: cancel, error, network failure etc.
      onMessage:
          (
            khaltiInstance, {
            description,
            statusCode,
            event,
            needsPaymentConfirmation,
          }) {
            logger.w('Khalti event: $event | description: $description');

            if (resultHandled || completer.isCompleted) return;

            switch (event) {
              // User pressed back / closed Khalti
              case khalti.KhaltiEvent.kpgDisposed:
                logger.i('User closed Khalti page');
                completer.complete(null); // null = cancelled
                break;

              // No internet
              case khalti.KhaltiEvent.networkFailure:
                logger.e('Network failure during payment');
                completer.complete(null);
                break;

              // ⚠️ This fires even when payment succeeded (Khalti SDK quirk)
              // We ignore it and wait for onReturn instead
              case khalti.KhaltiEvent.paymentLookupfailure:
                logger.w(
                  'paymentLookupfailure fired (ignoring - waiting for onReturn)',
                );
                // Don't complete here - let onReturn handle it
                break;

              // Return URL failed to load - usually harmless
              case khalti.KhaltiEvent.returnUrlLoadFailure:
                logger.w('Return URL load failed (usually harmless)');
                break;

              // Unknown event - ignore
              case khalti.KhaltiEvent.unknown:
                logger.w('Unknown event, ignoring');
                break;

              default:
                logger.w('Unhandled event: $event');
                if (!resultHandled) {
                  completer.complete(null);
                }
            }
          },

      // ✅ THIS IS WHAT ACTUALLY FIRES FOR YOU
      // When return URL loads, we know payment succeeded
      onReturn: () {
        if (resultHandled || completer.isCompleted) return;

        logger.i('✅ onReturn fired - payment succeeded');

        // Close WebView immediately (user won't see HTML page)
        khaltiInstance?.close(context);
        resultHandled = true;

        // Return original pidx so we can verify with backend
        if (!completer.isCompleted) {
          completer.complete(pidx);
        }
      },
    );

    if (!context.mounted) {
      logger.w('Context not mounted before opening Khalti');
      return null;
    }

    // Open Khalti payment page
    khaltiInstance.open(context);

    // Wait for result (5 minute timeout)
    final result = await completer.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () {
        logger.e('Khalti payment timed out');
        return null;
      },
    );

    return result;
  }
}

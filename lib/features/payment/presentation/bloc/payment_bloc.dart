import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/features/payment/domain/repo/payment_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

@injectable
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepo repo;

  PaymentBloc(this.repo) : super(PaymentState()) {
    on<InitializePaymentEvent>(_onInitializePaymentEvent);

    on<VerifyPaymentEvent>(_onVerifyPaymentEvent);
    on<ResetStatesEvent>(_onResetStateEvent);
  }

  //Step 1: Called by ui when user taps enroll
  //yesma to get the pidx from the backend
  // UI will open khalti after this success

  FutureOr<void> _onInitializePaymentEvent(
    InitializePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (state.initializeStatus == ApiDataStatus.loading) {
      return;
    }
    emit(
      state.copyWith(
        initializeStatus: ApiDataStatus.loading,
        errorMessage: '',
        detailErrorMessage: '',
      ),
    );

    try {
      logger.i('Initializing payment for courseID: ${event.courseId}');

      final response = await repo.getPidx(event.courseId);

      if (!response.success || response.pidx == null) {
        logger.e('Failed to get pidx: \n Error: ${response.errorMessage}');
        emit(
          state.copyWith(
            initializeStatus: ApiDataStatus.error,
            errorMessage:
                response.errorMessage ?? 'Failed to start the payment',
          ),
        );
        return;
      }

      logger.i('Got the pidx: ${response.pidx}');

      //aba emit the pidx to the state and ui will pick from that and open the khalti

      emit(
        state.copyWith(
          initializeStatus: ApiDataStatus.success,
          pidx: response.pidx,
        ),
      );
    } catch (e, stack) {
      logger.e('Initialize payment error: $e', stackTrace: stack);
      emit(
        state.copyWith(
          initializeStatus: ApiDataStatus.error,
          errorMessage: 'Failed to start the payment. Please try again',
        ),
      );
    }
  }

  FutureOr<void> _onVerifyPaymentEvent(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    if (state.verifyStatus == ApiDataStatus.loading) {
      return;
    }

    emit(
      state.copyWith(
        verifyStatus: ApiDataStatus.loading,
        errorMessage: '',
        detailErrorMessage: '',
      ),
    );

    const maxAttempts = 5;
    const initialDelay = Duration(seconds: 3);
    const retryDelay = Duration(seconds: 5);

    //Wait before first check, give khalti some time to update the servers
    await Future.delayed(initialDelay);

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        logger.d('Verification Attempt $attempt of $maxAttempts');

        final response = await repo.verifyPayment(event.pidx);

        // ✅ Backend confirmed Payment

        if (response.isSucess) {
          logger.i('Payment verified on attempt $attempt');

          emit(
            state.copyWith(
              verifyStatus: ApiDataStatus.success,
              courseName: response.course ?? '',
              successMessage:
                  'You are now enrolled in ${response.course ?? 'the  course'} ',
            ),
          );
          return;
        }

        //if Still processing - retry again until the last attempt

        if (response.isPending && attempt < maxAttempts) {
          logger.w('Payment pending, retrying in ${retryDelay.inSeconds}s....');
          await Future.delayed(retryDelay);
          continue;
        }

        //Real Failure or Error
        logger.e('Verification Failed: \n Error: ${response.errorMessage}');

        emit(
          state.copyWith(
            verifyStatus: ApiDataStatus.error,
            errorMessage: 'Payment verification Failed',
            detailErrorMessage:
                '${response.errorMessage ?? "Could not verify Payment"} \n\n'
                'If money was deducted, please contact support with: \n'
                'pidx : ${event.pidx}',
          ),
        );
        return;
      } catch (e, s) {
        logger.e('Verification error attempt $attempt: $e', stackTrace: s);

        if (attempt >= maxAttempts) {
          emit(
            state.copyWith(
              verifyStatus: ApiDataStatus.error,
              errorMessage: 'Verification Failed',
              detailErrorMessage:
                  'Could not verify your payment after $maxAttempts attempts. \n'
                  'Please contact support if money was deducted',
            ),
          );
          return;
        }
        await Future.delayed(retryDelay);
      }
    }
  }

  FutureOr<void> _onResetStateEvent(
    ResetStatesEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentState());
  }
}

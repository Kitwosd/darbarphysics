import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/features/payment/domain/repo/package_payment_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package_payment_event.dart';

part 'package_payment_state.dart';

@injectable
class PackagePaymentBloc extends Bloc<PackagePaymentEvent, PackagePaymentState> {
  final PackagePaymentRepo repo;

  PackagePaymentBloc(this.repo) : super(const PackagePaymentState()) {
    on<InitializePackagePaymentEvent>(_onInitializePackagePaymentEvent);
    on<VerifyPackagePaymentEvent>(_onVerifyPackagePaymentEvent);
    on<ResetPackageStatesEvent>(_onResetStateEvent);
  }

  FutureOr<void> _onInitializePackagePaymentEvent(
    InitializePackagePaymentEvent event,
    Emitter<PackagePaymentState> emit,
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
      logger.i('Initializing payment for packageID: ${event.packageId}');

      final response = await repo.getPackagePidx(event.packageId);

      if (!response.success || response.pidx == null) {
        logger.e('Failed to get pidx: \n Error: ${response.errorMessage}');
        emit(
          state.copyWith(
            initializeStatus: ApiDataStatus.error,
            errorMessage:
                response.errorMessage ?? 'Failed to start the package payment',
          ),
        );
        return;
      }

      logger.i('Got the pidx: ${response.pidx}');

      emit(
        state.copyWith(
          initializeStatus: ApiDataStatus.success,
          pidx: response.pidx,
        ),
      );
    } catch (e, stack) {
      logger.e('Initialize package payment error: $e', stackTrace: stack);
      emit(
        state.copyWith(
          initializeStatus: ApiDataStatus.error,
          errorMessage: 'Failed to start the package payment. Please try again',
        ),
      );
    }
  }

  FutureOr<void> _onVerifyPackagePaymentEvent(
    VerifyPackagePaymentEvent event,
    Emitter<PackagePaymentState> emit,
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

        final response = await repo.verifyPackagePayment(event.pidx);

        // ✅ Backend confirmed Payment
        if (response.isSucess) {
          logger.i('Package Payment verified on attempt $attempt');

          emit(
            state.copyWith(
              verifyStatus: ApiDataStatus.success,
              packageName: response.packageName ?? '',
              successMessage:
                  'You have successfully unlocked ${response.packageName ?? 'the package'}',
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
            errorMessage: 'Package payment verification failed',
            detailErrorMessage:
                '${response.errorMessage ?? "Could not verify package payment"} \n\n'
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
    ResetPackageStatesEvent event,
    Emitter<PackagePaymentState> emit,
  ) {
    emit(const PackagePaymentState());
  }
}

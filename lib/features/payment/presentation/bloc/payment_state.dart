


part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final ApiDataStatus initializeStatus;
  final ApiDataStatus processStatus;
  final ApiDataStatus verifyStatus;

  final String? pidx;
  final String? transactionId;
  final String? courseName;
  final String errorMessage;
  final String detailErrorMessage;
  final String successMessage;
  const PaymentState({
    this.initializeStatus = ApiDataStatus.initial,
    this.processStatus = ApiDataStatus.initial,
    this.verifyStatus = ApiDataStatus.initial,
    this.pidx,
    this.transactionId,
    this.courseName,
    this.errorMessage = '',
    this.detailErrorMessage = '',
    this.successMessage = '',
  });

  @override
  List<Object?> get props {
    return [
      initializeStatus,
      processStatus,
      verifyStatus,
      pidx,
      transactionId,
      courseName,
      errorMessage,
      detailErrorMessage,
      successMessage,
    ];
  }

  PaymentState copyWith({
    ApiDataStatus? initializeStatus,
    ApiDataStatus? processStatus,
    ApiDataStatus? verifyStatus,
    String? pidx,
    String? transactionId,
    String? courseName,
    String? errorMessage,
    String? detailErrorMessage,
    String? successMessage,
  }) {
    return PaymentState(
      initializeStatus: initializeStatus ?? this.initializeStatus,
      processStatus: processStatus ?? this.processStatus,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      pidx: pidx ?? this.pidx,
      transactionId: transactionId ?? this.transactionId,
      courseName: courseName ?? this.courseName,
      errorMessage: errorMessage ?? this.errorMessage,
      detailErrorMessage: detailErrorMessage ?? this.detailErrorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

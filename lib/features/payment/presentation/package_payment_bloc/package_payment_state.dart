part of 'package_payment_bloc.dart';

class PackagePaymentState extends Equatable {
  final ApiDataStatus initializeStatus;
  final ApiDataStatus processStatus;
  final ApiDataStatus verifyStatus;

  final String? pidx;
  final String? transactionId;
  final String? packageName;
  final String errorMessage;
  final String detailErrorMessage;
  final String successMessage;
  const PackagePaymentState({
    this.initializeStatus = ApiDataStatus.initial,
    this.processStatus = ApiDataStatus.initial,
    this.verifyStatus = ApiDataStatus.initial,
    this.pidx,
    this.transactionId,
    this.packageName,
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
      packageName,
      errorMessage,
      detailErrorMessage,
      successMessage,
    ];
  }

  PackagePaymentState copyWith({
    ApiDataStatus? initializeStatus,
    ApiDataStatus? processStatus,
    ApiDataStatus? verifyStatus,
    String? pidx,
    String? transactionId,
    String? packageName,
    String? errorMessage,
    String? detailErrorMessage,
    String? successMessage,
  }) {
    return PackagePaymentState(
      initializeStatus: initializeStatus ?? this.initializeStatus,
      processStatus: processStatus ?? this.processStatus,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      pidx: pidx ?? this.pidx,
      transactionId: transactionId ?? this.transactionId,
      packageName: packageName ?? this.packageName,
      errorMessage: errorMessage ?? this.errorMessage,
      detailErrorMessage: detailErrorMessage ?? this.detailErrorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

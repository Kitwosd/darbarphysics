import 'package:equatable/equatable.dart';

sealed class PackagePaymentEvent extends Equatable {
  const PackagePaymentEvent();

  @override
  List<Object> get props => [];
}

class InitializePackagePaymentEvent extends PackagePaymentEvent {
  final int packageId;
  const InitializePackagePaymentEvent({required this.packageId});
}

class VerifyPackagePaymentEvent extends PackagePaymentEvent {
  final String pidx;
  const VerifyPackagePaymentEvent({required this.pidx});
}

class ResetPackageStatesEvent extends PackagePaymentEvent {}

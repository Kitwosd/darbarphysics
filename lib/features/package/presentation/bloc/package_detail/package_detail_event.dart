import 'package:equatable/equatable.dart';

sealed class PackageDetailEvent extends Equatable {
  const PackageDetailEvent();

  @override
  List<Object> get props => [];
}

class GetPackageDetailEvent extends PackageDetailEvent {
  final int packageId;
  const GetPackageDetailEvent({required this.packageId});

  @override
  List<Object> get props => [packageId];
}

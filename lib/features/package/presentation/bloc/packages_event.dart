import 'package:equatable/equatable.dart';

sealed class PackageEvent extends Equatable {
  const PackageEvent();

  @override
  List<Object> get props => [];
}

class GetPackagesEvent extends PackageEvent {}

class LoadMorePackagesEvent extends PackageEvent {}

enum PackageSortOrder { newest, priceLowToHigh, priceHighToLow, mostPopular }

class ChangeSortEvent extends PackageEvent {
  final PackageSortOrder sortOrder;
  const ChangeSortEvent(this.sortOrder);

  @override
  List<Object> get props => [sortOrder];
}
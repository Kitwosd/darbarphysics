import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/package/data/model/package_model.dart';
import 'package:durbar_physics/features/package/presentation/bloc/packages_event.dart';
import 'package:equatable/equatable.dart';

class PackageState extends Equatable {
  final ApiDataStatus status;
  final List<PackageModel> packages;
  final String errorMessage;
  final int page;
  final bool hasReachedMax;
  final PackageSortOrder sortOrder;

  const PackageState({
    this.status = ApiDataStatus.initial,
    this.packages = const [],
    this.errorMessage = '',
    this.page = 1,
    this.hasReachedMax = false,
    this.sortOrder = PackageSortOrder.newest,
  });

  List<PackageModel> get filteredAndSortedPackages {
    // 1. Filter only active packages
    final activePackages = packages.where((p) => p.isActive).toList();

    // 2. Apply sorting
    switch (sortOrder) {
      case PackageSortOrder.newest:
        // Assuming higher ID means newer, or use createdAt if preferred
        activePackages.sort((a, b) => b.id.compareTo(a.id));
        break;
      case PackageSortOrder.priceLowToHigh:
        activePackages.sort((a, b) {
          final priceA = double.tryParse(a.price) ?? 0;
          final priceB = double.tryParse(b.price) ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case PackageSortOrder.priceHighToLow:
        activePackages.sort((a, b) {
          final priceA = double.tryParse(a.price) ?? 0;
          final priceB = double.tryParse(b.price) ?? 0;
          return priceB.compareTo(priceA);
        });
        break;
      case PackageSortOrder.mostPopular:
        activePackages.sort((a, b) => b.courseCount.compareTo(a.courseCount));
        break;
    }

    return activePackages;
  }

  @override
  List<Object?> get props => [
    status,
    packages,
    errorMessage,
    page,
    hasReachedMax,
    sortOrder,
  ];

  PackageState copyWith({
    ApiDataStatus? status,
    List<PackageModel>? packages,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
    PackageSortOrder? sortOrder,
  }) {
    return PackageState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
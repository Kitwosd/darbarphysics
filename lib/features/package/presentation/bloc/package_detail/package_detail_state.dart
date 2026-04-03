import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/package/data/model/package_detail_model.dart';
import 'package:equatable/equatable.dart';

class PackageDetailState extends Equatable {
  final ApiDataStatus status;
  final PackageDetailModel? package;
  final String errorMessage;

  const PackageDetailState({
    this.status = ApiDataStatus.initial,
    this.package,
    this.errorMessage = '',
  });

  PackageDetailState copyWith({
    ApiDataStatus? status,
    PackageDetailModel? package,
    String? errorMessage,
  }) {
    return PackageDetailState(
      status: status ?? this.status,
      package: package ?? this.package,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, package, errorMessage];
}

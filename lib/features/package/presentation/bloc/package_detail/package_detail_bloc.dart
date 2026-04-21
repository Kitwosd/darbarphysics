import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/package/domain/repo/packages_repo.dart';
import 'package:injectable/injectable.dart';

import 'package_detail_event.dart';
import 'package_detail_state.dart';

@injectable
class PackageDetailBloc extends Bloc<PackageDetailEvent, PackageDetailState> {
  final PackageRepo repo;

  PackageDetailBloc(this.repo) : super(const PackageDetailState()) {
    on<GetPackageDetailEvent>(_onGetPackageDetailEvent);
  }

  FutureOr<void> _onGetPackageDetailEvent(
    GetPackageDetailEvent event,
    Emitter<PackageDetailState> emit,
  ) async {
    emit(state.copyWith(status: ApiDataStatus.loading));

    try {
      final package = await repo.getPackageDetail(event.packageId);
      emit(state.copyWith(
        status: ApiDataStatus.success,
        package: package,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ApiDataStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}

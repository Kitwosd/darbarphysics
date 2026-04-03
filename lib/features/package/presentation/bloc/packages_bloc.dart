import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/package/domain/repo/packages_repo.dart';
import 'package:durbar_physics/features/package/presentation/bloc/packages_event.dart';
import 'package:durbar_physics/features/package/presentation/bloc/packages_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final PackageRepo repo;

  PackageBloc(this.repo) : super(const PackageState()) {
    on<GetPackagesEvent>(_onGetPackagesEvent);
    on<LoadMorePackagesEvent>(_onLoadMorePackagesEvent);
    on<ChangeSortEvent>(_onChangeSortEvent);
  }

  FutureOr<void> _onGetPackagesEvent(
    GetPackagesEvent event,
    Emitter<PackageState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApiDataStatus.loading));
      final response = await repo.getPackages(page: 1);
      emit(state.copyWith(
        status: ApiDataStatus.success,
        packages: response.results,
        page: 2,
        hasReachedMax: response.next == null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ApiDataStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  FutureOr<void> _onLoadMorePackagesEvent(
    LoadMorePackagesEvent event,
    Emitter<PackageState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      final response = await repo.getPackages(page: state.page);
      final updatedList = List.of(state.packages)..addAll(response.results);
      emit(state.copyWith(
        packages: updatedList,
        page: state.page + 1,
        status: ApiDataStatus.success,
        hasReachedMax: response.next == null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ApiDataStatus.error,
        errorMessage: 'Something wrong happened during loading more packages',
      ));
    }
  }

  FutureOr<void> _onChangeSortEvent(
    ChangeSortEvent event,
    Emitter<PackageState> emit,
  ) {
    emit(state.copyWith(sortOrder: event.sortOrder));
  }
}
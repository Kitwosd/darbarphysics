import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/courses/data/model/banner_model.dart';
import 'package:durbar_physics/features/courses/domain/repo/courses_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'banner_event.dart';
part 'banner_state.dart';

@injectable
class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final CoursesRepo repo;
  BannerBloc(this.repo) : super(BannerState()) {
    on<GetBannerItems>(_onGetBannerItems);
  }

  FutureOr<void> _onGetBannerItems(
    GetBannerItems event,
    Emitter<BannerState> emit,
  ) async {
    emit(state.copyWith(status: ApiDataStatus.loading));

    try {
      final bannerItems = await repo.getBannerItems();
      emit(
        state.copyWith(status: ApiDataStatus.success, bannerItems: bannerItems),
      );
    } catch (e) {
      emit(state.copyWith(status: ApiDataStatus.error));
    }
  }
}

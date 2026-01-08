import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:durbar_physics/features/live_classes/domain/repos/live_classes_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'live_classes_event.dart';
part 'live_classes_state.dart';

@injectable
class LiveClassesBloc extends Bloc<LiveClassesEvent, LiveClassesState> {
  final LiveClassesRepo liveClassesRepo;

  LiveClassesBloc(this.liveClassesRepo) : super(const LiveClassesState()) {
    on<GetLiveClassesEvent>((event, emit) async {
      emit(state.copyWith(status: ApiDataStatus.loading));
      try {
        final liveClasses = await liveClassesRepo.getLiveClasses();
        emit(
          state.copyWith(
            liveClasses: liveClasses,
            status: ApiDataStatus.success,
          ),
        );
      } catch (e) {
        log(e.toString());
        emit(state.copyWith(status: ApiDataStatus.error, error: e.toString()));
      }
    });
  }
}

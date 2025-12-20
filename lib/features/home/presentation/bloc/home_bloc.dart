import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/data/models/class_model.dart';

import 'package:durbar_physics/features/home/data/models/stream_model.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/home/domain/repos/home_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo homeRepo;

  HomeBloc(this.homeRepo) : super(HomeState()) {
    on<GetHomeData>((event, emit) async {
      emit(state.copyWith(status: ApiDataStatus.loading));
      try {
        final courses = await homeRepo.getCourses();
        final classes = await homeRepo.getClasses();
        final streams = await homeRepo.getStreams();

        final videos = await homeRepo.getVideos();

        emit(
          state.copyWith(
            courses: courses,
            classes: classes,
            streams: streams,

            videos: videos,
            status: ApiDataStatus.success,
          ),
        );
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });
  }
}

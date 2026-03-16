import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/courses/data/model/document_model.dart';
import 'package:durbar_physics/features/courses/domain/repo/courses_repo.dart';

import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'document_state.dart';

@injectable
class DocumentCubit extends Cubit<DocumentState> {
  CoursesRepo repo;
  DocumentCubit(this.repo) : super(DocumentState());

  Future<void> getCourseDocuments({required int courseId}) async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final documents = await repo.getDocuments(courseId, page: 1);
      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          documents: documents.results,
          page: state.page + 1,
          hasReachedMax: documents.next == null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ApiDataStatus.error));
    }
  }
}

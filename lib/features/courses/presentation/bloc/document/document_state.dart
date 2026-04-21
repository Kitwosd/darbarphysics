part of 'document_cubit.dart';

class DocumentState extends Equatable {
  final ApiDataStatus status;
  final List<DocumentModel> documents;
  final int courseId;
  final int page;
  final bool hasReachedMax;

  const DocumentState({
    this.status = ApiDataStatus.initial,
    this.documents = const [],
    this.courseId = 0,
    this.page = 1,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props {
    return [status, documents, courseId, page, hasReachedMax];
  }

  DocumentState copyWith({
    ApiDataStatus? status,
    List<DocumentModel>? documents,
    int? courseId,
    int? page,
    bool? hasReachedMax,
  }) {
    return DocumentState(
      status: status ?? this.status,
      documents: documents ?? this.documents,
      courseId: courseId ?? this.courseId,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

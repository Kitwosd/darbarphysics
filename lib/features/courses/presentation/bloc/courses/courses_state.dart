part of 'courses_bloc.dart';

class CoursesState extends Equatable {
  final List<CourseModel> coursesList;
  final ApiDataStatus status;
  final String error;
  final CourseDetailModel? course;
  final ApiDataStatus courseDetailStatus;
  final bool hasReachedMax;
  final int currentPage;
  final CourseSortOrder sortOrder;

  const CoursesState({
    this.coursesList = const [],
    this.status = ApiDataStatus.initial,
    this.error = '',
    this.course,
    this.courseDetailStatus = ApiDataStatus.initial,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.sortOrder = CourseSortOrder.newest,
  });

  List<CourseModel> get filteredAndSortedCourses {
    // 1. Filter out courses that don't need sorting or already empty
    final list = List<CourseModel>.from(coursesList);

    // 2. Apply local sorting
    switch (sortOrder) {
      case CourseSortOrder.newest:
        list.sort((a, b) => b.id.compareTo(a.id));
        break;
      case CourseSortOrder.priceLowToHigh:
        list.sort((a, b) {
          final priceA = double.tryParse(a.cost) ?? 0.0;
          final priceB = double.tryParse(b.cost) ?? 0.0;
          return priceA.compareTo(priceB);
        });
        break;
      case CourseSortOrder.priceHighToLow:
        list.sort((a, b) {
          final priceA = double.tryParse(a.cost) ?? 0.0;
          final priceB = double.tryParse(b.cost) ?? 0.0;
          return priceB.compareTo(priceA);
        });
        break;
      case CourseSortOrder.mostPopular:
        list.sort((a, b) => b.studentCount.compareTo(a.studentCount));
        break;
    }

    return list;
  }

  CoursesState copyWith({
    List<CourseModel>? coursesList,
    ApiDataStatus? status,
    String? error,
    CourseDetailModel? course,
    ApiDataStatus? courseDetailStatus,
    bool? hasReachedMax,
    int? currentPage,
    CourseSortOrder? sortOrder,
  }) {
    return CoursesState(
      coursesList: coursesList ?? this.coursesList,
      status: status ?? this.status,
      error: error ?? this.error,
      course: course ?? this.course,
      courseDetailStatus: courseDetailStatus ?? this.courseDetailStatus,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
    coursesList,
    status,
    error,
    course,
    courseDetailStatus,
    hasReachedMax,
    currentPage,
    sortOrder,
  ];
}

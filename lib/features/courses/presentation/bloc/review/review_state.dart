part of 'review_bloc.dart';

enum ReviewStatus { initial, loading, success, error, submitting }

class ReviewState extends Equatable {
  final double selectedRating;
  final int characterCount;
  final bool isMinCharacterMet;
  final bool isSubmitEnabled;
  final String review;
  final ReviewStatus status;
  final String errorMessage;
  final PostReviewModel? postReview;
  final bool hasAlreadyReviewed;
  final String successMessage;
  final List<ReviewModel> reviewsList;
  final ApiDataStatus reviewsListStatus;
  final int page;
  final bool hasReachedMax;


  const ReviewState({
    this.selectedRating = 0,
    this.characterCount = 0,
    this.isMinCharacterMet = false,
    this.isSubmitEnabled = false,
    this.review = '',
    this.status = ReviewStatus.initial,
    this.errorMessage = '',
    this.postReview,
    this.hasAlreadyReviewed = false,
    this.successMessage = '',
    this.reviewsList = const [],
    this.reviewsListStatus = ApiDataStatus.initial,
    this.page = 1,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props {
    return [
      selectedRating,
      characterCount,
      isMinCharacterMet,
      isSubmitEnabled,
      review,
      status,
      errorMessage,
      ?postReview,
      hasAlreadyReviewed,
      successMessage,
      reviewsList,
      reviewsListStatus,
      page,
      hasReachedMax,
    ];
  }

  ReviewState copyWith({
    double? selectedRating,
    int? characterCount,
    bool? isMinCharacterMet,
    bool? isSubmitEnabled,
    String? review,
    ReviewStatus? status,
    String? errorMessage,
    PostReviewModel? postReview,
    bool? hasAlreadyReviewed,
    String? successMessage,
    List<ReviewModel>? reviewsList,
    ApiDataStatus? reviewsListStatus,
    int? page,
    bool? hasReachedMax,
  }) {
    return ReviewState(
      selectedRating: selectedRating ?? this.selectedRating,
      characterCount: characterCount ?? this.characterCount,
      isMinCharacterMet: isMinCharacterMet ?? this.isMinCharacterMet,
      isSubmitEnabled: isSubmitEnabled ?? this.isSubmitEnabled,
      review: review ?? this.review,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      postReview: postReview ?? this.postReview,
      hasAlreadyReviewed: hasAlreadyReviewed ?? this.hasAlreadyReviewed,
      successMessage: successMessage ?? this.successMessage,
      reviewsList: reviewsList ?? this.reviewsList,
      reviewsListStatus: reviewsListStatus ?? this.reviewsListStatus,
      page: page ?? this.page,
      hasReachedMax : hasReachedMax ?? this.hasReachedMax
    );
  }
}

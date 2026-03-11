import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/network/api_exception.dart';
import 'package:durbar_physics/features/courses/data/model/course_review/post_review_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_review/review_model.dart';
import 'package:durbar_physics/features/courses/domain/repo/courses_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'review_event.dart';
part 'review_state.dart';

@injectable
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  CoursesRepo repo;
  ReviewBloc(this.repo) : super(ReviewState()) {
    on<GetReviewsEvent>(_onGetReviewsEvent);
    on<RatingSelectedEvent>(_onRatingSelectedEvent);
    on<ReviewTextChangedEvent>(_onReviewTextChangedEvent);
    on<PostReviewEvent>(_onPostReviewEvent);
    on<LoadMoreReviewsEvent>(_onLoadMoreReviewsEvent);
  }

  FutureOr<void> _onGetReviewsEvent(
    GetReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(reviewsListStatus: ApiDataStatus.loading));
    try {
      final reviews = await repo.getReviews(event.courseId, page: 1);
      emit(
        state.copyWith(
          reviewsListStatus: ApiDataStatus.success,
          reviewsList: reviews.results,
          page: state.page + 1,
          hasReachedMax: reviews.next == null,
        ),
      );
    } catch (e) {
      // print("GET REVIEWS ERROR: $e");
      // print("STACK TRACE: $stackTrace");
      emit(state.copyWith(reviewsListStatus: ApiDataStatus.error));
    }
  }

  FutureOr<void> _onRatingSelectedEvent(
    RatingSelectedEvent event,
    Emitter<ReviewState> emit,
  ) {
    final isSubmitEnabled = event.rating > 0 && state.isMinCharacterMet;

    emit(
      state.copyWith(
        selectedRating: event.rating,
        isSubmitEnabled: isSubmitEnabled,
      ),
    );
  }

  FutureOr<void> _onReviewTextChangedEvent(
    ReviewTextChangedEvent event,
    Emitter<ReviewState> emit,
  ) {
    final characterCount = event.text.trim().length;
    final isMinCharacterMet = characterCount >= 10;
    final isSubmitEnabled = state.selectedRating > 0 && isMinCharacterMet;
    emit(
      state.copyWith(
        review: event.text,
        isMinCharacterMet: isMinCharacterMet,
        isSubmitEnabled: isSubmitEnabled,
        characterCount: characterCount,
      ),
    );
  }

  FutureOr<void> _onPostReviewEvent(
    PostReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.submitting));
    try {
      final response = await repo.postReview(
        PostReviewModel(
          course: event.courseId,
          rating: state.selectedRating,
          review: state.review,
        ),
      );
      emit(
        state.copyWith(status: ReviewStatus.success, successMessage: response),
      );
    } catch (e) {
      if (e is ApiException && e.response is Map<String, dynamic>) {
        final data = e.response as Map<String, dynamic>;

        emit(
          state.copyWith(
            status: ReviewStatus.error,
            errorMessage: data['error'] ?? 'Something went wrong',
          ),
        );
      }
    }
  }

  FutureOr<void> _onLoadMoreReviewsEvent(
    LoadMoreReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      final response = await repo.getReviews(event.courseId, page: state.page);
      final updateList = List.of(state.reviewsList)..addAll(response.results);
      emit(
        state.copyWith(
          reviewsList: updateList,
          reviewsListStatus: ApiDataStatus.success,
          page: state.page + 1,
          hasReachedMax: response.next == null,
        ),
      );
    } catch (e) {
      state.copyWith(
        reviewsListStatus: ApiDataStatus.error,
        errorMessage: 'Something went wrong during loading more reviews',
      );
    }
  }
}

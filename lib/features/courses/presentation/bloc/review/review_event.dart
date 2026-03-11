// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'review_bloc.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class RatingSelectedEvent extends ReviewEvent {
  final double rating;
  const RatingSelectedEvent({required this.rating});
}

class ReviewTextChangedEvent extends ReviewEvent {
  final String text;
  const ReviewTextChangedEvent({required this.text});
}

class GetReviewsEvent extends ReviewEvent {
  final int courseId;
  const GetReviewsEvent({required this.courseId});
}

class LoadMoreReviewsEvent extends ReviewEvent {
  final int courseId;
  const LoadMoreReviewsEvent({required this.courseId});
}

class PostReviewEvent extends ReviewEvent {
  final int courseId;
  const PostReviewEvent({required this.courseId});
}

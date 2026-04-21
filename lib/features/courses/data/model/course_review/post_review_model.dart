class PostReviewModel {
  final int course;
  final double rating;
  final String review;

  const PostReviewModel({
    required this.course,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toJson() {
    return {'course': course, 'rating': rating, 'review': review};
  }
}
